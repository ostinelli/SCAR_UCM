/*
    Author: _SCAR

    Description:
    Initializes ALiVE integration if the mod is present.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_aliveInit;
*/

if !(isServer) exitWith {};

// exit if ALiVE is present
if (count (entities "ALiVE_require") == 0) exitWith {};

// init listener for custom objectives
[] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;
