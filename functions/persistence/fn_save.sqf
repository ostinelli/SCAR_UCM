/*
    Author: _SCAR

    Description:
    Saves UCM data to local profileNameSpace.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The module persistence key.

    Return:
    BOOLEAN

    Example:
    [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_save;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_moduleHashKey"];

// serialize
private _persistentHash = [_logicModule] call SCAR_UCM_fnc_serializeUcmToData;

// save it
[_moduleHashKey, _persistentHash] call SCAR_UCM_fnc_profileNameSpaceSet;
[_logicModule, "Data saved to profileNameSpace."] call SCAR_UCM_fnc_log;

// return
true
