/*
    Author: _SCAR

    Description:
    Writes a log message to RPT.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The log message.

    Return:
    true

    Example:
    [_logicModule, _message] call SCAR_UCM_fnc_log;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_message"];

// dump
diag_log text format["UCM [%1] %2", _logicModule, _message];

// return
true
