/*
	Author: _SCAR

	Description:
	Sets the pieceline's map marker.

	Parameter(s):
	0: OBJECT - The store.
	1: POSITION - The position of the marker.

	Return:
	0: true

	Example:
	[_store, _pos] call SCAR_UCM_fnc_setMarkerConstruction;
*/

if !(isServer) exitWith {};

params ["_store", "_pos"];

// vars
private _marker = _store getVariable "SCAR_UCM_markerObj";

// delete previous marker, if any
if !(_marker isEqualTo objNull) then {
	deleteMarker _marker;
};

// create
_marker = createMarker ["SCAR_UCM_markerConstruction", _pos];
_marker setMarkerShape "ICON";
_marker setMarkerType "Select";
_marker setMarkerColor "colorCivilian";
_marker setMarkerText (localize "STR_SCAR_UCM_Main_ConstructionArea");

// store
_store setVariable ["SCAR_UCM_markerObj", _marker, true];

// return
true
