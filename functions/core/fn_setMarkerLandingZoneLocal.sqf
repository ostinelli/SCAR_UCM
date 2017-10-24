/*
    Author: _SCAR

    Description:
    Sets the Landing Zone's map marker.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_setMarkerLandingZonelocal;
*/

if !(hasInterface) exitWith {};

params ["_logicModule"];

// vars
private _marker       = _logicModule getVariable ["SCAR_UCM_helicopterLandingZoneMarker", objNull];
private _landingZone  = _logicModule getVariable "SCAR_UCM_helicopterLandingZone";
private _side         = _logicModule getVariable "SCAR_UCM_side";

// check side
if !((side (group player)) == _side) exitWith {};

// create
_marker = createMarkerLocal ["SCAR_UCM_helicopterLandingZoneMarker", getPos _landingZone];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "Select";
_marker setMarkerColorLocal format["color%1", _side];
_marker setMarkerTextLocal localize "STR_SCAR_UCM_Main_LandingZone";

// return
true
