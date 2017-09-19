/*
    Author: _SCAR

    Description:
    Request new workers. The missing workers up to maximum specified in settings will be created.

    Parameter(s):
    0: OBJECT - The store.
    1: UNIT - The unit calling this function.

    Return:
    0: BOOLEAN

    Example:
    [_store, player] call SCAR_UCM_fnc_requestWorkers;
*/

if !(isServer) exitWith {};

params ["_store", "_caller"];

// vars
private _workers          = _store getVariable "SCAR_UCM_workers";
private _workersCount     = _store getVariable "SCAR_UCM_workersCount";
private _helicopterClass  = _store getVariable "SCAR_UCM_helicopterClass";
private _helicopterOrigin = _store getVariable "SCAR_UCM_helicopterOrigin";
private _foreman          = _store getVariable "SCAR_UCM_foreman";
private _heliPad          = _store getVariable "SCAR_UCM_heliPad";
private _side             = _store getVariable "SCAR_UCM_side";

if ((count _workers) >= _workersCount) exitWith {
    // chat
    [_side, "HQ"] sideChat format[(localize "STR_SCAR_UCM_Radio_ErrorRequestWorkersAlreadyMaxed"), _workersCount];
    // return
    false
};

// how many?
_workersCount = _workersCount - (count _workers);
if (_workersCount < 1) exitWith {};

// create helicopter with crew
private _size = sizeOf _helicopterClass;
private _helicopterOriginPos = getPos _helicopterOrigin;
private _helicopterOriginWorkersPos = [
    (_helicopterOriginPos select 0) - 2 * _size,
    (_helicopterOriginPos select 1) - 2 * _size,
    (_helicopterOriginPos select 2)
];
private _result  = [_helicopterOriginWorkersPos, 0, _helicopterClass, _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _group   = _result select 2;

// set safety valve on object
[_vehicle, _crew] call SCAR_UCM_fnc_safetyDeleteVehicleAndCrew;

// set careless
_group setBehaviour "CARELESS";

// create workers
private _newWorkers = [_store, _workersCount, _vehicle] call SCAR_UCM_fnc_createWorkers;

// destination
private _destinationPos = getPos _heliPad;
_destinationPos = [_destinationPos select 0, _destinationPos select 1, 0];

// event
["SCAR_UCM_RequestedWorkers", [_store]] call CBA_fnc_serverEvent;

// radio
[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_RequestedWorkers")] remoteExec ["sideChat"];

// waypoints

// --> heli: unload
private _wpUnload = _group addWaypoint [_destinationPos, 0];
_wpUnload setWaypointType "TR UNLOAD";

// --> cargo: get out
_destinationPos = getPos _foreman;
{
    _wp = (group _x) addWaypoint [_destinationPos, 0];
    _wp setWaypointType "GETOUT";
} forEach _newWorkers;

// --> heli: leave
private _wpLeave = _group addWaypoint [_helicopterOriginWorkersPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];

// --> cargo: move
_destinationPos = getPos _foreman;
{
    _wp = (group _x) addWaypoint [_destinationPos, 10];
    _wp setWaypointType "MOVE";
} forEach _newWorkers;

// return
true
