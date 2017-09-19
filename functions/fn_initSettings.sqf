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
	7:  NUMBER - The minimum distance of every worker from the piece's center when working.
	8:  NUMBER - The starting Z position of piece in the ground, end will be Z = 0.
	9:  NUMBER - The end position of material consumed, start is Z = 0;
	10: STRING - The variable name of the foreman.
	11: STRING - The variable name of the helicopter landing zone object.
	12: STRING - The variable name of the object that defines the helicopters' origin.
	13: STRING - The helicopters' class.
	14: STRING - The materials' class.
	15: NUMBER - The materials' weight.
	16: STRING - The worker classes, separated by single spaces.

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
		"1 10",
		0.6,
		1.4,
		"SCAR_UCM_foreman",
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
	"_workersMinDistanceFromCenter",
	"_pieceStartHeight",
	"_materialEndHeight",
	"_foremanVarname",
	"_helicopterLandingZoneVarname",
	"_helicopterOriginVarname",
	"_helicopterClass",
	"_materialsClass",
	"_materialsWeight"
];

diag_log format["UCG: Initializing settings on store %1", _store];

// ====================================================== \/ MODULE VARS ===================================================

// interpret & checks

// side
private _sideKeys   = ["west", "blufor", "east", "opfor", "independent", "resistance", "civilian"];
private _sideValues = [west, west, east, east, independent, independent, civilian];

_side = toLower(_side);
if !(_side in _sideKeys) then { throw format ["UCG: specified side '%1' is invalid", _side]; };
_side = _sideValues select (_sideKeys find toLower(_side));

// objects
_foreman = missionNamespace getVariable _foremanVarname;
if (isNil "_foreman") then { throw format ["UCG: can't find the foreman object with specified name '%1'", _foremanVarname]; };

_helicopterLandingZone = missionNamespace getVariable _helicopterLandingZoneVarname;
if (isNil "_helicopterLandingZone") then {
    throw format ["UCG: can't find the helicopter Landing Zone object with specified name '%1'", _helicopterLandingZoneVarname];
};

_helicopterOrigin = missionNamespace getVariable _helicopterOriginVarname;
if (isNil "_helicopterOrigin") then { throw format ["UCG: can't find the helicopter area origin object with specified name '%1'", _helicopterOriginVarname]; };

// store params in object
_store setVariable ["SCAR_UCM_side", _side, true];
_store setVariable ["SCAR_UCM_workersCount", _workersCount, true];
_store setVariable ["SCAR_UCM_pieceWorkingManSeconds", _pieceWorkingManSeconds, true];
_store setVariable ["SCAR_UCM_pieceNamePrefix", _pieceNamePrefix, true];
_store setVariable ["SCAR_UCM_piecesFromMaterial", _piecesFromMaterial, true];
_store setVariable ["SCAR_UCM_workingDistance", _workingDistance, true];
_store setVariable ["SCAR_UCM_workersMinDistanceFromCenter", _workersMinDistanceFromCenter, true];
_store setVariable ["SCAR_UCM_pieceStartHeight", _pieceStartHeight, true];
_store setVariable ["SCAR_UCM_materialEndHeight", _materialEndHeight, true];
_store setVariable ["SCAR_UCM_foreman", _foreman, true];
_store setVariable ["SCAR_UCM_helicopterLandingZone", _helicopterLandingZone, true];
_store setVariable ["SCAR_UCM_helicopterOrigin", _helicopterOrigin, true];
_store setVariable ["SCAR_UCM_helicopterClass", _helicopterClass, true];
_store setVariable ["SCAR_UCM_materialsClass", _materialsClass, true];
_store setVariable ["SCAR_UCM_materialsWeight", _materialsWeight, true];

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
    default           { "C_man_1" };
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

