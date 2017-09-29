/*
    Author: _SCAR

    Description:
    Order a worker to get into a vehicle.

    Parameter(s);
    0: UNIT - the unit to attach the action to.

    Return:
    true

    Example:
    [_unit, _vehicle] call SCAR_UCM_fnc_getInVehicle;
*/

params ["_worker", "_vehicle"];

// stop animation, if any
[_worker, 0] call SCAR_UCM_fnc_setWorkerAnimation;

// set stance
_worker setUnitPos "AUTO";
_worker playAction "PlayerStand";

// remove handcuffs, if any
[_worker, false] call ACE_captives_fnc_setHandcuffed;

// move worker in vehicle
unassignVehicle _worker;
[_worker] allowGetIn true;
_worker assignAsCargo _vehicle;
[_worker] orderGetIn true;

// return
true
