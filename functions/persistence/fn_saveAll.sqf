/*
	Author: _SCAR

	Description:
	Saves all data of all modules to local profileNameSpace. Callback from save menu.

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

    // define unique hash key name
    private _moduleHashKey = format ["SCAR_UCM_moduleHash:%1", _logicModule];

    // log
    [_logicModule, "Save state to persistence backend."] call SCAR_UCM_fnc_log;

    // save
    [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_save;

} forEach _allLogicModules;

// return
true
