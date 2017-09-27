/*
    Author: _SCAR

    Description:
    Removes the action to a vehicle to allow passengers to get out.

    Parameter(s):
    1: UNIT - The worker.
    2: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_worker, _vehicle] call SCAR_UCM_fnc_removeActionGetOut;
*/

if !(hasInterface) exitWith {};

params ["_worker", "_vehicle"];

if (SCAR_UCM_ACE) then {
    // ACE
    [_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _worker, "SCAR_UCM_GetOutOfVehicle"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject"];
} else {
    // VANILLA

};

// return
true
