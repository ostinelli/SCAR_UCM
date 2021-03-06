/*
    Author: _SCAR

    Description:
    Initializes the foreman.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_initForeman;
*/

params ["_logicModule"];

// vars
private _foreman = _logicModule getVariable "SCAR_UCM_foreman";

// save module to foreman
_foreman setVariable ["SCAR_UCM_logicModule", _logicModule, true];

// init actions
[_logicModule] call SCAR_UCM_fnc_addActionsToForeman;

// return
true
