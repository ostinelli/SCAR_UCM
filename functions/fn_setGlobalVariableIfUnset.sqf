/*
    Author: _SCAR

    Description:
    Sets a piece altitude.

    Parameter(s):
    0: OBJECT - The varspace.
    1: STRING - The variable name.
    2: ANY    - The value.

    Return:
    0: true

    Example:
    [_namespace, _name, _value] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
*/

if !(isServer) exitWith {};

params ["_namespace", "_name", "_value"];

if ( (_namespace getVariable [_name, objNull]) isEqualTo objNull ) then {
    _namespace setVariable [_name, _value, true];
};

// return
true
