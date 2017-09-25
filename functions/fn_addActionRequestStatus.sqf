/*
    Author: _SCAR

    Description:
    Adds the status action to a unit.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: UNIT   - The unit to attach the action to.

    Return:
    0: true

    Example:
    [_logicModule, _unit] call SCAR_UCM_fnc_addActionRequestStatus;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_unit"];

private _action = [
    "SCAR_UCM_Status",
    (localize "STR_SCAR_UCM_Main_RequestStatus"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        hint ([_logicModule] call SCAR_UCM_fnc_getStatusString);
    },
    // Condition <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_target] call SCAR_UCM_fnc_canRespondToActions
    },
    {},
    _logicModule
] call ace_interact_menu_fnc_createAction;
[_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// return
true
