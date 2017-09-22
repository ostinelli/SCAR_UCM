/*
    Author: _SCAR

    Description:
    Returns if the UCM module is initialized.

    Parameter(s):
    0: OBJECT - The store.

    Return:
    0: BOOLEAN

    Example:
    [_store] call SCAR_UCM_fnc_isInitialized;
*/

params ["_store"];

// return
_store getVariable ["SCAR_UCM_initialized", false];
