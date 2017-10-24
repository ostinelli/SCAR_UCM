/*
    Author: _SCAR

    Description:
    Broadcasts the Landing Zone's map marker.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// prefs
private _showAreaMarkers = _logicModule getVariable "SCAR_UCM_showAreaMarkers";
if !(_showAreaMarkers) exitWith {};

// broadcast
[_logicModule] remoteExec ["SCAR_UCM_fnc_setMarkerLandingZonelocal", 0, true];

// return
true
