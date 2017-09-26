/*
    Author: _SCAR

    Description:
    Sets a piece altitude.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: STRING - The variable name.
    2: ANY    - The value.

    Return:
    0: true

    Example:
    [_namespace, _name, _value] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_name", "_value"];

if ( (_logicModule getVariable [_name, objNull]) isEqualTo objNull ) then {
    diag_log format["UCM: setting missing variable %1 to value %2 for module %3", _name, _value, _logicModule];
    _logicModule setVariable [_name, _value, true];
} else {
    diag_log format["UCM: not etting variable %1 to value %2 for module %3 (already present)", _name, _value, _logicModule];
};

// return
true
