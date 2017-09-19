/*
	Author: _SCAR

	Description:
	Module function callback.

	Return:
	0: true
*/

// get args
private _store     = param [0, objNull, [objNull]];
private _units     = param [1,[],[[]]];
private _activated = param [2, true, [true]];

// activate
if (_activated) then {

    diag_log format ["SCAR_UCG: Utilities Construction Mod got activated for store %1", _store];

	// get vars
	private _side                       = _store getVariable "Side";
	private _workersCount               = _store getVariable "WorkersCount";
	private _pieceWorkingManSeconds     = _store getVariable "PieceWorkingManSeconds";
	private _pieceNamePrefix            = _store getVariable "PieceNamePrefix";
	private _piecesFromMaterial         = _store getVariable "PiecesFromMaterial";
	private _workingDistance            = _store getVariable "WorkingDistance";
	private _pieceStartHeight   = _store getVariable "PieceStartNegativeHeight";
	private _materialEndHeight  = _store getVariable "MaterialEndNegativeHeight";
	private _workersBoss                = _store getVariable "WorkersBoss";
	private _helicopterLandingZone      = _store getVariable "HelicopterLandingZone";
	private _helicopterOrigin           = _store getVariable "HelicopterOrigin";
	private _helicopterClass            = _store getVariable "HelicopterClass";
	private _materialsClass             = _store getVariable "MaterialsClass";
	private _materialsWeight            = _store getVariable "MaterialsWeight";


	// init
	if (isServer) then {
		// init settings
		[
			_store,
			_side,
			_workersCount,
			_pieceWorkingManSeconds,
			_pieceNamePrefix,
			_piecesFromMaterial,
			_workingDistance,
			_pieceStartHeight,
			_materialEndHeight,
			_workersBoss,
			_helicopterLandingZone,
			_helicopterOrigin,
			_helicopterClass,
			_materialsClass,
			_materialsWeight
		] call SCAR_UCM_fnc_initSettings;
		// init server
		[_store] call SCAR_UCM_fnc_initServer;
		// patch ACE
		[_store] call SCAR_UCM_fnc_onUnloadedCargoPos;
	};

	if (hasInterface) then {
		// init player
		[_store] call SCAR_UCM_fnc_initPlayer;
	};
};

// return
true
