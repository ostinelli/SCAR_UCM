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

// check for existance of piece 0
// we need to do this because parseNumber returns 0 for invalid numbers <https://community.bistudio.com/wiki/parseNumber>
if ((missionNameSpace getVariable [format["%1%2", _pieceNamePrefix, 0], objNull]) isEqualTo objNull) then {
	throw "UCM: the naming of the pieces does not follow a sequential [0 - n] logic";
};

// loop all other pieces
private _total    = 1;
private _foundIds = [0];
{
    if ( (_x select [0, _prefixLength]) == _pieceNamePrefix) then {
        if ( (count _x) > _prefixLength ) then {
			private _id = parseNumber (_x select [_prefixLength]);
			if !(_id == 0) then {
				// increase total found
				_total = _total + 1;
				// append id
				_foundIds pushBack _id;
			};
        };
    };
} forEach allVariables missionNamespace;

// build array of expected ids
private _expectedIds = [];
for "_i" from 0 to (_total - 1) do {
    _expectedIds pushBack _i;
};

// check that expected array corresponds to wanted one
if !( count(_expectedIds - _foundIds) == 0 ) then {
    throw "UCM: the naming of the pieces does not follow a sequential [0 - n] logic";
};

// return
_total;
