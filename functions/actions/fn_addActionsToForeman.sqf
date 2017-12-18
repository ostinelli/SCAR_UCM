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
[_foreman] remoteExec ["SCAR_UCM_fnc_addActionsToForemanLocal", 0, _foreman]; // JIP

// return
true
