/*
    Author: _SCAR

    Description:
    Unload an object from a vehicle.

    Parameter(s):
    0: OBJECT - The cargo we are unloading from a vehicle.
    1: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_cargo, _vehicle] call SCAR_UCM_fnc_cargoUnload;
*/

params ["_cargo", "_vehicle"];

// detach
detach _cargo;

// position
_cargo setVehiclePosition [getPos _vehicle, [], 0, "NONE"];

// unhide
_cargo hideObjectGlobal false;

hint localize "STR_SCAR_UCM_Cargo_Unloaded";

// return
true
