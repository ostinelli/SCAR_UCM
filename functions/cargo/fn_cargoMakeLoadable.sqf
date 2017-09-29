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
    [_item, 16] call SCAR_UCM_fnc_cargoMakeLoadable;
*/

if !(isServer) exitWith {};

params ["_item", "_weight"];

if (SCAR_UCM_ACE) then {
    // ACE
    [_item, _weight] remoteExec ["ace_cargo_fnc_setSize"];

} else {
    // VANILLA

    // flag
    _item setVariable ["SCAR_UCM_isCargo", true, true];
    // set weight
    _item setVariable ["SCAR_UCM_cargoItemWeight", (_weight / 2), true]; // approximate to make compatible with ACE
    // add action
    [_item] call SCAR_UCM_fnc_addActionToLoadCargo;
};

// return
true
