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

// set event to save on mission end
private _eventHandle = addMissionEventHandler ["Ended", {
    // get vars
    private _vars = missionNameSpace getVariable format["SCAR_UCM_ALiVE_endMissionData_%1", _thisEventHandler];

    private _logicModule = _vars select 0;
    private _aliveStore  = _vars select 1;
    private _aliveKey    = _vars select 2;

    // save
    [_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveSaveData;
}];
// save vars
missionNameSpace setVariable [ format["SCAR_UCM_ALiVE_endMissionData_%1", _eventHandle], [_logicModule, _aliveStore, _aliveKey]];

// return
true
