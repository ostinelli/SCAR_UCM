/*
    Author: _SCAR

    Description:
    Handles ACE bug of putting unloaded cargo item not properly. This function is called automatically on mission init.

    Parameter(s):
    0: OBJET: The logicModule.

    Return:
    0: true

    Example:
    [] call SCAR_UCM_fnc_onUnloadedCargoPos;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// handle cargo unloaded
["ace_cargoItemUnoaded", {

    params ["_item", "_vehicle"];

    private _logicModule = _thisArgs;

    if ((typeOf _item) == (_logicModule getVariable "SCAR_UCM_materialsClass")) then {
        // reposition vehicle
        _item setVehiclePosition [getPos _vehicle, [], 0, "NONE"];
    };
}, _logicModule] call CBA_fnc_addEventHandlerArgs;

// return
true
