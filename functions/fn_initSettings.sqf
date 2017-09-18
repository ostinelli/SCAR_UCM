/*
	Author: _SCAR

	Description:
	Initializes / loads /saves the settings.

	Paramster(s):
	0:  OBJECT - The module where to store the variables.
	1:  STRING - The side of the workers.
	2:  NUMBER - The total number of workers.
	3:  NUMBER - The total number of working man seconds to finish a piece piece.
	4:  STRING - The pieces' prefix.
	5:  NUMBER - The total number of pieces that can be built with a single material.
	6:  NUMBER - The distance of workers and materials from the current piece for the construction to be active.
	7:  NUMBER - The starting Z position of piece in the ground, end will be Z = 0.
	8:  NUMBER - The end position of material consumed, start is Z = 0;
	9:  STRING - The variable name of the workers' boss.
	10: STRING - The variable name of the helicopter landing zone object.
	11: STRING - The variable name of the object that defines the helicopters' origin.
	12: STRING - The helicopters' class.
	13: STRING - The materials' class.
	14: NUMBER - The materials' weight.
	15: STRING - The worker classes, separated by single spaces.

	Return:
	0: true

	Example:
	[
		_store
		"blufor",
		3,
		300,
		"scar_pipeline_",
		3,
		75,
		0.6,
		1.4,
		"SCAR_UCM_worker_boss",
		"SCAR_UCM_heli_landing_zone",
		"SCAR_UCM_helicopter_origin",
		"B_Heli_Transport_03_unarmed_F",
		"Land_IronPipes_F",
		15,
		"C_Man_ConstructionWorker_01_Black_F C_Man_ConstructionWorker_01_Blue_F C_Man_ConstructionWorker_01_Red_F C_Man_ConstructionWorker_01_Vrana_F"
	] call SCAR_UCM_fnc_loadSettings;
*/

if !(isServer) exitWith {};

// params
params [
	"_store",
	"_side",
	"_workersCount",
	"_pieceWorkingManSeconds",
	"_pieceNamePrefix",
	"_piecesFromMaterial",
	"_workingDistance",
	"_pieceStartNegativeHeight",
	"_materialEndNegativeHeight",
	"_workersBoss",
	"_helicopterLandingZone",
	"_helicopterOrigin",
	"_helicopterClass",
	"_materialsClass",
	"_materialsWeight"
];

diag_log format["SCAR_UCG: Initializing settings on store %1", _store];

// ====================================================== \/ MODULE VARS ===================================================

// interpret
private _sideKeys   = ["west", "blufor", "east", "opfor", "independent", "resistance", "civilian"];
private _sideValues = [west, west, east, east, independent, independent, civilian];
_side               = _sideValues select (_sideKeys find toLower(_side));

_workersBoss            = missionNamespace getVariable _workersBoss;
_helicopterLandingZone  = missionNamespace getVariable _helicopterLandingZone;
_helicopterOrigin       = missionNamespace getVariable _helicopterOrigin;

// store params in object
_store setVariable ["SCAR_UCM_side", _side, true];
_store setVariable ["SCAR_UCM_workersCount", _workersCount, true];
_store setVariable ["SCAR_UCM_pieceWorkingManSeconds", _pieceWorkingManSeconds, true];
_store setVariable ["SCAR_UCM_pieceNamePrefix", _pieceNamePrefix, true];
_store setVariable ["SCAR_UCM_piecesFromMaterial", _piecesFromMaterial, true];
_store setVariable ["SCAR_UCM_workingDistance", _workingDistance, true];
_store setVariable ["SCAR_UCM_pieceStartNegativeHeight", _pieceStartNegativeHeight, true];
_store setVariable ["SCAR_UCM_materialEndNegativeHeight", _materialEndNegativeHeight, true];
_store setVariable ["SCAR_UCM_workersBoss", _workersBoss, true];
_store setVariable ["SCAR_UCM_helicopterLandingZone", _helicopterLandingZone, true];
_store setVariable ["SCAR_UCM_helicopterOrigin", _helicopterOrigin, true];
_store setVariable ["SCAR_UCM_helicopterClass", _helicopterClass, true];
_store setVariable ["SCAR_UCM_materialsClass", _materialsClass, true];
_store setVariable ["SCAR_UCM_materialsWeight", _materialsWeight, true];

// TODO: input error handling

// ====================================================== /\ MODULE VARS ===================================================

// ====================================================== \/ OTHER VARS ====================================================

// init
_store setVariable ["SCAR_UCM_workerAnimations", [
	"REPAIR_VEH_KNEEL",
	"REPAIR_VEH_STAND",
	"REPAIR_VEH_PRONE",
	"KNEEL_TREAT"
], true];

_store setVariable ["SCAR_UCM_workerObjects", [
	"Land_WeldingTrolley_01_F",
	"WaterPump_01_sand_F",
	"Land_Workbench_01_F",
	"Land_DrillAku_F",
	"Land_Grinder_F",
	"Land_ButaneTorch_F"
], true];

private _workerClass = switch (_side) do {
    case west:        { "B_Soldier_F" };
    case east:        { "O_Soldier_F" };
    case independent: { "I_Soldier_F" };
    default { "I_Soldier_F" };
};

_store setVariable ["SCAR_UCM_workerClass", _workerClass, true];

_store setVariable ["SCAR_UCM_piecesCount", ([_store] call SCAR_UCM_fnc_getPiecesCount), true];

// landing zone
if ( (_store getVariable ["SCAR_UCM_heliPad", objNull]) isEqualTo objNull ) then {
    private _heliPad = "Land_HelipadEmpty_F" createVehicle (getPos _helicopterLandingZone);
    _store setVariable ["SCAR_UCM_heliPad", _heliPad, true];
};

// TODO: clients will wait for this before initializing
_store setVariable ["SCAR_UCM_initialized", false, true];

// ====================================================== /\ OTHER VARS ====================================================

// ====================================================== \/ PROGRESS VARS =================================================


[_store, "SCAR_UCM_pieceCurrentId", 0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_pieceCurrentPercentage", 0.0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_workers", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_materials", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_workersAreWorking", false] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_workersInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_materialsInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_store, "SCAR_UCM_markerObj", objNull] call SCAR_UCM_fnc_setGlobalVariableIfUnset;

// ====================================================== /\ PROGRESS VARS =================================================

