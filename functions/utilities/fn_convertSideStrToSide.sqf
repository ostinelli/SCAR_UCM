/*
    Author: _SCAR

    Description:
    Convert a Side string into a Side.

    Paramster(s):
    0: STRING - The side (such as "west", "east", "opfor", ...).

    Return:
    SIDE

    Example:
    ["west"] call SCAR_UCM_fnc_convertSideStrToSide;
*/

params ["_sideStr"];

private _sideKeys     = ["BLUFOR", "WEST", "OPFOR", "EAST", "RESISTANCE", "INDEPENDENT", "CIVILIAN"];
private _sideValues   = [blufor, blufor, opfor, opfor, independent, independent, civilian];

// return
_sideValues select (_sideKeys find toUpper(_sideStr))
