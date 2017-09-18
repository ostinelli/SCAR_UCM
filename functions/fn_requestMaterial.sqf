/*
	Author: _SCAR

	Description:
	Request new workers. The missing workers up to maximum specified in settings will be created.
	This is an action callback.

	Parameter(s):
	0: OBJECT - The store.
	1: UNIT - The unit calling this function.

	Return:
	0: BOOLEAN

	Example:
	[_store, player] call SCAR_UCM_fnc_requestMaterial;
*/

if !(isServer) exitWith {};

params ["_store", "_caller"];

private _onGoing = _store getVariable ["SCAR_UCM_requestMaterialOngoing", false];
private _side    = _store getVariable "SCAR_UCM_side";

if (_onGoing) exitWith {
	// chat
	[_side, "HQ"] sideChat (localize "STR_SCAR_UCM_Radio_ErrorRequestMaterialsAlreadyInProgress");
	// return
	false
};

// flag
_store setVariable ["SCAR_UCM_requestMaterialOngoing", true, true];

// vars
private _helicopterClass  = _store getVariable "SCAR_UCM_helicopterClass";
private _helicopterOrigin = _store getVariable "SCAR_UCM_helicopterOrigin";
private _workersBoss      = _store getVariable "SCAR_UCM_workersBoss";
private _heliPad          = _store getVariable "SCAR_UCM_heliPad";

// create helicopter with crew
private _size = sizeOf _helicopterClass;
private _helicopterOriginPos = getPos _helicopterOrigin;
private _helicopterOriginMaterialPos = [
	(_helicopterOriginPos select 0) + 2 * _size,
	(_helicopterOriginPos select 1) + 2 * _size,
	(_helicopterOriginPos select 2)
];
private _result  = [_helicopterOriginMaterialPos, 0, _helicopterClass, _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _group   = _result select 2;

// set safety valve on object
[_vehicle, _crew] call SCAR_UCM_fnc_safetyDeleteVehicleAndCrew;

// event
["SCAR_UCM_RequestedMaterials", [_store]] call CBA_fnc_serverEvent;

// radio
[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_RequestedMaterials")] remoteExec ["sideChat"];

// waypoints

// --> heli: unload
_vehicle setVariable ["_store", _store, true];
private _wpUnload = _group addWaypoint [getPos _heliPad, 0];
_wpUnload setWaypointType "MOVE";
_wpUnload setWaypointStatements ["true", "_vehicle = (vehicle this); _store = _vehicle getVariable '_store'; [_store, _vehicle] spawn SCAR_UCM_fnc_dropMaterialFromHelicopter;"];

// --> heli: leave
private _wpLeave = _group addWaypoint [_helicopterOriginMaterialPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];

// flag
_store setVariable ["SCAR_UCM_requestMaterialOngoing", false, true];

// return
true
