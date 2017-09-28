/*
    Author: _SCAR

    Description:
    Load an object in a vehicle.

    Parameter(s):
    0: OBJECT - The object we selected a vehicle for.
    1: OBJECT - The vehicle.

    Return:
    BOOLEAN

    Example:
    [_cargo, _vehicle] spawn SCAR_UCM_fnc_cargoLoad;
*/

if !(hasInterface) exitWith {};

params ["_cargo", "_vehicle"];

// can vehicle transport it?
private _vehicleSize = sizeOf (typeOf _vehicle); // size of vehicle, such as 10.15198
private _cargoWeight = _cargo getVariable "SCAR_UCM_cargoWeight";

// acceptable ration
private _acceptableRatio = 0.65;

if ( (_cargoWeight / _vehicleSize) <= _acceptableRatio) then {
    // ok can be loaded

    // attach
    _cargo attachTo [_vehicle, [0, 0, -100]];

    // hide
    _cargo hideObjectGlobal true;

    // check if unload action already added to vehicle
    private _alreadyAdded = _vehicle getVariable ["SCAR_UCM_actionUnloadAlreadyAdded", false];
    if !(_alreadyAdded) then {

        // flag
        _vehicle setVariable ["SCAR_UCM_actionUnloadAlreadyAdded", true, true];

        private _condition = {
            // count cargo objects
            private _count = 0;
            {
                private _isCargo = ((_x getVariable ["SCAR_UCM_cargoWeight", -100]) >= 0);
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
