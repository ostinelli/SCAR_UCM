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

if !(isServer) exitWith {};

// add actions to local players
private _jipRef = format["SCAR_UCM_actions_%1", (_worker call BIS_fnc_netId)];
[_worker] remoteExec ["SCAR_UCM_fnc_addActionsToWorkerLocal", 0, _jipRef]; // JIP

// remove if dead
_worker addEventHandler ["killed", {
    params ["_worker"];
    // removes from the JIP queue
    private _jipRef = format["SCAR_UCM_actions_%1", (_worker call BIS_fnc_netId)];
    remoteExec ["", _jipRef];
}];

// add get out actions to a vehicles a worker has been in
// condition on the action will be to check for alive workers in, so no need to remove action
_worker addEventHandler ["GetInMan", {

    params ["_worker", "_position", "_vehicle"];

    // check if action already added
    private _alreadyAdded = _vehicle getVariable ["SCAR_UCM_actionGetOutAlreadyAdded", false];
    if !(_alreadyAdded) then {
        // flag
        _vehicle setVariable ["SCAR_UCM_actionGetOutAlreadyAdded", true, true];
        // action
        [_vehicle] remoteExec ["SCAR_UCM_fnc_addActionGetOut", 0, _vehicle]; // JIP
    };
}];

// return
true
