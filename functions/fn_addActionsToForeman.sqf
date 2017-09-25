/*
    Author: _SCAR

    Description:
    Adds the actions to the foreman.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_addActionsToForeman;
*/

if !(hasInterface) exitWith {};

params ["_logicModule"];

// vars
_foreman = _logicModule getVariable "SCAR_UCM_foreman";

// status
[_logicModule, _foreman] call SCAR_UCM_fnc_addActionRequestStatus;

// workers
[_logicModule, _foreman] call SCAR_UCM_fnc_addActionRequestWorkers;

// materials
[_logicModule, _foreman] call SCAR_UCM_fnc_addActionRequestMaterials;

// return
true
