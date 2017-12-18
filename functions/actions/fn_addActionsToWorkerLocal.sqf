/*
    Author: _SCAR

    Description:
    Adds the actions to the worker (local).

    Parameter(s);
    0: UNIT - the unit to attach the action to.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_addActionsToWorkerLocal;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

// action to request status
[_worker] call SCAR_UCM_fnc_addActionRequestStatus;

// action to GET IN
[_worker] call SCAR_UCM_fnc_addActionGetIn;

// action go to construction area
[_worker] call SCAR_UCM_fnc_addActionGoToConstructionArea;

// return
true
