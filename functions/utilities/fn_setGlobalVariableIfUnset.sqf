/*
    Author: _SCAR

    Description:
    Sets a piece altitude.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: STRING - The variable name.
    2: ANY    - The value.

    Return:
    true

    Example:
    [_namespace, _name, _value] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_name", "_value"];

if ( (_logicModule getVariable [_name, objNull]) isEqualTo objNull ) then {
    [_logicModule, format["       -> setting missing variable %1 to value %2", _name, _value]] call SCAR_UCM_fnc_log;
    _logicModule setVariable [_name, _value, true];
} else {
    [_logicModule, format["       -> NOT setting missing variable %1 (already set)", _name, _value]] call SCAR_UCM_fnc_log;
};

// return
true
