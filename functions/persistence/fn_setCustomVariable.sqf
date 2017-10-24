/*
	Author: _SCAR

	Description:
	Sets a custom variable on UCM logic's namespace. Will be persisted if persistence is enabled.

	Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The key.
	2: STRING, BOOL, NUMBER, ARRAY, CBA HASH - The value.

	Return:
	true

	Example:
	[_logicModule, _key, _value] call SCAR_UCM_fnc_setCustomVariable;
*/

params ["_logicModule", "_key", "_value"];

// get current custom hash
private _customHash = _logicModule getVariable "SCAR_UCM_customHash";

// set
_customHash = [_customHash, _key, _value] call CBA_fnc_hashSet;
_logicModule setVariable ["SCAR_UCM_customHash", _customHash];

// return
true
