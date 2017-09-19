/*
    Author: _SCAR

    Description:
    Adds the action to a vehicle to allow passengers to get out.

    Parameter(s):
    0: OBJECT - The store.
    1: OBJECT - The worker.
    2: UNIT - The vehicle.

    Return:
    0: true

    Example:
    [_store, _worker, _vehicle] call SCAR_UCM_fnc_addActionWorkerGetOut;
*/

if !(hasInterface) exitWith {};

params ["_store", "_worker", "_vehicle"];

// remove action  (covers the double action bug).
[_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _worker, "SCAR_UCM_WorkerGetOutOfVehicle"]] call ace_interact_menu_fnc_removeActionFromObject;

// add action
_actionInfo = [
    "SCAR_UCM_WorkerGetOutOfVehicle",
    (localize "STR_SCAR_UCM_Main_ExitVehicle"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_vehicle"];

        // get out
        [_target] orderGetIn false;
        unassignVehicle _target;

        // remove action from everyone
        [_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _target, "SCAR_UCM_WorkerGetOutOfVehicle"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject"];
    },
    // Condition <CODE>
    { true },
    {},
    _vehicle
];

// add action to everyone
 _action = _actionInfo call ace_interact_menu_fnc_createAction;
[_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _worker], _action] call ace_interact_menu_fnc_addActionToObject;

// return
true
