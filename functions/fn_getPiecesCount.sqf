/*
    Author: _SCAR

    Description:
    Computes the total number of pieces.

    Parameter(s):
    0: OBJECT - The store.

    Return:
    0: NUMBER

    Example:
    [_store] call SCAR_UCM_fnc_getPiecesCount;
*/

params ["_store"];

// vars
private _pieceNamePrefix = _store getVariable "SCAR_UCM_pieceNamePrefix";

// init
private _prefixLength = count _pieceNamePrefix;
private _total = 0;
{
    if ( (_x select [0, _prefixLength]) == _pieceNamePrefix) then {
        if ( (count _x) > _prefixLength ) then {
            _total = _total + 1;
        };
    };
} forEach allVariables missionNamespace;

// return
_total;
