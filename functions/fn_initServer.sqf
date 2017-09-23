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

// add listener
[_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

// handle construction work
[_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;

// add fixed markers
[_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;

// init finished, broadcast
_logicModule setVariable ["SCAR_UCM_initialized", true, true];

// return
true
