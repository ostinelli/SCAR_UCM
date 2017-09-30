/*
	Author: _SCAR

	Description:
	Initializes persistence support.

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	true

	Example:
	[_logicModule] call SCAR_UCM_fnc_initPersistence;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// check if UCM persistence module is present
private _allPersistenceModules = entities "SCAR_UCM_ModuleUtilitiesConstructionPersistence";
if ((count _allPersistenceModules) == 0) exitWith {
    [_logicModule, "No Persistence Module found, game will not be persisted."] call SCAR_UCM_fnc_log;
};

// get logic modules
private _allLogicModules = entities "SCAR_UCM_ModuleUtilitiesConstructionMod";

// loop logic modules
{
    // init
    private _logicModule = _x;

    // define unique hash key name
    private _moduleHashKey = format ["SCAR_UCM_moduleHash:%1", _logicModule];

    // load & spawn
    [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_load;

    private _callbackCode = {
        // get vars
        private _vars = missionNameSpace getVariable [format["SCAR_UCM_persistenceEvent_%1", _thisEventHandler], objNull];

        if !(_vars isEqualTo objNull) then {
            // log
            [_logicModule, "Save state to persistence backend."] call SCAR_UCM_fnc_log;

            // vars
            private _logicModule   = _vars select 0;
            private _moduleHashKey = _vars select 1;

            // save
            [_logicModule, _moduleHashKey] call SCAR_UCM_fnc_save;
        };
    };

    // set event to save on mission end and every time a player disconnects
    private _eventHandleEnded      = addMissionEventHandler ["Ended", _callbackCode];
    private _eventHandleDisconnect = addMissionEventHandler ["HandleDisconnect", _callbackCode];
    [_logicModule, "Attached callbacks to missionEnd and Player Disconnect for persistence."] call SCAR_UCM_fnc_log;

    // save event vars
    missionNameSpace setVariable [format["SCAR_UCM_persistenceEvent_%1", _eventHandleEnded], [_logicModule, _moduleHashKey]];
    missionNameSpace setVariable [format["SCAR_UCM_persistenceEvent_%1", _eventHandleDisconnect], [_logicModule, _moduleHashKey]];

} forEach _allLogicModules;

// return
true
