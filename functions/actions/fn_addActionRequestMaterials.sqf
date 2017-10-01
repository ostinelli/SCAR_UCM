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

// check side
if !((side player) == (side _unit)) exitWith {};

// code
private _statement = {
    params ["_target", "_caller"];
    private _logicModule = _target getVariable "SCAR_UCM_logicModule";

    [_logicModule, _caller] remoteExec ["SCAR_UCM_fnc_requestMaterial", 2];
};

private _condition = {
    if (isNil "_target") then { private _target = _this select 0; }; // compatibility vanilla & ACE
    [_target] call SCAR_UCM_fnc_canRespondToActions
};

if (SCAR_UCM_ACE) then {
    // ACE

    _action = [
        "SCAR_UCM_RequestMaterial",
        (localize "STR_SCAR_UCM_Main_RequestMaterials"),
        "",
        _statement,
        _condition
    ] call ace_interact_menu_fnc_createAction;
    [_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;
} else {
    // VANILLA

    _unit addAction [
        (localize "STR_SCAR_UCM_Main_RequestMaterials"),
        _statement,
        nil,  // arguments
        1.5,  // priority
        true, // showWindow
        true, // hideOnUse
        "",   // shortcut
        (_condition call SCAR_UCM_fnc_convertCodeToStr),
        5     // radius
    ];
};

// return
true
