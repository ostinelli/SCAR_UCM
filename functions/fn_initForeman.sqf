/*
    Author: _SCAR

    Description:
    Initializes the foreman.

    Parameter(s):
    0: OBJECT - The store.

    Return:
    0: true

    Example:
    [_store] call SCAR_UCM_fnc_initForeman;
*/

if !(isServer) exitWith {};

params ["_store"];

// vars
private _foreman = _store getVariable "SCAR_UCM_foreman";

// init foreman
_foreman allowDamage false;
if (_foreman isKindOf "Man") then {
    _foreman disableAI "MOVE";
    (group _foreman) setBehaviour "CARELESS";
};

// return
true
