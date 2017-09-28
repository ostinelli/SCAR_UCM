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
    // add get out actions from a vehicles a worker has been in
    // condition on the action will be to check for alive workers in, so no need to remove action
    _worker addEventHandler ["GetInMan", {

        params ["_worker", "_position", "_vehicle"];

        [_vehicle] remoteExec ["SCAR_UCM_fnc_addActionGetOut"];
    }];
};

// return
true
