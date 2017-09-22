/*
    Author: _SCAR

    Description:
    Gets the active piece of the construction.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: OBJECT or objNull

    Example:
    [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;
*/

params ["_logicModule"];

// vars
private _pieceNamePrefix = _logicModule getVariable "SCAR_UCM_pieceNamePrefix";
private _currentPieceId  = _logicModule getVariable "SCAR_UCM_pieceCurrentId";

// return
missionNamespace getVariable [format["%1%2", _pieceNamePrefix, _currentPieceId], objNull];
