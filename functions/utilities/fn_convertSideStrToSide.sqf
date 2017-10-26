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

// if already side, return
if ((typeName _sideStr) == "SIDE") exitWith { _sideStr };

// define relations
private _sideKeys   = ["BLUFOR", "WEST", "OPFOR", "EAST", "RESISTANCE", "INDEPENDENT", "GUER"];
private _sideValues = [blufor, blufor, opfor, opfor, independent, independent, independent];

// upcase
_sideStr = toUpper(_sideStr);

// return
if !(_sideStr in _sideKeys) exitWith { civilian };
_sideValues select (_sideKeys find _sideStr)
