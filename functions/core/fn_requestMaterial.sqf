/*
    Author: _SCAR

    Description:
    Request new workers. The missing workers up to maximum specified in settings will be created.
    This is an action callback.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: UNIT - The unit calling this function.

    Return:
    BOOLEAN

    Example:
    [_logicModule, player] call SCAR_UCM_fnc_requestMaterial;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_caller"];

// vars
private _onGoing                          = _logicModule getVariable ["SCAR_UCM_requestMaterialOngoing", false];
private _side                             = _logicModule getVariable "SCAR_UCM_side";
private _materialsAvailabilityIntervalSec = _logicModule getVariable "SCAR_UCM_materialsAvailabilityIntervalSec";
private _lastMaterialRequestTime          = _logicModule getVariable ["SCAR_UCM_lastMaterialRequestTime", time - _materialsAvailabilityIntervalSec];

// ongoing?
if (_onGoing) exitWith {
    // chat only to caller
    [_side, "STR_SCAR_UCM_Radio_ErrorRequestMaterialsAlreadyInProgress"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", _caller];
    // return
    false
};

// has enough time passed?
private _currentTime      = time;
private _remainingSeconds = _materialsAvailabilityIntervalSec - (_currentTime - _lastMaterialRequestTime);
if (_remainingSeconds > 0) exitWith {
    // chat only to caller
    [_side, "STR_SCAR_UCM_Radio_ErrorRequestMaterialsTooSoon", ceil(_remainingSeconds / 60)] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", _caller];
    // return
    false
};

// flags
_logicModule setVariable ["SCAR_UCM_requestMaterialOngoing", true, true];
_logicModule setVariable ["SCAR_UCM_lastMaterialRequestTime", _currentTime, true];

// vars
private _helicopterClass        = _logicModule getVariable "SCAR_UCM_helicopterClass";
private _helicopterOrigins      = _logicModule getVariable "SCAR_UCM_helicopterOrigins";
private _helicopterLandingZones = _logicModule getVariable "SCAR_UCM_helicopterLandingZones";

// get origin & destination
private _helicopterOrigin      = selectRandom _helicopterOrigins;
private _helicopterLandingZone = selectRandom _helicopterLandingZones;

// create helicopter with crew
private _size = sizeOf _helicopterClass;
private _helicopterOriginPos = getPos _helicopterOrigin;
private _helicopterOriginMaterialPos = _helicopterOriginPos getPos [2 * _size, -45];

private _result  = [_helicopterOriginMaterialPos, 0, _helicopterClass, _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _group   = _result select 2;

// save logicModule
_vehicle setVariable ["SCAR_UCM_logicModule", _logicModule, true];

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

// event
["UCM_RequestedMaterials", [_logicModule, _vehicle]] call CBA_fnc_serverEvent;

// radio
[_side, "STR_SCAR_UCM_Radio_RequestedMaterials"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];

// waypoints

// --> heli: unload
private _wpUnload = _group addWaypoint [getPos _helicopterLandingZone, 0];
_wpUnload setWaypointType "MOVE";
_wpUnload setWaypointStatements ["true", "_vehicle = (vehicle this); [_vehicle] spawn SCAR_UCM_fnc_dropMaterialFromHelicopter;"];

// --> heli: leave
private _wpLeave = _group addWaypoint [_helicopterOriginMaterialPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];

// reset ongoing flag when helicopter is deleted
_vehicle addEventHandler ["deleted", {
    private _vehicle     = _this select 0;
    private _logicModule = _vehicle getVariable "SCAR_UCM_logicModule";
    _logicModule setVariable ["SCAR_UCM_requestMaterialOngoing", false, true];
}];

// return
true
