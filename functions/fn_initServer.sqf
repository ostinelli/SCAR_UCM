/*
    Author: _SCAR

    Description:
    Initializes the server.

    Paramster(s):
    0:  OBJECT - The store.

    Return:
    0: true

    Example:
    [_store] call SCAR_UCM_fnc_initServer;
*/

if !(isServer) exitWith {};

// params
params ["_store"];

// init foreman
[_store] call SCAR_UCM_fnc_initForeman;

// add listener
[] call SCAR_UCM_fnc_onUnloadedCargoPos;

// handle construction work
[_store] call SCAR_UCM_fnc_loopConstructionProgress;

// init finished, broadcast
_store setVariable ["SCAR_UCM_initialized", true, true];

// return
true
