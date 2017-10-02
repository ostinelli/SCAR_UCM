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

// vars
private _logicModule = _unit getVariable "SCAR_UCM_logicModule";
private _side        = _logicModule getVariable "SCAR_UCM_side";

// check side
if !((side player) == _side) exitWith {};

// code
private _statement = {
    params ["_target", "_caller"];
    private _logicModule = _target getVariable "SCAR_UCM_logicModule";

    [_logicModule, _caller] remoteExec ["SCAR_UCM_fnc_requestWorkers", 2];
};

private _condition = {
    if (isNil "_target") then { private _target = _this select 0; }; // compatibility vanilla & ACE
    [_target] call SCAR_UCM_fnc_canRespondToActions
};

if (SCAR_UCM_ACE) then {
    // ACE

    _action = [
        "SCAR_UCM_RequestWorkers",
        (localize "STR_SCAR_UCM_Main_RequestWorkers"),
        "",
        _statement,
        // condition
        {
            params ["_target"];
            [_target] call SCAR_UCM_fnc_canRespondToActions
        }
    ] call ace_interact_menu_fnc_createAction;
    [_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

} else {
    // VANILLA

    _unit addAction [
        (localize "STR_SCAR_UCM_Main_RequestWorkers"),
        _statement,
        nil,  // arguments
        1.5,  // priority
        true, // showWindow
        true, // hideOnUse
        "",   // shortcut
        "[_target] call SCAR_UCM_fnc_canRespondToActions", // condition
        5     // radius
    ];
};

// return
true
