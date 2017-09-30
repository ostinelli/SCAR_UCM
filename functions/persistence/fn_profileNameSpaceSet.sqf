/*
	Author: _SCAR

	Description:
	Save a persistent Key Value combination to the profileNameSpace.

	Parameter(s):
	0: STRING - The key.
	1: ANY    - The value.

	Return:
	true

	Example:
	[_key, _value] call SCAR_UCM_fnc_profileNameSpaceSet;
*/

if !(isServer) exitWith {};

params ["_key", "_value"];

// unique profileNameSpace name for mission
private _profileNameSpaceVarName = [] call SCAR_UCM_fnc_getProfileNameSpaceVarName;

// get current hash (defaults to empty CBA HASH)
private _UcmHash = profileNamespace getVariable [_profileNameSpaceVarName, ([] call CBA_fnc_hashCreate)];

// set value
[_UcmHash, _key, _value] call CBA_fnc_hashSet;

// set hash on profile
profileNamespace setVariable [_profileNameSpaceVarName, _UcmHash];

// save profile
saveProfileNamespace;

// return
true
