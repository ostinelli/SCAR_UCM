/*
    Author: _SCAR

    Description:
    Request new workers. The missing workers up to maximum specified in settings will be created.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: UNIT - The unit calling this function.

    Return:
    0: BOOLEAN

    Example:
    [_logicModule, player] call SCAR_UCM_fnc_requestWorkers;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_caller"];

// vars
private _workers          = _logicModule getVariable "SCAR_UCM_workers";
private _workersCount     = _logicModule getVariable "SCAR_UCM_workersCount";
private _helicopterClass  = _logicModule getVariable "SCAR_UCM_helicopterClass";
private _helicopterOrigin = _logicModule getVariable "SCAR_UCM_helicopterOrigin";
private _heliPad          = _logicModule getVariable "SCAR_UCM_heliPad";
private _side             = _logicModule getVariable "SCAR_UCM_side";

if ((count _workers) >= _workersCount) exitWith {
    // chat only to caller
    [_side, "STR_SCAR_UCM_Radio_ErrorRequestWorkersAlreadyMaxed"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", _caller];
    // return
    false
};

// how many?
_workersCount = _workersCount - (count _workers);
if (_workersCount < 1) exitWith {};

// create helicopter with crew
private _size = sizeOf _helicopterClass;
private _helicopterOriginPos = getPos _helicopterOrigin;
private _helicopterOriginWorkersPos = _helicopterOriginPos getPos [2 * _size, 45];

private _result  = [_helicopterOriginWorkersPos, 0, _helicopterClass, _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _group   = _result select 2;

// set safety valve on object
[_vehicle, _crew] call SCAR_UCM_fnc_safetyDeleteVehicleAndCrew;

// set careless
_group setBehaviour "CARELESS";
_group allowFleeing 0;
{
    _x setSkill ["courage", 1];
    _x setSkill ["spotDistance", 0];
    _x setSkill ["spotTime", 0];
} forEach _crew;

// create workers
private _newWorkers = [_logicModule, _workersCount, _vehicle] call SCAR_UCM_fnc_createWorkers;

// destination
private _destinationPos = getPos _heliPad;
_destinationPos = [_destinationPos select 0, _destinationPos select 1, 0];

// event
["UCM_RequestedWorkers", [_logicModule]] call CBA_fnc_serverEvent;

// radio
[_side, "STR_SCAR_UCM_Radio_RequestedWorkers"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];

// waypoints
// --> heli: unload
private _wpUnload = _group addWaypoint [_destinationPos, 0];
_wpUnload setWaypointType "TR UNLOAD";
_wpUnload setWaypointStatements ["true", "(vehicle this) land 'GET OUT';"];

// --> cargo: get out
{
    _wp = (group _x) addWaypoint [_destinationPos, 0];
    _wp setWaypointType "GETOUT";
    _wp setWaypointStatements ["true",
        "private _group = group this;" +
        "[_group] call SCAR_UCM_fnc_deleteAllWaypoints;"
    ];
} forEach _newWorkers;

// --> heli: leave
private _wpLeave = _group addWaypoint [_helicopterOriginWorkersPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];

// return
true
