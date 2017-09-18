/*
	Author: _SCAR

	Description:
	Initializes the boss.

	Parameter(s):
	0: OBJECT - The store.

	Return:
	0: true

	Example:
	[_store] call SCAR_UCM_fnc_initBoss;
*/

if !(isServer) exitWith {};

params ["_store"];

// vars
private _workersBoss = _store getVariable "SCAR_UCM_workersBoss";

// init boss
_workersBoss allowDamage false;
if (_workersBoss isKindOf "Man") then {
	_workersBoss disableAI "MOVE";
	(group _workersBoss) setBehaviour "CARELESS";
};

// return
true
