/*
	Author: _SCAR

	Description:
	Clears the persistent values in the profileNameSpace.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_profileNameSpaceClear;
*/

if !(isServer) exitWith {};

// unique profileNameSpace name for mission
private _profileNameSpaceVarName = [] call SCAR_UCM_fnc_getProfileNameSpaceVarName;

// set hash on profile
profileNamespace setVariable [_profileNameSpaceVarName, nil];

// save profile
saveProfileNamespace;

// return
true
