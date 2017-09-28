/*
    Author: _SCAR

    Description:
    Opens the vehicle selection for a worker.

    Parameter(s):
    1: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] spawn SCAR_UCM_fnc_removeActionGetOut;
*/

params ["_worker"];

// init
disableSerialization;

// create dialog
createDialog "SCAR_UCM_SelectVehicleDialog";

// define idc's for controls
private _listBox = 21950;

// find cars
private _vehicles = nearestObjects [_worker, ["Car", "Helicopter"], 100];

// save to mission namespace
missionNamespace setVariable ["SCAR_UCM_workerInteractedWith", _worker];

// add to listbox
{
    // display name
    private _displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
    _displayName = _displayName + format[" (a %1m)", round(_x distance _target)];
    // add item
    lbAdd [_listBox, _displayName];
} forEach _vehicles;

// return
true
