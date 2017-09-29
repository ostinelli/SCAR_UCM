/*
    Author: _SCAR

    Description:
    Unload an object from a vehicle. Function MUST be spawned because it contains a progress bar.

    Parameter(s):
    0: OBJECT - The cargo we are unloading from a vehicle.
    1: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_item, _vehicle] spawn SCAR_UCM_fnc_cargoItemUnoad;
*/

params ["_item", "_vehicle"];

// vars
private _itemWeight = _item getVariable "SCAR_UCM_cargoItemWeight";

// animation
[(_itemWeight * 4)] call SCAR_UCM_fnc_guiShowProgressBar; // add time to be compatible with ACE

// detach
detach _item;

// position
_item setVehiclePosition [getPos _vehicle, [], 0, "NONE"];

// unhide
_item hideObjectGlobal false;

hint localize "STR_SCAR_UCM_Cargo_Unloaded";

// return
true
