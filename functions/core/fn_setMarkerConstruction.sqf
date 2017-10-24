/*
    Author: _SCAR

    Description:
    Broadcasts the construction map marker to all clients.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: OBJECT - The piece.

    Return:
    true

    Example:
    [_logicModule, _pos] call SCAR_UCM_fnc_setMarkerConstruction;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_piece"];

// prefs
private _showAreaMarkers = _logicModule getVariable "SCAR_UCM_showAreaMarkers";
if !(_showAreaMarkers) exitWith {};

// broadcast
[_logicModule, _piece] remoteExec ["SCAR_UCM_fnc_setMarkerConstructionLocal", 0, _piece];

// return
true
