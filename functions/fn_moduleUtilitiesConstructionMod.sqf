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

    [_logicModule, "Module activated."] call SCAR_UCM_fnc_log;

	// init
	if (isServer) then {

        [_logicModule, "Initializing server."] call SCAR_UCM_fnc_log;

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
		// init player
		[_logicModule] call SCAR_UCM_fnc_initPlayer;
	};

    [_logicModule, "initialization completed."] call SCAR_UCM_fnc_log;
};

// return
true
