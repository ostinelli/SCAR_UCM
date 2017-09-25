/*
	Author: _SCAR

	Description:
	Module function callback.

	Return:
	0: true
*/

// get args
private _logic     = param [0, objNull, [objNull]];
private _units     = param [1,[],[[]]];
private _activated = param [2, true, [true]];

// activate
if (_activated) then {

    diag_log "UCM: Utilities Construction Alive activated";

    systemChat "ALIVE ACTIVATED!";

    // Raise error if ALiVE is not available
    if !(isClass(configFile >> "CfgPatches" >> "Alive_main")) then {
        throw "You have included the UCM ALiVE mod, but ALiVE is not active";
    };

    // check if synchronized
    private _logics = [_logic, "SCAR_UCM_ModuleUtilitiesConstructionMod"] call BIS_fnc_synchronizedObjects;
    if ((count _logics) == 0) then {
        throw "You have included the UCM ALiVE mod, but you have not synchronized it with the UCM Logic module";
    };

    // listen to Construction area being moves
    [] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;
};

// return
true
