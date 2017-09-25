/*
    Author: _SCAR

    Description:
    Adds the action to a worker to get in vehicles.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: OBJECT - The worker.

    Return:
    0: true

    Example:
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_worker"];

// add action
_actionInfo = [
    "SCAR_UCM_WorkerGetInVehicle",
    (localize "STR_SCAR_UCM_Main_GoToVehicle"),
    "",
    // Statement <CODE>
    {},
    // Condition <CODE>
    {
        params ["_target", "_player", "_logicModule"];
        [_target] call SCAR_UCM_fnc_canRespondToActions
    },
    // Children code <CODE> (Optional)
    {
        params ["_target", "_player", "_logicModule"];

        // find cars
        private _vehicles = nearestObjects [_target, ["Car", "Helicopter"], 100];

        private _actions = [];
        {
            // display name
            private _displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
            _displayName = _displayName + format[" (a %1m)", round(_x distance _target)];

            // define action to order GETIN
            private _action = [
                format ["SCAR_UCM_WorkerGetInVehicle:%1", _x],
                _displayName,
                "",
                {
                    // order to GETIN

                    // stop animation, if any
                    [_logicModule, _target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

                    // set stance
                    _target setUnitPos "AUTO";
                    _target playAction "PlayerStand";

                    // remove handcuffs, if any
                    [_target, false] call ACE_captives_fnc_setHandcuffed;

                    // init
                    private _vehicle = (_this select 2);
                    // move worker in vehicle
                    unassignVehicle _target;
                    [_target] allowGetIn true;
                    _target assignAsCargo _vehicle;
                    [_target] orderGetIn true;
                },
                { true },
                {},
                _x
            ] call ace_interact_menu_fnc_createAction;

            // add to actions
            _actions pushBack [_action, [], _target];
        } forEach _vehicles;

        // return
        _actions
    },
    _logicModule
];
 _action = _actionInfo call ace_interact_menu_fnc_createAction;
[_worker, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// return
true
