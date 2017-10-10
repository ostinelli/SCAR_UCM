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

// ensure worker is not dragged back to work if ordered to get in vehicle
private _goingToVehicle = _worker getVariable ["SCAR_UCM_goingToVehicle", objNull];
if (_goingToVehicle isEqualTo objNull) then {
    // flag never set before, add event to remove flag when worker gets out of vehicle
    _worker addEventHandler ["GetOutMan", {
        params ["_worker"];
        _worker setVariable ["SCAR_UCM_goingToVehicle", false, true];
    }];
};
// set flag that worker is getting into vehicle
_worker setVariable ["SCAR_UCM_goingToVehicle", true, true];

// stop animation, if any
[_worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

// set stance
_worker setUnitPos "AUTO";
_worker playAction "PlayerStand";

// remove handcuffs, if any
if (SCAR_UCM_ACE) then {
    [_worker, false] remoteExec ["ACE_captives_fnc_setHandcuffed"];
};

// move worker in vehicle
unassignVehicle _worker;
[_worker] allowGetIn true;
_worker assignAsCargo _vehicle;
[_worker] orderGetIn true;

// return
true
