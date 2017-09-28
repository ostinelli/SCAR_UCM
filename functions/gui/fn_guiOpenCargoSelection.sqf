/*
    Author: _SCAR

    Description:
    Opens the cargo selection for a vehicle.

    Parameter(s):
    0: OBJECT - The vehicle that we're selecting a cargo from.
    1: OBJECT - The callback function name once the selection is done.

    Return:
    true

    Example:
    [_object, "SCAR_UCM_fnc_guiVehicleSelectionDoneForWorker"] call SCAR_UCM_fnc_guiOpenCargoSelection;
*/

params ["_vehicle", "_callbackFunctionName"];

// IDc
private _listBox = 21950;

// create dialog
createDialog "SCAR_UCM_SelectDialog";

// find cargo
private _cargoObjects = [];
{
    private _isCargo = ((_x getVariable ["SCAR_UCM_cargoWeight", -100]) >= 0);
    if (_isCargo) then { _cargoObjects pushBack _x; };
} forEach (attachedObjects _vehicle);

// save to mission namespace
missionNamespace setVariable ["SCAR_UCM_SelectionOptions", _cargoObjects];
missionNamespace setVariable ["SCAR_UCM_SelectionObject", _vehicle];
missionNamespace setVariable ["SCAR_UCM_SelectionFunction", _callbackFunctionName];

// add to listbox
{
    if (alive _x) then {
        // display name
        private _displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
        // add item
        lbAdd [_listBox, _displayName];
    };
} forEach _cargoObjects;

// return
true
