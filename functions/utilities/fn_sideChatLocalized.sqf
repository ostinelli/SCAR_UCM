/*
    Author: _SCAR

    Description:
    Sets a localized sideChat.

    Parameter(s):
    0: SIDE
    1: STRING - The translation string ID.

    Return:
    true

    Example:
    [_side, "STR_SCAR_UCM_Main_Worker"] call SCAR_UCM_fnc_sideChatLocalized;
*/

if !(hasInterface) exitWith {};

params ["_side", "_stringId", "_param"];

// set marker text
if !(isNil "_param") then {
    [_side, "HQ"] sideChat format [(localize _stringId), _param];
} else {
    [_side, "HQ"] sideChat localize _stringId;
};

// return
true
