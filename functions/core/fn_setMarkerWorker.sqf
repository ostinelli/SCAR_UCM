/*
    Author: _SCAR

    Description:
    Sets the worker's map marker.

    Parameter(s):
    0: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_setMarkerWorker;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

// check side
if !((side player) == (side _worker)) exitWith {};

// did we initialize markers on this worker yet?
private _previousMarker = _worker getVariable ["SCAR_UCM_workerMarker", objNull];
if (_previousMarker isEqualTo objNull) then {
    // no previous marker --> init
    _worker addEventHandler ["Killed", {
        _killed = _this select 0;
        // delete marker
        _marker = _killed getVariable "SCAR_UCM_workerMarker";
        deleteMarkerLocal _marker;
    }];
} else {
    deleteMarkerLocal _previousMarker;
};

// create
private _marker = createMarkerLocal [format["SCAR_UCM_workerMarker:%1", _worker], getPos _worker];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "mil_dot";
_marker setMarkerColorLocal format["color%1", (side _worker)];
_marker setMarkerTextLocal localize "STR_SCAR_UCM_Main_Worker";

// save vars
_worker setVariable ["SCAR_UCM_workerMarker", _marker];

// return
true
