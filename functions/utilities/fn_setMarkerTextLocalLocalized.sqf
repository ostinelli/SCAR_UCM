/*
    Author: _SCAR

    Description:
    Sets the marker text localized.

    Parameter(s):
    0: OBJECT - The marker.
    1: STRING - The translation string ID.

    Return:
    true

    Example:
    [_marker, "STR_SCAR_UCM_Main_Worker"] call SCAR_UCM_fnc_setMarkerTextLocalLocalized;
*/

if !(hasInterface) exitWith {};

params ["_marker", "_stringId"];

// set marker text
_marker setMarkerTextLocal localize _stringId;

// return
true
