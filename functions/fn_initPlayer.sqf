/*
    Author: _SCAR

    Description:
    Initializes the player. This function is called automatically on mission init.

    Parameter(s):
    0: OBJECT - The store.

    Return:
    0: true

    Example:
    [_store] call SCAR_UCM_fnc_initPlayer;
*/

if !(hasInterface) exitWith {};

params ["_store"];

// wait until initialization is done
// waitUntil { SCAR_UCM_initialized }; TODO REMOVE

// init actions
[_store] call SCAR_UCM_fnc_addActionsToForeman;

// return
true
