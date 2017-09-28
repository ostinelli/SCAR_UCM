/*
    Author: _SCAR

    Description:
    Initializes the server.

    Paramster(s):
    0:  OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_initServer;
*/

if !(isServer) exitWith {};

// params
params ["_logicModule"];

// check for ACE & broadcast
SCAR_UCM_ACE = [] call SCAR_UCM_fnc_isAceAvailable;
publicVariable "SCAR_UCM_ACE";

// init foreman
[_logicModule, "Initializing Foreman."] call SCAR_UCM_fnc_log;
[_logicModule] call SCAR_UCM_fnc_initForeman;

// add listener
[_logicModule, "Adding cargo listener."] call SCAR_UCM_fnc_log;
[_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

// handle construction work
[_logicModule, "Starting construction loop."] call SCAR_UCM_fnc_log;
[_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;

// add fixed markers
[_logicModule, "Adding landing zone marker."] call SCAR_UCM_fnc_log;
[_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;

// init finished, broadcast
[_logicModule, "Initialization finished, broadcasting variable 'SCAR_UCM_initialized'"] call SCAR_UCM_fnc_log;
SCAR_UCM_initialized = true;
publicVariable "SCAR_UCM_initialized";  // TODO: broadcast ONLY when all of the logic modules have been initialized

// return
true
