/*
    Author: _SCAR

    Description:
    Order a worker to get out of a vehicle.

    Parameter(s);
    0: UNIT - the unit to attach the action to.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_getOutVehicle;
*/

params ["_worker"];

// move worker in vehicle
[_worker] orderGetIn false;
unassignVehicle _worker;

// return
true
