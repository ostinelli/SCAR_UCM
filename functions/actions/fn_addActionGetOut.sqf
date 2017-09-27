/*
    Author: _SCAR

    Description:
    Adds the action to a vehicle to allow a worker or foreman to get out.

    Parameter(s):
    0: UNIT - The worker.
    2: OBJECT - The vehicle.

    Return:
    0: true

    Example:
    [_worker, _vehicle] call SCAR_UCM_fnc_addActionWorkerGetOut;
*/

if !(hasInterface) exitWith {};

params ["_worker", "_vehicle"];

if (SCAR_UCM_ACE) then {
    // ACE

    _actionInfo = [
        "SCAR_UCM_GetOutOfVehicle",
        (localize "STR_SCAR_UCM_Main_ExitVehicle"),
        "",
        // Statement <CODE>
        {
            params ["_target"];

            // get out
            [_target] orderGetIn false;
            unassignVehicle _target;
        },
        // Condition <CODE>
        {
            params ["_target"];
            [_target] call SCAR_UCM_fnc_canRespondToActions
        },
        {},
        _vehicle
    ];

    // add action to everyone
     _action = _actionInfo call ace_interact_menu_fnc_createAction;
    [_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _worker], _action] call ace_interact_menu_fnc_addActionToObject;
} else {
    // VANILLA

};

// return
true
