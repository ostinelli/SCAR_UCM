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

// vars
private _cargoWeight = _cargo getVariable "SCAR_UCM_cargoWeight";

// animation
[(_cargoWeight * 5)] call SCAR_UCM_fnc_guiShowProgressBar; // add time to be compatible with ACE

// detach
detach _cargo;

// position
_cargo setVehiclePosition [getPos _vehicle, [], 0, "NONE"];

// unhide
_cargo hideObjectGlobal false;

hint localize "STR_SCAR_UCM_Cargo_Unloaded";

// return
true
