/*
    Author: _SCAR

    Description:
    Adds the action to a vehicle to allow all workers to get out.

    Parameter(s):
    0: OBJECT - The vehicle.

    Return:
    true

    Example:
    [_vehicle] call SCAR_UCM_fnc_addActionGetOut;
*/

if !(hasInterface) exitWith {};

params ["_vehicle"];

// code
private _statement = {
    params ["_target"];

    // loop all workers
    {
        private _isWorker = _x getVariable ["SCAR_UCM_isWorker", false];

        if (_isWorker) then {
            // get out
            [_x] orderGetIn false;
            unassignVehicle _x;
        };
    } forEach (crew _target);
};

private _condition = {
    if (isNil "_target") then { private _target = _this select 0; }; // compatibility vanilla & ACE

    // count
    private _count = 0;
    {
        private _isWorker = _x getVariable ["SCAR_UCM_isWorker", false];
        if (
            _isWorker
            && ((side _x) == (side player))
        ) then { _count = _count + 1; };
    } forEach (crew _target);

    _count > 0
};

if (SCAR_UCM_ACE) then {
    // ACE

    _actionInfo = [
        "SCAR_UCM_AllWorkersGetOutOfVehicle",
        (localize "STR_SCAR_UCM_Main_AllWorkersExitVehicle"),
        "",
        _statement,
        _condition
    ];

    // add action to everyone
     _action = _actionInfo call ace_interact_menu_fnc_createAction;
    [_vehicle, 0, ["ACE_MainActions", "ACE_Passengers"], _action] call ace_interact_menu_fnc_addActionToObject;
} else {
    // VANILLA

    _vehicle addAction [
        (localize "STR_SCAR_UCM_Main_AllWorkersExitVehicle"),
        _statement,
        nil,  // arguments
        1.5,  // priority
        true, // showWindow
        true, // hideOnUse
        "",   // shortcut
        (_condition call SCAR_UCM_fnc_convertCodeToStr),
        5     // radius
    ];
};

// return
true
