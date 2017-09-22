/*
    Author: _SCAR

    Description:
    Request new workers. The missing workers up to maximum specified in settings will be created.
    This is an action callback.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: UNIT - The unit calling this function.

    Return:
    0: BOOLEAN

    Example:
    [_logicModule, player] call SCAR_UCM_fnc_requestMaterial;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_caller"];

private _onGoing = _logicModule getVariable ["SCAR_UCM_requestMaterialOngoing", false];
private _side    = _logicModule getVariable "SCAR_UCM_side";

if (_onGoing) exitWith {
    // chat
    [_side, "HQ"] sideChat (localize "STR_SCAR_UCM_Radio_ErrorRequestMaterialsAlreadyInProgress");
    // return
    false
};

// flag
_logicModule setVariable ["SCAR_UCM_requestMaterialOngoing", true, true];

// vars
private _helicopterClass  = _logicModule getVariable "SCAR_UCM_helicopterClass";
private _helicopterOrigin = _logicModule getVariable "SCAR_UCM_helicopterOrigin";
private _foreman          = _logicModule getVariable "SCAR_UCM_foreman";
private _heliPad          = _logicModule getVariable "SCAR_UCM_heliPad";

// create helicopter with crew
private _size = sizeOf _helicopterClass;
private _helicopterOriginPos = getPos _helicopterOrigin;
private _helicopterOriginMaterialPos = _helicopterOriginPos getPos [2 * _size, -45];

private _result  = [_helicopterOriginMaterialPos, 0, _helicopterClass, _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _group   = _result select 2;

// set safety valve on object
[_vehicle, _crew] call SCAR_UCM_fnc_safetyDeleteVehicleAndCrew;

// event
["UCM_RequestedMaterials", [_logicModule]] call CBA_fnc_serverEvent;

// radio
[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_RequestedMaterials")] remoteExec ["sideChat"];

// waypoints

// --> heli: unload
_vehicle setVariable ["_logicModule", _logicModule, true];
private _wpUnload = _group addWaypoint [getPos _heliPad, 0];
_wpUnload setWaypointType "MOVE";
_wpUnload setWaypointStatements ["true", "_vehicle = (vehicle this); _logicModule = _vehicle getVariable '_logicModule'; [_logicModule, _vehicle] spawn SCAR_UCM_fnc_dropMaterialFromHelicopter;"];

// --> heli: leave
private _wpLeave = _group addWaypoint [_helicopterOriginMaterialPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];

// flag
_logicModule setVariable ["SCAR_UCM_requestMaterialOngoing", false, true];

// return
true
