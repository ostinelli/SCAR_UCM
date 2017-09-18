/*
	Author: _SCAR

	Description:
	Gets the active piece of the construction.

	Parameter(s):
	0: OBJECT - The store.

	Return:
	0: OBJECT

	Example:
	[_store] call SCAR_UCM_fnc_getCurrentPiece;
*/

params ["_store"];

// vars
private _pieceNamePrefix = _store getVariable "SCAR_UCM_pieceNamePrefix";
private _pieceCurrentId  = _store getVariable "SCAR_UCM_pieceCurrentId";

// return
missionNamespace getVariable format["%1%2", _pieceNamePrefix, _pieceCurrentId];
