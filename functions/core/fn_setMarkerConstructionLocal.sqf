/*
    Author: _SCAR

    Description:
    Sets the pieceline's map marker.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: OBJECT - The piece.

    Return:
    true

    Example:
    [_logicModule, _piece] call SCAR_UCM_fnc_setMarkerConstruction;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_piece"];

// vars
private _marker = _logicModule getVariable ["SCAR_UCM_constructionAreaMarker", objNull];
private _side   = _logicModule getVariable "SCAR_UCM_side";

// check side
if !((side (group player)) == _side) exitWith {};

// create
_marker = createMarkerLocal ["SCAR_UCM_constructionAreaMarker", getPos _piece];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "Select";
_marker setMarkerColorLocal format["color%1", _side];
_marker setMarkerTextLocal localize "STR_SCAR_UCM_Main_ConstructionArea";

// return
true
