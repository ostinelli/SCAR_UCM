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
[_logicModule, format ["ALiVE storage is of type %1.", _storeSource]] call SCAR_UCM_fnc_log;

// get data
private _aliveHash = objNull;

if (_storeSource == "pns") then {
    // LOCAL
    [_logicModule, "Loading data from ALiVE local."] call SCAR_UCM_fnc_log;
    _aliveHash = _aliveKey call ALiVE_fnc_ProfileNameSpaceLoad;
} else {
    // CLOUD
    [_logicModule, "Loading data from ALiVE cloud."] call SCAR_UCM_fnc_log;
    _aliveHash = [_aliveKey] call ALiVE_fnc_getData;
};

// read & set values on logicModule
if ([_aliveHash] call CBA_fnc_isHash) then {
    [_logicModule, "Loading persistent data in logicModule."] call SCAR_UCM_fnc_log;

    private _setValuesOnLogicModule = {
        [_logicModule, format ["Setting key %1 with value %2", _key, _value]] call SCAR_UCM_fnc_log;
        _logicModule setVariable [_key, _value, true];
    };
    [_aliveHash, _setValuesOnLogicModule] call CBA_fnc_hashEachPair;
};

[_logicModule, "ALiVE persistency operations completed."] call SCAR_UCM_fnc_log;

// return
true
