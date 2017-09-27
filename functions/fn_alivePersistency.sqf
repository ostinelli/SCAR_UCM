/*
    Author: _SCAR

    Description:
    Initializes ALiVE persistency.

    Parameter(s):
	0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule, _aliveStore] call SCAR_UCM_fnc_alivePersistency;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_aliveStore"];

// set unique alive key for module
private _aliveKey = format ["SCAR_UCM_ALiVE_Key:%1", _logicModule];

// read & set
[_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveLoadData;

// periodically save
// TODO: hook on ALiVE save event instead
private _null = [_logicModule, _aliveStore, _aliveKey] spawn {

    params ["_logicModule", "_aliveStore", "_aliveKey"];

    while { true } do {
        // wait
        sleep 60; // 1 minute
        // save
        [_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveSaveData;
    };
};
