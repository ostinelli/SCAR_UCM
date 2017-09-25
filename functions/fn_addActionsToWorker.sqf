/*
    Author: _SCAR

    Description:
    Adds the actions to the worker.

    Parameter(s);
    0: OBJECT - The logicModule.
    1: UNIT - the unit to attach the action to.

    Return:
    0: true

    Example:
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionsToWorker;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_worker"];

// action to request status
[_logicModule, _worker] call SCAR_UCM_fnc_addActionRequestStatus;

// action to GET IN
[_logicModule, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;

// action go to construction area
[_logicModule, _worker] call SCAR_UCM_fnc_addActionGoToConstructionArea;

// return
true
