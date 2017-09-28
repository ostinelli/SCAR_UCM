/*
    Author: _SCAR

    Description:
    Callback after selecting a vehicle for a worker.

    Parameter(s):
    0: OBJECT - The object we selected a vehicle for.
    1: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_worker, _vehicle] call SCAR_UCM_fnc_guiVehicleSelectionDoneForWorker;
*/

params ["_worker", "_vehicle"];

// order get in
[_worker, _vehicle] call SCAR_UCM_fnc_getInVehicle;

// close dialog
closeDialog 1;

// return
true
