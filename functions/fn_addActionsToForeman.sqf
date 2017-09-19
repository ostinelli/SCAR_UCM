/*
    Author: _SCAR

    Description:
    Adds the actions to the foreman.

    Parameter(s):
    0: OBJECT - The store.

    Return:
    0: true

    Example:
    [_store] call SCAR_UCM_fnc_addActionsToForeman;
*/

if !(hasInterface) exitWith {};

params ["_store"];

// vars
_foreman = _store getVariable "SCAR_UCM_foreman";

// workers
_action = [
    "SCAR_UCM_RequestWorkers",
    (localize "STR_SCAR_UCM_Main_RequestWorkers"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_store"];
        [_store, player] remoteExec ["SCAR_UCM_fnc_requestWorkers", 2];
    },
    // Condition <CODE>
    { true },
    {},
    _store
] call ace_interact_menu_fnc_createAction;
[_foreman,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// materials
_action = [
    "SCAR_UCM_RequestMaterial",
    (localize "STR_SCAR_UCM_Main_RequestMaterials"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_store"];
        [_store, player] remoteExec ["SCAR_UCM_fnc_requestMaterial", 2];
    },
    // Condition <CODE>
    { true },
    {},
    _store
] call ace_interact_menu_fnc_createAction;
[_foreman,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// status
[_store, _foreman] call SCAR_UCM_fnc_addActionRequestStatus;

// return
true
