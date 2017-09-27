/*
    Author: _SCAR

    Description:
    Sets the Landing Zone's map marker.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// vars
private _marker       = _logicModule getVariable ["SCAR_UCM_helicopterLandingZoneMarker", objNull];
private _landingZone  = _logicModule getVariable "SCAR_UCM_helicopterLandingZone";
private _side         = _logicModule getVariable "SCAR_UCM_side";

// delete previous marker, if any
if !(_marker isEqualTo objNull) then {
    deleteMarker _marker;
};

// create
_marker = createMarker ["SCAR_UCM_helicopterLandingZoneMarker", getPos _landingZone];
_marker setMarkerShape "ICON";
_marker setMarkerType "Select";
_marker setMarkerColor format["color%1", _side];
_marker setMarkerText (localize "STR_SCAR_UCM_Main_LandingZone");

// store
_logicModule setVariable ["SCAR_UCM_helicopterLandingZoneMarker", _marker, true];

// return
true
