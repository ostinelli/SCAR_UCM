/*
	Author: _SCAR

	Description:
	Initializes persistence support.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_initPersistence;
*/

if !(isServer) exitWith {};

// add to gui to all clients
[] remoteExec ["SCAR_UCM_fnc_guiAddSaveMenu", 0, true];

// load
[] call SCAR_UCM_fnc_loadAll;

// return
true
