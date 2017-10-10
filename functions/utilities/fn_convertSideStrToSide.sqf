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

// fix weird bug when side is sometimes passed in as side from module settings
_sideStr = toUpper(format ["%1", _sideStr]);

private _sideKeys     = ["BLUFOR", "WEST", "OPFOR", "EAST", "RESISTANCE", "INDEPENDENT", "CIVILIAN"];
private _sideValues   = [blufor, blufor, opfor, opfor, independent, independent, civilian];

// return
_sideValues select (_sideKeys find _sideStr)
