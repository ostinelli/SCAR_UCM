/*
    Author: _SCAR

    Description:
    Checks if the unit can respond to actions.

    Parameter(s):
    0:UNIT - The unit.

    Return:
    BOOLEAN.

    Example:
    [_unit] call SCAR_UCM_fnc_canRespondToActions;
*/

params ["_unit"];

private _isUnconscious = false;

if (_unit isKindOf "Man") then {
    _isUnconscious = _unit getVariable ["ACE_isUnconscious", false];
};

// return
(alive _unit) && !_isUnconscious
