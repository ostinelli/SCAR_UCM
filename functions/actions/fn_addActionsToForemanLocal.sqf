/*
    Author: _SCAR

    Description:
    Adds the actions to the foreman (local).

    Parameter(s):
    0: UNIT - the unit to attach the action to.

    Return:
    true

    Example:
    [_foreman] call SCAR_UCM_fnc_addActionsToForemanLocal;
*/

if !(hasInterface) exitWith {};

params ["_foreman"];

// status
[_foreman] call SCAR_UCM_fnc_addActionRequestStatus;

// workers
[_foreman] call SCAR_UCM_fnc_addActionRequestWorkers;

// materials
[_foreman] call SCAR_UCM_fnc_addActionRequestMaterials;

// return
true
