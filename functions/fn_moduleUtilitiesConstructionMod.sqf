/*
	Author: _SCAR

	Description:
	Module function callback.

	Return:
	0: true
*/

// get args
private _logicModule     = param [0, objNull, [objNull]];
private _units     = param [1,[],[[]]];
private _activated = param [2, true, [true]];

// activate
if (_activated) then {

    diag_log format ["UCM: Utilities Construction Mod activated for logicModule %1", _logicModule];

	// init
	if (isServer) then {

	    diag_log format ["UCM: Initializing server for module %1", _logicModule];

	       // init ALiVE
	    [_logicModule] call SCAR_UCM_fnc_aliveInit;
		// init settings
		[_logicModule] call SCAR_UCM_fnc_initSettings;
		// init server
		[_logicModule] call SCAR_UCM_fnc_initServer;
		// patch ACE
		[_logicModule] call SCAR_UCM_fnc_onUnloadedCargoPos;
	};

	if (hasInterface) then {

	    diag_log format ["UCM: Initializing player for module %1", _logicModule];

		// init player
		[_logicModule] call SCAR_UCM_fnc_initPlayer;
	};

	diag_log format ["UCM: Utilities Construction Mod initialization completed for logicModule %1", _logicModule];
};

// return
true
