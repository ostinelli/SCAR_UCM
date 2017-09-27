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
[_logicModule] call SCAR_UCM_fnc_initForeman;

// add listener
[_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;

// handle construction work
[_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;

// add fixed markers
[_logicModule] call SCAR_UCM_fnc_setMarkerLandingZone;

// init finished, broadcast
_logicModule setVariable ["SCAR_UCM_initialized", true, true];

//create worker groups for every sife
UCM_west = createGroup west;
UCM_east = createGroup east;
UCM_ind  = createGroup resistance;
UCM_civ  = createGroup civilian;

// return
true
