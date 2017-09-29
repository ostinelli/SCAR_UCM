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

// acceptable ration
private _acceptableRatio = 0.65;

if ( (_itemWeight / _vehicleSize) <= _acceptableRatio) then {

    // animation
    [(_itemWeight * 5)] call SCAR_UCM_fnc_guiShowProgressBar; // add time to be compatible with ACE

    // attach
    _item attachTo [_vehicle, [0, 0, -100]];

    // hide
    _item hideObjectGlobal true;

    // check if unload action already added to vehicle
    private _alreadyAdded = _vehicle getVariable ["SCAR_UCM_actionUnloadAlreadyAdded", false];
    if !(_alreadyAdded) then {

        // flag
        _vehicle setVariable ["SCAR_UCM_actionUnloadAlreadyAdded", true, true];

        private _condition = {
            // count cargo objects
            private _count = 0;
            {
                private _isCargo = (_x getVariable ["SCAR_UCM_isCargo", false]);
                if (_isCargo) then { _count = _count + 1; };
            } forEach (attachedObjects _target);

            _count > 0 && !(_this in _target) // caller cannot be in vehicle
        };

        private _action = [
            (localize "STR_SCAR_UCM_Cargo_UnloadFromVehicle"),
            {
                params ["_target"];
                [_target, "SCAR_UCM_fnc_guiCargoSelectionDoneFromVehicle"] call SCAR_UCM_fnc_guiOpenCargoSelection;
            },
            nil,  // arguments
            1.5,  // priority
            false,// showWindow
            true, // hideOnUse
            "",   // shortcut
            (_condition call SCAR_UCM_fnc_convertCodeToStr), // condition
            5     // radius
        ];
        [_vehicle, _action] remoteExec ["addAction", 0, _vehicle];
    };

    hint localize "STR_SCAR_UCM_Cargo_Loaded";

    // return
    true

} else {
   // too heavy

    hint localize "STR_SCAR_UCM_Cargo_TooHeavy";
    // return
    false
};
