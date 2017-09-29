/*
    Author: _SCAR

    Description:
    Initializes surgical strikes.

    Parameter(s);
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_surgicalStrikeInit;
*/

if !(isServer) then {};

params ["_logicModule"];

// get sync'ed
private _strikeModules = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionSurgicalStrike"] call BIS_fnc_synchronizedObjects;
if ((count _strikeModules) == 0) exitWith {};

// get mod
private _strikeModule = _strikeModules select 0;

// settings
_strikeModule setVariable ["SCAR_UCM_Strike_attackProbability", 1.0, true];
_strikeModule setVariable ["SCAR_UCM_Strike_attackMaxGroups", 2, true];
_strikeModule setVariable ["SCAR_UCM_Strike_attackIntervalMin", 60, true];

// init
_strikeModule setVariable ["SCAR_UCM_Strike_logicModule", _logicModule, true];
_strikeModule setVariable ["SCAR_UCM_Strike_attackIsOngoing", false, true];

// loop
[_strikeModule] call SCAR_UCM_fnc_surgicalStrikeLoop;

// return
true
