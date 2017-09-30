/*
	Author: _SCAR

	Description:
	Load a persistent Key Value combination from the profileNameSpace.

	Parameter(s):
	0: STRING - The key.

	Return:
	ANY - The value

	Example:
	[_key] call SCAR_UCM_fnc_profileNameSpaceGet;
*/

if !(isServer) exitWith {};

params ["_key"];

// unique profileNameSpace name for mission
private _profileNameSpaceVarName = [] call SCAR_UCM_fnc_getProfileNameSpaceVarName;

// get current hash (defaults to empty CBA HASH)
private _UcmHash = profileNamespace getVariable [_profileNameSpaceVarName, ([] call CBA_fnc_hashCreate)];

// return value
[_UcmHash, _key] call CBA_fnc_hashGet;
