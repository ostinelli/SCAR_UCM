/*
    Author: _SCAR

    Description:
    Adds the action to a worker or a foreman to request workers.

    Parameter(s):
    0:  UNIT.

    Return:
    true

    Example:
    [_unit] call SCAR_UCM_fnc_addActionRequestWorkers;
*/

if !(hasInterface) exitWith {};

params ["_unit"];

_action = [
    "SCAR_UCM_RequestWorkers",
    (localize "STR_SCAR_UCM_Main_RequestWorkers"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_caller"];
        private _logicModule = _target getVariable "SCAR_UCM_logicModule";

        [_logicModule, _caller] remoteExec ["SCAR_UCM_fnc_requestWorkers", 2];
    },
    // Condition <CODE>
    {
        params ["_target"];
        [_target] call SCAR_UCM_fnc_canRespondToActions
    }
] call ace_interact_menu_fnc_createAction;
[_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// return
true
