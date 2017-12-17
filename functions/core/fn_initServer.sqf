/*
    Author: _SCAR

    Description:
    Initializes the server. This function is called automatically on mission init.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_initServer;
*/

if !(isServer) exitWith {};

// log
"Initializing server." call SCAR_UCM_fnc_log;

// check for ACE & broadcast
SCAR_UCM_ACE = [] call SCAR_UCM_fnc_isAceAvailable;
publicVariable "SCAR_UCM_ACE";

// get logic modules
// (we have to do it like this because of the name bug when using 'function' in the Module Framework)
private _allLogicModules = entities "SCAR_UCM_ModuleUtilitiesConstructionMod";

// init logic modules
{
    // init

    private _logicModule = _x;

    // init settings
    [_logicModule] call SCAR_UCM_fnc_initSettings;

    // init integrations
    [_logicModule] call SCAR_UCM_fnc_initIntegrations;

    // patch ACE
    [_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

    // init foreman
    [_logicModule, "Initializing Foreman."] call SCAR_UCM_fnc_log;
    [_logicModule] call SCAR_UCM_fnc_initForeman;

    // add listener
    [_logicModule, "Adding cargo listener."] call SCAR_UCM_fnc_log;
    [_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

    // handle construction work
    [_logicModule, "Starting construction loop."] call SCAR_UCM_fnc_log;
    [_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;

    // show LZ marker
    [_logicModule, "Adding landing zone marker."] call SCAR_UCM_fnc_log;
    [_logicModule] remoteExec ["SCAR_UCM_fnc_setMarkerLandingZone", 0 , true];

} forEach _allLogicModules;

// init persistence
[] call SCAR_UCM_fnc_initPersistence;

// init finished
"Server init done." call SCAR_UCM_fnc_log;

// broadcast
"Broadcasting variable 'SCAR_UCM_initialized'." call SCAR_UCM_fnc_log;
missionNamespace setVariable ["SCAR_UCM_initialized", true, true];

// return
true
