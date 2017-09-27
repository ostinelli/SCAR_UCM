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
[_logicModule, "ALiVE found."] call SCAR_UCM_fnc_log;

// wait for ALiVE initialization
waitUntil { !(isNil "ALiVE_ProfileHandler") && { [ALiVE_ProfileSystem, "startupComplete", false] call ALIVE_fnc_hashGet } };
[_logicModule, "Done waiting for ALiVE initialization."] call SCAR_UCM_fnc_log;

// init persistent data, if any
private _aliveStores = entities "ALiVE_sys_data";
if ((count _aliveStores) > 0) then {
    // PERSISTENCY ENABLED
    [_logicModule, "ALiVE persistency module found."] call SCAR_UCM_fnc_log;

    private _aliveStore = _aliveStores select 0;
    [_logicModule, _aliveStore] call SCAR_UCM_fnc_alivePersistency;

} else {
    [_logicModule, "No ALiVE persistency module found, proceeding without load/save."] call SCAR_UCM_fnc_log;
};

// init listener for custom objectives
[] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;

// return
true
