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

params ["_logicModule", "_worker"];

if (hasInterface) then {
    // action to request status
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionRequestStatus;

    // action to GET IN
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;

    // action go to construction area
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionGoToConstructionArea;
};

if (isServer) then {
    // action to exit vehicle
    _worker addEventHandler ["GetInMan", {

        params ["_worker", "_position", "_vehicle"];

        private _logicModule = _worker getVariable "SCAR_UCM_logicModule";

        // add action to GETOUT to all clients
        [_logicModule, _worker, _vehicle] remoteExec ["SCAR_UCM_fnc_addActionWorkerGetOut"];
    }];

    _worker addEventHandler ["GetOutMan", {

        params ["_worker", "_position", "_vehicle"];

        private _logicModule = _worker getVariable "SCAR_UCM_logicModule";

        // add action to GETOUT to all clients
        [_logicModule, _worker, _vehicle] remoteExec ["SCAR_UCM_fnc_removeActionWorkerGetOut"];
    }];
};

// return
true
