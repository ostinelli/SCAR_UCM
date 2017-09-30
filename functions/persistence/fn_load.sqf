/*
    Author: _SCAR

    Description:
    Reads saved local profileNameSpace, sets it on the logicModule and spawns the UCM objects.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: STRING - The module persistence key.

    Return:
    true

    Example:
    [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_load;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_moduleHashKey"];

// load
private _persistentHash = [_moduleHashKey] call SCAR_UCM_fnc_profileNameSpaceGet;

if !(isNil "_persistentHash") then {
    // log
    [_logicModule, "Data loaded from profileNameSpace, deserializing it in UTM and spawning entities."] call SCAR_UCM_fnc_log;
    // deserialize
    [_logicModule, _persistentHash] call SCAR_UCM_fnc_serializeUcmToData;
} else {
    // log
    [_logicModule, "No previous data found from profileNameSpace."] call SCAR_UCM_fnc_log;
};

// return
true
