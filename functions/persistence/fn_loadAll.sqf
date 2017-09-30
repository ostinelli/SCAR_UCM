/*
	Author: _SCAR

	Description:
	Reads saved local profileNameSpace, sets it on all the logicModule and spawns the UCM objects.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_loadAll;
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
    [_logicModule, "Load state & spawn from persistence backend."] call SCAR_UCM_fnc_log;

    // load & spawn
    [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_load;

} forEach _allLogicModules;

// return
true
