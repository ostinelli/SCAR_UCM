/*
    Author: _SCAR

    Description:
    Initializes the player. This function is called automatically on mission init.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_initPlayer;
*/

if !(hasInterface) exitWith {};

// wait until initialization is done
if (isNil "SCAR_UCM_initialized") then {
    SCAR_UCM_initialized = false;
    waitUntil { SCAR_UCM_initialized };
};

// return
true
