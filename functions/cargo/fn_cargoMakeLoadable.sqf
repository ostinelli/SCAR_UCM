/*
    Author: _SCAR

    Description:
    Makes an object loadable.

    Parameter(s);
    0: OBJECT - The object to be made loadable.
    0: NUMBER - The weight.

    Return:
    true

    Example:
    [_cargo, 16] call SCAR_UCM_fnc_cargoMakeLoadable;
*/

if !(isServer) exitWith {};

params ["_cargo", "_weight"];

if (SCAR_UCM_ACE) then {
    // ACE
    [_cargo, _weight] remoteExec ["ace_cargo_fnc_setSize"];

} else {
    // VANILLA

    // set weight
    _cargo setVariable ["SCAR_UCM_cargoWeight", (_weight / 2), true]; // approximate to make compatible with ACE

    // add action
    private _action = [
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
    [_cargo, _action] remoteExec ["addAction", 0, _cargo];
};

// return
true
