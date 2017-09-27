/*
    Author: _SCAR

    Description:
    Safety valve to delete vehicle and crew after 20 minutes.

    Parameter(s):
    0: OBJECT - The vehicle.
    0: ARRAY - units in the crew.

    Return:
    0: true

    Example:
    [_vehicle, _crew] call SCAR_UCM_fnc_safetyDeleteVehicleAndCrew;
*/

if !(isServer) exitWith {};

params ["_vehicle", "_crew"];

// init
private _deleteAfter = 1200; // 20 minutes

private _null = [_vehicle, _crew, _deleteAfter] spawn {

    params ["_vehicle", "_crew", "_deleteAfter"];

    sleep _deleteAfter;

    if (alive _vehicle) then {
        deleteVehicle _vehicle;
    };

    {
        if (alive _x) then {
            deleteVehicle _x;
        };
    } forEach _crew;
};

// return
true
