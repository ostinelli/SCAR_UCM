/*
    Author: _SCAR

    Description:
    Returns if the UCM module is initialized.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    BOOLEAN

    Example:
    [_logicModule] call SCAR_UCM_fnc_isInitialized;
*/

params ["_logicModule"];

// return
_logicModule getVariable ["SCAR_UCM_initialized", false];
