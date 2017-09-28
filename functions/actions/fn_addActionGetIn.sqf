/*
    Author: _SCAR

    Description:
    Adds the action to a worker to get in vehicles.

    Parameter(s):
    0: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_addActionGetIn;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

if (SCAR_UCM_ACE) then {
    // ACE

    _actionInfo = [
        "SCAR_UCM_GetInVehicle",
        (localize "STR_SCAR_UCM_Main_GoToVehicle"),
        "",
        // Statement <CODE>
        {},
        // Condition <CODE>
        {
            params ["_target"];
            [_target] call SCAR_UCM_fnc_canRespondToActions
        },
        // Children code <CODE> (Optional)
        {
            params ["_target"];
            private _logicModule = _target getVariable "SCAR_UCM_logicModule";

            // find cars
            private _vehicles = nearestObjects [_target, ["Car", "Helicopter"], 100];

            private _actions = [];
            {
                // display name
                private _displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
                _displayName = _displayName + format[" (a %1m)", round(_x distance _target)];

                // define action to order GETIN
                private _action = [
                    format ["SCAR_UCM_GetInVehicle:%1", _x],
                    _displayName,
                    "",
                    {
                        // order to GETIN
                        private _vehicle = (_this select 2);
                        [_target, _vehicle] call SCAR_UCM_fnc_getInVehicle;
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
        }
    ];
     _action = _actionInfo call ace_interact_menu_fnc_createAction;
    [_worker, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

} else {
    // VANILLA

    private _condition = {
        // find cars
        private _vehicles = nearestObjects [_target, ["Car", "Helicopter"], 100];
        // any cars?
        (count _vehicles) > 0
    };

    _worker addAction [
        (localize "STR_SCAR_UCM_Main_GoToVehicle"),
        {
            params ["_target"];
            [_target, "SCAR_UCM_fnc_guiVehicleSelectionDoneForWorker", 100] call SCAR_UCM_fnc_guiOpenVehicleSelection;
        },
        nil,  // arguments
        1.5,  // priority
        false,// showWindow
        true, // hideOnUse
        "",   // shortcut
        (_condition call SCAR_UCM_fnc_convertCodeToStr), // condition
        5     // radius
    ];
};

// return
true
