/*
    Author: _SCAR

    Description:
    Saves a persistent logicModule data to the profileNamespace.

    Parameter(s):
	0: OBJECT - The logicModule.

    Return:
    BOOLEAN

    Example:
    [_logicModule] call SCAR_UCM_fnc_saveModule;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// get mission hash
private _missionVarName = ([] call SCAR_UCM_fnc_getProfileNamespaceMissionVarName);
private _missionHash    = profileNamespace getVariable [_missionVarName, ([] call CBA_fnc_hashCreate)];

// create module hash
private _logicModuleKey = ([_logicModule] call SCAR_UCM_fnc_getModuleHashVarName);
private _moduleHash     = [_logicModule] call SCAR_UCM_fnc_serializeUcmToData;

// set it to the mission hash
[_missionHash, _logicModuleKey, _moduleHash] call CBA_fnc_hashSet;

// save mission hash to profileNamespace
profileNamespace setVariable [_missionVarName, _missionHash];

// save profile
saveProfileNamespace;

// return
true
