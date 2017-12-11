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

// vars
private _logicModule = _unit getVariable "SCAR_UCM_logicModule";
private _side        = _logicModule getVariable "SCAR_UCM_side";

// check side
if !((side group player) == _side) exitWith {};

// code
private _statement = {
    params ["_target"];
    private _logicModule = _target getVariable "SCAR_UCM_logicModule";

    hint ([_logicModule] call SCAR_UCM_fnc_getStatusString);
};

private _condition = {
    if (isNil "_target") then { private _target = _this select 0; }; // compatibility vanilla & ACE
    [_target] call SCAR_UCM_fnc_canRespondToActions
};

if (SCAR_UCM_ACE) then {
    // ACE

    private _action = [
        "SCAR_UCM_Status",
        (localize "STR_SCAR_UCM_Main_RequestStatus"),
        "",
        _statement,
        _condition
    ] call ace_interact_menu_fnc_createAction;
    [_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

} else {
    // VANILLA

    _unit addAction [
        (localize "STR_SCAR_UCM_Main_RequestStatus"),
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
