/*
    Author: _SCAR

    Description:
    Returns the current workers.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    ARRAY of UNITS

    Example:
    [_logicModule] call SCAR_UCM_fnc_getWorkers;
*/

params ["_logicModule"];

// return
_logicModule getVariable "SCAR_UCM_workers";
