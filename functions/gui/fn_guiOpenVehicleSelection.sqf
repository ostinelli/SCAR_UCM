/*
    Author: _SCAR

    Description:
    Opens the vehicle selection for an object.

    Parameter(s):
    0: OBJECT - The object that we're selecting a vehicle for.
    1: OBJECT - The callback function name once the selection is done.
    1: NUMBER - The distance from the object.

    Return:
    true

    Example:
    [_object, "SCAR_UCM_fnc_guiVehicleSelectionDoneForWorker", 100] spawn SCAR_UCM_fnc_guiOpenVehicleSelection;
*/

params ["_object", "_callbackFunctionName", "_distance"];

// IDc
private _listBox = 21950;

// init
disableSerialization;

// create dialog
createDialog "SCAR_UCM_SelectDialog";

// find cars
private _vehicles = nearestObjects [_object, ["Car", "Helicopter"], _distance];

// save to mission namespace
missionNamespace setVariable ["SCAR_UCM_SelectionOptions", _vehicles];
missionNamespace setVariable ["SCAR_UCM_SelectionObject", _object];
missionNamespace setVariable ["SCAR_UCM_SelectionFunction", _callbackFunctionName];

// add to listbox
{
    if (alive _x) then {
        // display name
        private _displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
        _displayName = _displayName + format[" (a %1m)", round(_x distance _object)];
        // add item
        lbAdd [_listBox, _displayName];
    };
} forEach _vehicles;

// return
true
