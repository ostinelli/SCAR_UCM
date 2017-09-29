/*
    Author: _SCAR

    Description:
    Adds the action to a cargo item to be loaded. This is only for non-ACE interactions.

    Parameter(s):
    0: OBJECT - The cargo item.

    Return:
    true

    Example:
    [_item] call SCAR_UCM_fnc_addActionToLoadCargo;
*/

if !(hasInterface) exitWith {};

params ["_item"];

// add action
_item addAction [
    (localize "STR_SCAR_UCM_Cargo_LoadInVehicle"),
    {
        params ["_target"];
        [_target, "SCAR_UCM_fnc_guiVehicleSelectionDoneForCargo", 10] call SCAR_UCM_fnc_guiOpenVehicleSelection;
    },
    nil,  // arguments
    1.5,  // priority
    false,// showWindow
    true, // hideOnUse
    "",   // shortcut
    "",   // condition
    5     // radius
];

// return
true
