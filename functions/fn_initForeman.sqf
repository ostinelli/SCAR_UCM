/*
    Author: _SCAR

    Description:
    Initializes the foreman.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: true

    Example:
    [_logicModule] call SCAR_UCM_fnc_initForeman;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// vars
private _foreman = _logicModule getVariable "SCAR_UCM_foreman";

// init foreman
_foreman allowDamage false;
if (_foreman isKindOf "Man") then {
    _foreman disableAI "MOVE";
    (group _foreman) setBehaviour "CARELESS";
};

// return
true
