/*
    Author: _SCAR

    Description:
    Broadcasts the initialization of a worker's map marker on clients.

    Parameter(s):
    0: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_initMarkerWorker;
*/

if !(isServer) exitWith {};

params ["_worker"];

// prefs
private _logicModule        = _worker getVariable "SCAR_UCM_logicModule";
private _showWorkersMarkers = _logicModule getVariable "SCAR_UCM_showWorkersMarkers";
if !(_showWorkersMarkers) exitWith {};

// broadcast
[_worker] remoteExec ["SCAR_UCM_fnc_initMarkerWorkerLocal", 0, _worker];

// return
true
