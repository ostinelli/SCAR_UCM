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

    diag_log format ["UCM: Utilities Construction Mod activated for module %1", _logic];

	// get vars
	private _side                         = _logic getVariable ["Side", "blufor"];
	private _workersCount                 = _logic getVariable ["WorkersCount", 3];
	private _pieceWorkingManSeconds       = _logic getVariable ["PieceWorkingManSeconds", 1800];
	private _pieceNamePrefix              = _logic getVariable ["PieceNamePrefix", "UCM_piece_"];
	private _piecesFromMaterial           = _logic getVariable ["PiecesFromMaterial", 3];
	private _workingDistance              = _logic getVariable ["WorkingDistance", 75];
	private _pieceStartHeight             = _logic getVariable ["PieceStartHeight", -0.6];
	private _materialEndHeight            = _logic getVariable ["MaterialEndHeight", -1.4];
	private _foreman                      = _logic getVariable ["Foreman", "UCM_foreman"];
	private _helicopterClass              = _logic getVariable ["HelicopterClass", "B_Heli_Transport_03_unarmed_F"];
	private _materialsClass               = _logic getVariable ["MaterialsClass", "Land_IronPipes_F"];
	private _materialsWeight              = _logic getVariable ["MaterialsWeight", 16];

	// init
	if (isServer) then {
		// init settings
		[
			_logic,
			_side,
			_workersCount,
			_pieceWorkingManSeconds,
			_pieceNamePrefix,
			_piecesFromMaterial,
			_workingDistance,
			_pieceStartHeight,
			_materialEndHeight,
			_foreman,
			_helicopterClass,
			_materialsClass,
			_materialsWeight
		] call SCAR_UCM_fnc_initSettings;
		// init server
		[_logic] call SCAR_UCM_fnc_initServer;
		// patch ACE
		[_logic] call SCAR_UCM_fnc_onUnloadedCargoPos;
	};

	if (hasInterface) then {
		// init player
		[_logic] call SCAR_UCM_fnc_initPlayer;
	};
};

// return
true
