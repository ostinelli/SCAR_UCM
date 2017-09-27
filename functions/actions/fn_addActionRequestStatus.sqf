/*
    Author: _SCAR

    Description:
    Adds the status action to a worker or a foreman.

    Parameter(s):
    0: UNIT - The unit to attach the action to.

    Return:
    true

    Example:
    [_logicModule, _unit] call SCAR_UCM_fnc_addActionRequestStatus;
*/

if !(hasInterface) exitWith {};

params ["_unit"];

if (SCAR_UCM_ACE) then {
    // ACE

    private _action = [
        "SCAR_UCM_Status",
        (localize "STR_SCAR_UCM_Main_RequestStatus"),
        "",
        // Statement <CODE>
        {
            params ["_target"];
            private _logicModule = _target getVariable "SCAR_UCM_logicModule";

            hint ([_logicModule] call SCAR_UCM_fnc_getStatusString);
        },
        // Condition <CODE>
        {
            params ["_target"];
            [_target] call SCAR_UCM_fnc_canRespondToActions
        }
    ] call ace_interact_menu_fnc_createAction;
    [_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

} else {
    // VANILLA

};

// return
true
