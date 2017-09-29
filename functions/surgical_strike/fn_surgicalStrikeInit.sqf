/*
    Author: _SCAR

    Description:
    Initializes surgical strikes.

    Parameter(s);
    0: OBJECT - The logicModule.

    Return:
    true

    Example:
    [_logicModule] call SCAR_UCM_fnc_strikeInit;
*/

if !(isServer) then {};

params ["_logicModule"];

// get sync'ed
private _strikeMods = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionSurgicalStrike"] call BIS_fnc_synchronizedObjects;
if ((count _strikeMods) == 0) exitWith {};

// loop attack
[_logicModule] call SCAR_UCM_fnc_strikeLoop;

// return
true
