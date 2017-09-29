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

params ["_side", "_stringId"];

// set marker text
[_side, "HQ"] sideChat localize _stringId;

// return
true
