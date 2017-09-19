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

    diag_log format ["SCAR_UCG: Utilities Construction Mod got activated for store %1", _logic];

	// get vars
	private _side                   = _logic getVariable "Side";
	private _workersCount           = _logic getVariable "WorkersCount";
	private _pieceWorkingManSeconds = _logic getVariable "PieceWorkingManSeconds";
	private _pieceNamePrefix        = _logic getVariable "PieceNamePrefix";
	private _piecesFromMaterial     = _logic getVariable "PiecesFromMaterial";
	private _workingDistance        = _logic getVariable "WorkingDistance";
	private _pieceStartHeight       = _logic getVariable "PieceStartHeight";
	private _materialEndHeight      = _logic getVariable "MaterialEndHeight";
	private _foreman                = _logic getVariable "Foreman";
	private _helicopterLandingZone  = _logic getVariable "HelicopterLandingZone";
	private _helicopterOrigin       = _logic getVariable "HelicopterOrigin";
	private _helicopterClass        = _logic getVariable "HelicopterClass";
	private _materialsClass         = _logic getVariable "MaterialsClass";
	private _materialsWeight        = _logic getVariable "MaterialsWeight";

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
			_helicopterLandingZone,
			_helicopterOrigin,
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
