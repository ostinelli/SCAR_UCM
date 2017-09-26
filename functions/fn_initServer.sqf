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

// init foreman
diag_log format ["UCM: initializing foreman for logicModule %1", _logicModule];
[_logicModule] call SCAR_UCM_fnc_initForeman;

// add listener
diag_log format ["UCM: adding cargo listener for logicModule %1", _logicModule];
[_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

// handle construction work
diag_log format ["UCM: starting construction loop for logicModule %1", _logicModule];
[_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;

// add fixed markers
diag_log format ["UCM: adding landing zone marker for logicModule %1", _logicModule];
[_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;

// init finished, broadcast
diag_log format ["UCM: initialization finished for logicModule %1, broadcast variable 'SCAR_UCM_initialized'", _logicModule];
_logicModule setVariable ["SCAR_UCM_initialized", true, true];

// return
true
