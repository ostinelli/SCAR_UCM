/*
	Author: _SCAR

	Description:
	Clears the persistent logicModule data from the profileNameSpace.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_profileNamespaceClear;
*/

if !(isServer) exitWith {};

// unique mission name for mission
private _missionVarName = ([] call SCAR_UCM_fnc_getProfileNamespaceMissionVarName);

// set hash on profile
profileNamespace setVariable [_missionVarName, nil];

// save profile
saveProfileNamespace;

// return
true
