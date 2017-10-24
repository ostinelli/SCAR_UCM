/*
    Author: _SCAR

    Description:
    Sets the worker's map marker.

    Parameter(s):
    0: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_initMarkerWorkerLocal;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

// check side
if !((side (group player)) == (side _worker)) exitWith {};

// loop
private _null = [_worker] spawn {

    params ["_worker"];

    // create marker
    private _marker = createMarkerLocal [format["SCAR_UCM_workerMarker:%1", _worker], getPos _worker];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "mil_dot";
    _marker setMarkerColorLocal format["color%1", (side _worker)];
    _marker setMarkerTextLocal localize "STR_SCAR_UCM_Main_Worker";

    while { alive _worker} do {
        // set position
        _marker setMarkerPosLocal getPos _worker;
        // sleep
        sleep 1;
    };

    // worker killed, delete
    deleteMarkerLocal _marker;
};

// return
true
