/*
    Author: _SCAR

    Description:
    Adds the actions to the foreman.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_addActionsToForeman;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// vars
private _foreman = _logicModule getVariable "SCAR_UCM_foreman";

// add actions to local players
private _jipRef = format["SCAR_UCM_actions_%1", (_foreman call BIS_fnc_netId)];
[_foreman] remoteExec ["SCAR_UCM_fnc_addActionsToForemanLocal", 0, _jipRef]; // JIP

// remove if dead
_foreman addEventHandler ["killed", {
    params ["_foreman"];
    // removes from the JIP queue
    private _jipRef = format["SCAR_UCM_actions_%1", (_foreman call BIS_fnc_netId)];
    remoteExec ["", _jipRef];
}];

// return
true
