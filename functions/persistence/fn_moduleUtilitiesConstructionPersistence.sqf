/*
	Author: _SCAR

	Description:
	Module function callback.

	Return:
	true
*/

// get args
private _activated = param [2, true, [true]];

// activate
if (_activated) then {

	// init
	if (isServer) then {

        "Initializing Persistence Module." call SCAR_UCM_fnc_log;

		// init persistence
        [] call SCAR_UCM_fnc_initPersistence;

	};
};

// return
true
