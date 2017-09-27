/*
    Author: _SCAR

    Description:
    Adds the action to a worker or the foreman to request materials.

    Parameter(s):
    0: UNIT.

    Return:
    true

    Example:
    [_unit] call SCAR_UCM_fnc_addActionRequestMaterials;
*/

if !(hasInterface) exitWith {};

params ["_unit"];

if (SCAR_UCM_ACE) then {
    // ACE

    _action = [
        "SCAR_UCM_RequestMaterial",
        (localize "STR_SCAR_UCM_Main_RequestMaterials"),
        "",
        // Statement <CODE>
        {
            params ["_target", "_caller"];
            private _logicModule = _target getVariable "SCAR_UCM_logicModule";

            [_logicModule, _caller] remoteExec ["SCAR_UCM_fnc_requestMaterial", 2];
        },
        // Condition <CODE>
        {
            params ["_target", "_player", "_logicModule"];
            [_target] call SCAR_UCM_fnc_canRespondToActions
        }
    ] call ace_interact_menu_fnc_createAction;
    [_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;
} else {
    // VANILLA

};

// return
true
