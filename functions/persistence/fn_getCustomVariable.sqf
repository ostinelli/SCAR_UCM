/*
	Author: _SCAR

	Description:
	Gets a custom variable from the UCM logic's namespace. Will be persisted if persistence is enabled.

	Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The key.

	Return:
	STRING, BOOL, NUMBER, ARRAY, CBA HASH

	Example:
	[_logicModule, _key] call SCAR_UCM_fnc_getCustomVariable;
*/

params ["_logicModule", "_key"];

// get current custom hash
private _customHash = _logicModule getVariable "SCAR_UCM_customHash";

// return
[_customHash, _key] call CBA_fnc_hashGet;
