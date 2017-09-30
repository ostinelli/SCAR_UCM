/*
    Author: _SCAR

    Description:
    Writes a log message to RPT.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The log message.

	or

    Parameter(s):
	STRING - The log message.

    Return:
    true

    Examples:
    [_logicModule, _message] call SCAR_UCM_fnc_log;
    _message call SCAR_UCM_fnc_log;
*/

if !(isServer) exitWith {};

if ((typeName _this) == "STRING") then {
    diag_log text format["[UCM] %1", _this];
} else {
    params ["_logicModule", "_message"];
    diag_log text format["[UCM][mod: '%1'] %2", _logicModule, _message];
};

// return
true
