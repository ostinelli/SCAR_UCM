/*
    Author: _SCAR

    Description:
    Load an object in a vehicle. Function MUST be spawned because it contains a progress bar.

    Parameter(s):
    0: OBJECT - The object we selected a vehicle for.
    1: OBJECT - The vehicle.

    Return:
    BOOLEAN

    Example:
    [_item, _vehicle] spawn SCAR_UCM_fnc_cargoItemLoad;
*/

if !(hasInterface) exitWith {};

params ["_item", "_vehicle"];

// can vehicle transport it?
private _vehicleSize = sizeOf (typeOf _vehicle); // size of vehicle, such as 10.15198
private _itemWeight = _item getVariable "SCAR_UCM_cargoItemWeight";

// acceptable ratio
private _acceptableRatio = 0.65;

if ( (_itemWeight / _vehicleSize) <= _acceptableRatio) then {

    // animation
    [(_itemWeight * 4), localize ("STR_SCAR_UCM_Cargo_Loading")] call SCAR_UCM_fnc_guiShowProgressBar; // add time to be compatible with ACE

    // attach
    _item attachTo [_vehicle, [0, 0, -100]];
    // hide
    _item hideObjectGlobal true;
    // action
    private _alreadyAdded = _vehicle getVariable ["SCAR_UCM_actionUnloadAlreadyAdded", false];
    if !(_alreadyAdded) then {
        // flag
        _vehicle setVariable ["SCAR_UCM_actionUnloadAlreadyAdded", true, true];
        // action
        [_vehicle] remoteExec ["SCAR_UCM_fnc_addActionToUnloadCargo", 0, _vehicle]; // JIP
    };
    // message
    hint localize "STR_SCAR_UCM_Cargo_Loaded";
    // return
    true

} else {
    // too heavy

    // message
    hint localize "STR_SCAR_UCM_Cargo_TooHeavy";
    // return
    false
};
