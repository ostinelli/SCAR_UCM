/*
    Author: _SCAR

    Description:
    Sets the pieceline altitude.

    Parameter(s):
    0: OBJECT - The object.
    0: NUMBER - The relative altitude from terrain.

    Return:
    true

    Example:
    [_piece, 0.9] call SCAR_UCM_fnc_setAltitudeToGround;
*/

if !(isServer) exitWith {};

params ["_obj", "_altitude"];

// get original position & set if first time
private _originalPos = _obj getVariable ["SCAR_UCM_originalPos", objNull];
if (_originalPos isEqualTo objNull) then {
    _originalPos = getPosWorld _obj;
    _obj setVariable ["SCAR_UCM_originalPos", _originalPos];
};

if ( abs(_altitude - (_originalPos select 2)) > 0.05) then { // round to avoid repeated setpos
    _obj setPosWorld [_originalPos select 0, _originalPos select 1, (_originalPos select 2) + _altitude];
};

// return
true
