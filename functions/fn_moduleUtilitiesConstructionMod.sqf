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

	// TEMP VALUES!!! TODO REMOVE
	/*
	private _store                      = SCAR_UCM_module;
	private _side                       = "blufor";
	private _workersCount               = 3;      // total number of workers.
	private _pieceWorkingManSeconds     = 300;    // total number of working man seconds to finish a piece piece.
	private _pieceNamePrefix            = "scar_pipeline_";    // the prefix.
	private _piecesFromMaterial         = 3;      // total number of piece pieces that can be built with a single material.
	private _workingDistance            = 75;     // distance for workers to work (also applies to materials).
	private _pieceStartHeight   = 0.6;    // starting Z position of piece in the ground, end will be Z = 0;
	private _materialEndHeight  = 1.4;    // end position of material consumed, start is Z = 0;
	private _workersBoss                = "SCAR_UCM_worker_boss"; // the variable name of the boss
	private _helicopterLandingZone      = "SCAR_UCM_helicopter_landing_zone"; // the variable name of the landing zone
	private _helicopterOrigin           = "SCAR_UCM_helicopter_origin"; // the variable name of the heli spawn
	private _helicopterClass            = "B_Heli_Transport_03_unarmed_F";//"RHS_Mi8amt_civilian";
	private _materialsClass             = "Land_IronPipes_F";
	private _materialsWeight            = 20;
	*/

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
