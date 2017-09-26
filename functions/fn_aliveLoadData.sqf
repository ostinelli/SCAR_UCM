/*
    Author: _SCAR

    Description:
    Reads data from ALiVE (both local or cloud, depending on ALiVE Data module settings) & sets it on the logic module.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: OBJECT - The ALiVE Store module.
	2: STRING - The unique ALiVE key.

    Return:
    true

    Example:
    [_logicModule, _aliveStore, _aliveKey ] call SCAR_UCM_fnc_aliveRetrieveData;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_aliveStore", "_aliveKey"];

// get source type
private _storeSource = toLower( _aliveStore getVariable ["source", "pns"] );
diag_log format ["UCM: ALiVE storage is of type %1.", _storeSource];

// get data
private _aliveHash = objNull;

if (_storeSource == "pns") then {
    // LOCAL
    diag_log "UCM: loading data from ALiVE local.";
    _aliveHash = _aliveKey call ALiVE_fnc_ProfileNameSpaceLoad;
} else {
    // CLOUD
    diag_log "UCM: loading data from ALiVE cloud.";
    _aliveHash = [_aliveKey] call ALiVE_fnc_getData;
};

// read & set values on logicModule
if ([_aliveHash] call CBA_fnc_isHash) then {
    diag_log format ["UCM: setting persistent data on logicModule %1", _logicModule];

    private _setValuesOnLogicModule = {
        diag_log format ["UCM: setting key %1 with value %2 on logicModule %3", _key, _value, _logicModule];
        _logicModule setVariable [_key, _value, true];
    };
    [_aliveHash, _setValuesOnLogicModule] call CBA_fnc_hashEachPair;
};

diag_log "UCM: ALiVE persistency operations completed.";

// return
true
