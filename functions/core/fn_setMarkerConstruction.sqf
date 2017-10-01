/*
    Author: _SCAR

    Description:
    Sets the pieceline's map marker.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: POSITION - The position of the marker.

    Return:
    true

    Example:
    [_logicModule, _pos] call SCAR_UCM_fnc_setMarkerConstruction;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_pos"];

// vars
private _marker = _logicModule getVariable ["SCAR_UCM_constructionAreaMarker", objNull];
private _side   = _logicModule getVariable "SCAR_UCM_side";

// check side
if !((side player) == _side) exitWith {};

// delete previous marker, if any
if !(_marker isEqualTo objNull) then {
    deleteMarker _marker;
};

// create
_marker = createMarkerLocal ["SCAR_UCM_constructionAreaMarker", _pos];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "Select";
_marker setMarkerColorLocal format["color%1", _side];
_marker setMarkerTextLocal localize "STR_SCAR_UCM_Main_ConstructionArea";

// store
_logicModule setVariable ["SCAR_UCM_constructionAreaMarker", _marker];

// return
true
