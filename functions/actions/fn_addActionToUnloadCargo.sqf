/*
    Author: _SCAR

    Description:
    Adds the action to a unload cargo from a vehicle. This is only for non-ACE interactions.

    Parameter(s):
    0: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_vehicle] call SCAR_UCM_fnc_addActionToUnloadCargo;
*/

if !(hasInterface) exitWith {};

params ["_vehicle"];

// action
private _condition = {
    // count cargo objects
    private _count = 0;
    {
        private _isCargo = (_x getVariable ["SCAR_UCM_isCargo", false]);
        if (_isCargo) then { _count = _count + 1; };
    } forEach (attachedObjects _target);

    _count > 0 && !(_this in _target) // caller cannot be in vehicle
};

_vehicle addAction [
   (localize "STR_SCAR_UCM_Cargo_UnloadFromVehicle"),
   {
       params ["_target"];
       [_target, "SCAR_UCM_fnc_guiCargoSelectionDoneFromVehicle"] call SCAR_UCM_fnc_guiOpenCargoSelection;
   },
   nil,  // arguments
   1.5,  // priority
   true, // showWindow
   true, // hideOnUse
   "",   // shortcut
   (_condition call SCAR_UCM_fnc_convertCodeToStr), // condition
   5     // radius
];

// return
true
