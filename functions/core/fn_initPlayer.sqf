/*
    Author: _SCAR

    Description:
    Initializes the player. This function is called automatically on mission init.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_initPlayer;
*/

if !(hasInterface) exitWith {};

params ["_logicModule"];

// check for ACE
SCAR_UCM_ACE = [] call SCAR_UCM_fnc_isAceAvailable;

// wait until initialization is done
// waitUntil { SCAR_UCM_initialized }; TODO REMOVE

// init actions
[_logicModule] call SCAR_UCM_fnc_addActionsToForeman;

// return
true
