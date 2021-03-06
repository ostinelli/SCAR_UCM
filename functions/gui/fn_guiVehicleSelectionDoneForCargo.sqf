/*
    Author: _SCAR

    Description:
    Callback after selecting a vehicle for a cargo.

    Parameter(s):
    0: OBJECT - The item we selected a vehicle for.
    1: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_item, _vehicle] call SCAR_UCM_fnc_guiVehicleSelectionDoneForCargo;
*/

params ["_item", "_vehicle"];

// load
[_item, _vehicle] spawn SCAR_UCM_fnc_cargoItemLoad;

// close dialog
closeDialog 1;

// return
true
