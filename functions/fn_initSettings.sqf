/*
	Author: _SCAR

	Description:
	Initializes / loads /saves the settings.

	Paramster(s):
	0:  OBJECT - The module where to logicModule the variables.
	1:  STRING - The side of the workers.
	2:  NUMBER - The total number of workers.
	3:  NUMBER - The total number of working man seconds to finish a piece piece.
	4:  STRING - The pieces' prefix.
	5:  NUMBER - The total number of pieces that can be built with a single material.
	6:  NUMBER - The distance of workers and materials from the current piece for the construction to be active.
	7:  NUMBER - The starting Z position of piece in the ground, end will be Z = 0.
	8:  NUMBER - The end position of material consumed, start is Z = 0;
	9: STRING - The variable name of the foreman.
	10: STRING - The helicopters' class.
	11: STRING - The materials' class.
	12: NUMBER - The materials' weight.

	Return:
	0: true

	Example:
	[
		_logicModule
		"BLUFOR",
		3,
		300,
		"scar_pipeline_",
		3,
		75,
		-0.6,
		-1.4,
		"SCAR_UCM_foreman",
		"B_Heli_Transport_03_unarmed_F",
		"Land_IronPipes_F",
		16
	] call SCAR_UCM_fnc_loadSettings;
*/

if !(isServer) exitWith {};

// params
params [
	"_logicModule",
	"_side",
	"_workersCount",
	"_pieceWorkingManSeconds",
	"_pieceNamePrefix",
	"_piecesFromMaterial",
	"_workingDistance",
	"_pieceStartHeight",
	"_materialEndHeight",
	"_foremanVarname",
	"_helicopterClass",
	"_materialsClass",
	"_materialsWeight"
];

// ====================================================== \/ MODULE VARS ===================================================

// interpret & checks

// sync'ed
private _helicopterLandingZones = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionLandingZone"] call BIS_fnc_synchronizedObjects;
if ((count _helicopterLandingZones) == 0) then { throw format ["UCM: no Landing Zone module has been synchronized to module '%1'", _logicModule]; };
_helicopterLandingZone = _helicopterLandingZones select 0;

private _helicopterOrigins = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionHelicopterOrigin"] call BIS_fnc_synchronizedObjects;
if ((count _helicopterOrigins) == 0) then { throw format ["UCM: no Helicopter Origin module has been synchronized to module '%1'", _logicModule]; };
_helicopterOrigin = _helicopterOrigins select 0;

// side
private _sideKeys   = ["BLUFOR", "OPFOR", "INDEPENDENT", "CIVILIAN"];
private _sideValues = [blufor, opfor, independent, civilian];
_side = _sideValues select (_sideKeys find _side);

// objects
_foreman = missionNamespace getVariable _foremanVarname;
if (isNil "_foreman") then { throw format ["UCM: can't find the foreman object with specified name '%1' for logicModule %2", _foremanVarname, _logicModule]; };

// logicModule params in object
_logicModule setVariable ["SCAR_UCM_side", _side, true];
_logicModule setVariable ["SCAR_UCM_workersCount", _workersCount, true];
_logicModule setVariable ["SCAR_UCM_pieceWorkingManSeconds", _pieceWorkingManSeconds, true];
_logicModule setVariable ["SCAR_UCM_pieceNamePrefix", _pieceNamePrefix, true];
_logicModule setVariable ["SCAR_UCM_piecesFromMaterial", _piecesFromMaterial, true];
_logicModule setVariable ["SCAR_UCM_workingDistance", _workingDistance, true];
_logicModule setVariable ["SCAR_UCM_pieceStartHeight", _pieceStartHeight, true];
_logicModule setVariable ["SCAR_UCM_materialEndHeight", _materialEndHeight, true];
_logicModule setVariable ["SCAR_UCM_foreman", _foreman, true];
_logicModule setVariable ["SCAR_UCM_helicopterLandingZone", _helicopterLandingZone, true];
_logicModule setVariable ["SCAR_UCM_helicopterOrigin", _helicopterOrigin, true];
_logicModule setVariable ["SCAR_UCM_helicopterClass", _helicopterClass, true];
_logicModule setVariable ["SCAR_UCM_materialsClass", _materialsClass, true];
_logicModule setVariable ["SCAR_UCM_materialsWeight", _materialsWeight, true];

// ====================================================== /\ MODULE VARS ===================================================

// ====================================================== \/ OTHER VARS ====================================================

// init
_logicModule setVariable ["SCAR_UCM_workerAnimations", [
	"REPAIR_VEH_KNEEL",
	"REPAIR_VEH_STAND",
	"REPAIR_VEH_PRONE",
	"KNEEL_TREAT"
], true];

_logicModule setVariable ["SCAR_UCM_workerObjects", [
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

_logicModule setVariable ["SCAR_UCM_workerClass", _workerClass, true];

_logicModule setVariable ["SCAR_UCM_piecesCount", ([_logicModule] call SCAR_UCM_fnc_getPiecesCount), true];

// landing zone
if ( (_logicModule getVariable ["SCAR_UCM_heliPad", objNull]) isEqualTo objNull ) then {
    private _heliPad = "Land_HelipadEmpty_F" createVehicle (getPos _helicopterLandingZone);
    _logicModule setVariable ["SCAR_UCM_heliPad", _heliPad, true];
};

// clients can wait for this before initializing
_logicModule setVariable ["SCAR_UCM_initialized", false, true];

// ====================================================== /\ OTHER VARS ====================================================

// ====================================================== \/ PROGRESS VARS =================================================

[_logicModule, "SCAR_UCM_pieceCurrentId", 0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_pieceCurrentPercentage", 0.0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workers", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_materials", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workersAreWorking", false] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workersInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_materialsInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;

// ====================================================== /\ PROGRESS VARS =================================================

diag_log format["UCM: Settings initialized for module %1", _logicModule];
