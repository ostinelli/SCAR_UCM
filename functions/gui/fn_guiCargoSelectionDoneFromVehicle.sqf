/*
    Author: _SCAR

    Description:
    Callback after selecting a cargo from a vehicle.

    Parameter(s):
    0: OBJECT - The cargo we selected a vehicle from.
    1: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_cargo, _vehicle] spawn SCAR_UCM_fnc_guiCargoSelectionDoneFromVehicle;
*/

params ["_vehicle", "_item"];

// load
[_item, _vehicle] spawn SCAR_UCM_fnc_cargoItemUnload;

// close dialog
closeDialog 1;

// return
true
