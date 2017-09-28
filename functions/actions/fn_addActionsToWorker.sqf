/*
    Author: _SCAR

    Description:
    Adds the actions to the worker.

    Parameter(s);
    0: UNIT - the unit to attach the action to.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_addActionsToWorker;
*/

params ["_worker"];

if (hasInterface) then {
    // action to request status
    [_worker] call SCAR_UCM_fnc_addActionRequestStatus;

    // action to GET IN
    [_worker] call SCAR_UCM_fnc_addActionGetIn;

    // action go to construction area
    [_worker] call SCAR_UCM_fnc_addActionGoToConstructionArea;
};

if (isServer) then {
    // action to exit vehicle
    _worker addEventHandler ["GetInMan", {

        params ["_worker", "_position", "_vehicle"];

        // add action to GETOUT to all clients
        [ _worker, _vehicle] remoteExec ["SCAR_UCM_fnc_addActionGetOut"];
    }];

    _worker addEventHandler ["GetOutMan", {

        params ["_worker", "_position", "_vehicle"];

        // add action to GETOUT to all clients
        [_worker, _vehicle] remoteExec ["SCAR_UCM_fnc_removeActionGetOut"];
    }];
};

// return
true
