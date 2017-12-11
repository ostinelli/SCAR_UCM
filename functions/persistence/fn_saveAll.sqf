/*
	Author: _SCAR

	Description:
	Saves all data of all modules to local profileNamespace. Callback from save menu.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_saveAll;
*/

if !(isServer) exitWith {};

// get logic modules
private _allLogicModules = entities "SCAR_UCM_ModuleUtilitiesConstructionMod";

// loop logic modules
{
    // init
    private _logicModule = _x;

    // on save event
    ["UCM_BeforeSave", [_logicModule]] spawn CBA_fnc_serverEvent;

    // log
    [_logicModule, "Save state to persistence backend."] call SCAR_UCM_fnc_log;

    // save
    [_logicModule] call SCAR_UCM_fnc_saveModule;

} forEach _allLogicModules;

// return
true
