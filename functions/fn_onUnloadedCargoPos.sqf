/*
    Author: _SCAR

    Description:
    Handles ACE bug of putting unloaded cargo item not properly. This function is called automatically on mission init.

    Parameter(s):
    0: OBJET: The store.

    Return:
    0: true

    Example:
    [] call SCAR_UCM_fnc_onUnloadedCargoPos;
*/

if !(isServer) exitWith {};

params ["_store"];

// handle cargo unloaded
["ace_cargoUnloaded", {

    params ["_item", "_vehicle"];

    if ((typeOf _item) == (_store getVariable "SCAR_UCM_materialsClass")) then {
        // reposition vehicle
        _item setVehiclePosition [getPos _vehicle, [], 0, "NONE"];
    };
}] call CBA_fnc_addEventHandler;

// return
true
