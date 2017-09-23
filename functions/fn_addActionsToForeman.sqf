/*
    Author: _SCAR

    Description:
    Adds the actions to the foreman.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_addActionsToForeman;
*/

if !(hasInterface) exitWith {};

params ["_logicModule"];

// vars
_foreman = _logicModule getVariable "SCAR_UCM_foreman";

// workers
_action = [
    "SCAR_UCM_RequestWorkers",
    (localize "STR_SCAR_UCM_Main_RequestWorkers"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_logicModule, player] remoteExec ["SCAR_UCM_fnc_requestWorkers", 2];
    },
    // Condition <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_target] call SCAR_UCM_fnc_canRespondToActions
    },
    {},
    _logicModule
] call ace_interact_menu_fnc_createAction;
[_foreman,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// materials
_action = [
    "SCAR_UCM_RequestMaterial",
    (localize "STR_SCAR_UCM_Main_RequestMaterials"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_logicModule, player] remoteExec ["SCAR_UCM_fnc_requestMaterial", 2];
    },
    // Condition <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_target] call SCAR_UCM_fnc_canRespondToActions
    },
    {},
    _logicModule
] call ace_interact_menu_fnc_createAction;
[_foreman,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// status
[_logicModule, _foreman] call SCAR_UCM_fnc_addActionRequestStatus;

// return
true
