/*
	Author: _SCAR

	Description:
	Initializes / loads /saves the settings.

	Paramster(s):
	0:  OBJECT - The logicModule.

	Return:
	true

	Example:
	[_logicModule] call SCAR_UCM_fnc_initSettings;
*/

if !(isServer) exitWith {};

// params
params ["_logicModule"];

[_logicModule, "Initializing settings."] call SCAR_UCM_fnc_log;

// ====================================================== \/ MODULE VARS ===================================================

// get vars
private _side                             = _logicModule getVariable ["Side", "BLUFOR"];
private _workersCount                     = _logicModule getVariable ["WorkersCount", 3];
private _pieceWorkingManSeconds           = _logicModule getVariable ["PieceWorkingManSeconds", 1800];
private _pieceNamePrefix                  = _logicModule getVariable ["PieceNamePrefix", "UCM_piece_"];
private _piecesFromMaterial               = _logicModule getVariable ["PiecesFromMaterial", 3];
private _workingDistance                  = _logicModule getVariable ["WorkingDistance", 100];
private _materialsAvailabilityIntervalMin = _logicModule getVariable ["MaterialsAvailabilityIntervalMin", 15];
private _pieceStartHeight                 = _logicModule getVariable ["PieceStartHeight", -0.6];
private _materialEndHeight                = _logicModule getVariable ["MaterialEndHeight", -1.4];
private _foremanVarname                   = _logicModule getVariable ["Foreman", "UCM_foreman"];
private _helicopterClass                  = _logicModule getVariable ["HelicopterClass", "B_Heli_Transport_03_unarmed_F"];
private _materialsClass                   = _logicModule getVariable ["MaterialsClass", "Land_IronPipes_F"];
private _materialsWeight                  = _logicModule getVariable ["MaterialsWeight", 16];
private _showAreaMarkers                  = _logicModule getVariable ["ShowAreaMarkers", true];
private _showWorkersMarkers               = _logicModule getVariable ["ShowWorkersMarkers", true];

// interpret & checks

// sync'ed
private _helicopterLandingZones = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionLandingZone"] call BIS_fnc_synchronizedObjects;
if ((count _helicopterLandingZones) == 0) then { throw format ["UCM: no Landing Zone module has been synchronized to module '%1'", _logicModule]; };
private _helicopterLandingZone = _helicopterLandingZones select 0;

private _helicopterOrigins = [_logicModule, "SCAR_UCM_ModuleUtilitiesConstructionHelicopterOrigin"] call BIS_fnc_synchronizedObjects;
if ((count _helicopterOrigins) == 0) then { throw format ["UCM: no Helicopter Origin module has been synchronized to module '%1'", _logicModule]; };
private _helicopterOrigin = _helicopterOrigins select 0;

// convert to side
_side = [_side] call SCAR_UCM_fnc_convertSideStrToSide;

// objects
private _foreman = missionNamespace getVariable _foremanVarname;
if (isNil "_foreman") then { throw format ["UCM: can't find the foreman object with specified name '%1' for logicModule %2", _foremanVarname, _logicModule]; };

// logicModule params in object
_logicModule setVariable ["SCAR_UCM_side", _side, true];
_logicModule setVariable ["SCAR_UCM_workersCount", _workersCount, true];
_logicModule setVariable ["SCAR_UCM_pieceWorkingManSeconds", _pieceWorkingManSeconds, true];
_logicModule setVariable ["SCAR_UCM_pieceNamePrefix", _pieceNamePrefix, true];
_logicModule setVariable ["SCAR_UCM_piecesFromMaterial", _piecesFromMaterial, true];
_logicModule setVariable ["SCAR_UCM_workingDistance", _workingDistance, true];
_logicModule setVariable ["SCAR_UCM_materialsAvailabilityIntervalSec", (_materialsAvailabilityIntervalMin * 60), true];
_logicModule setVariable ["SCAR_UCM_pieceStartHeight", _pieceStartHeight, true];
_logicModule setVariable ["SCAR_UCM_materialEndHeight", _materialEndHeight, true];
_logicModule setVariable ["SCAR_UCM_foreman", _foreman, true];
_logicModule setVariable ["SCAR_UCM_helicopterLandingZone", _helicopterLandingZone, true];
_logicModule setVariable ["SCAR_UCM_helicopterOrigin", _helicopterOrigin, true];
_logicModule setVariable ["SCAR_UCM_helicopterClass", _helicopterClass, true];
_logicModule setVariable ["SCAR_UCM_materialsClass", _materialsClass, true];
_logicModule setVariable ["SCAR_UCM_materialsWeight", _materialsWeight, true];
_logicModule setVariable ["SCAR_UCM_showAreaMarkers", _showAreaMarkers, true];
_logicModule setVariable ["SCAR_UCM_showWorkersMarkers", _showWorkersMarkers, true];

[_logicModule, "  --> OPTION variables have been set."] call SCAR_UCM_fnc_log;

// ====================================================== /\ MODULE VARS ===================================================

// ====================================================== \/ FIXED VARS ====================================================

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

// log
[_logicModule, "  --> FIXED variables have been set."] call SCAR_UCM_fnc_log;

// ====================================================== /\ OTHER VARS ====================================================

// ====================================================== \/ PROGRESS VARS =================================================

[_logicModule, "SCAR_UCM_pieceCurrentId", 0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_pieceCurrentPercentage", 0.0] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workers", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_materials", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workersAreWorking", false] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_workersInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_materialsInArea", []] call SCAR_UCM_fnc_setGlobalVariableIfUnset;
[_logicModule, "SCAR_UCM_customHash", ([] call CBA_fnc_hashCreate)] call SCAR_UCM_fnc_setGlobalVariableIfUnset;

[_logicModule, "  --> PROGRESS variables have been set."] call SCAR_UCM_fnc_log;

// ====================================================== /\ PROGRESS VARS =================================================

[_logicModule, "Settings initialization completed."] call SCAR_UCM_fnc_log;
