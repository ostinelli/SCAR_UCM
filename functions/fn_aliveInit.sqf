/*
    Author: _SCAR

    Description:
    Initializes ALiVE integration if the mod is present.

    Parameter(s):
	0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_aliveInit;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// exit if ALiVE is present
if (count (entities "ALiVE_require") == 0) exitWith {};
diag_log "UCM: ALiVE found.";

// wait for ALiVE initialization
waitUntil { !(isNil "ALiVE_ProfileHandler") && { [ALiVE_ProfileSystem, "startupComplete", false] call ALIVE_fnc_hashGet } };
diag_log "UCM: done waiting for ALiVE initialization.";

// init persistent data, if any
private _aliveStores = entities "ALiVE_sys_data";
if ((count _aliveStores) > 0) then {
    // PERSISTENCY ENABLED
    diag_log "UCM: ALiVE persistency module found.";

    private _aliveStore = _aliveStores select 0;
    // set unique alive key
    private _aliveKey = format ["SCAR_UCM_logicModuleVars:%1", _logicModule];

    // read & set
    [_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveLoadData;

    // periodically save
    // TODO: hook on ALiVE save event instead
    private _null = [_logicModule, _aliveStore, _aliveKey] spawn {

        params ["_logicModule", "_aliveStore", "_aliveKey"];

        while { true } do {
            // save
            [_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveSaveData;
            // wait
            sleep 60; // 1 minute
        };
    };
} else {
    diag_log "UCM: no ALiVE persistency module found, proceeding without load/save.";
};

// init listener for custom objectives
[] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;

// return
true
