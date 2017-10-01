/*
    Author: _SCAR

	Description:
	Load a persistent logicModule data from the profileNamespace.

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	CBA_HASH

	Example:
	[_logicModule] call SCAR_UCM_fnc_loadModule;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// get mission hash
private _missionVarName = ([] call SCAR_UCM_fnc_getProfileNamespaceMissionVarName);
private _missionHash    = profileNamespace getVariable [_missionVarName, ([] call CBA_fnc_hashCreate)];

// get module hash
private _logicModuleKey = ([_logicModule] call SCAR_UCM_fnc_getModuleHashVarName);
private _moduleHash     = [_missionHash, _logicModuleKey] call CBA_fnc_hashGet;

// check
if !(isNil "_moduleHash") then {
    // log
    [_logicModule, "Module data loaded from profileNamespace, deserializing it in UTM and spawning entities."] call SCAR_UCM_fnc_log;
    // deserialize
    [_logicModule, _moduleHash] call SCAR_UCM_fnc_deserializeDataFromUcm;
} else {
    // log
    [_logicModule, "No previous data found from profileNameSpace."] call SCAR_UCM_fnc_log;
};

// return
true
