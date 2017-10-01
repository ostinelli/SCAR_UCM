/*
	Author: _SCAR

	Description:
	Serializes UTM relevant data from the logicModule.

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	CBA_HASH

	Example:
	[_logicModule] call SCAR_UCM_fnc_serializeUcmToData;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// init
private _pairs = [];

[_logicModule, "Serializing from UTM data."] call SCAR_UCM_fnc_log;

// add simple values
[_logicModule, "  --> Values"] call SCAR_UCM_fnc_log;
{
    // get info
    private _value = _logicModule getVariable _x;
    // add
    _pairs pushBack [_x, _value];
    // log
    [_logicModule, format["    --> %1 = %2", _x, _value]] call SCAR_UCM_fnc_log;

} forEach [
    "SCAR_UCM_pieceCurrentId",
    "SCAR_UCM_pieceCurrentPercentage"
];

// serialize Workers info
[_logicModule, "  --> Workers"] call SCAR_UCM_fnc_log;
private _workersInfo = [];
{
    // get info
    private _pos       = getPos _x;
    private _dir       = getDir _x;
    private _loadout   = getUnitLoadout _x;
    private _inVehicle = (vehicle _x != _x);
    // format info (format is [position, direction, loadout, inVehicle])
    private _workerInfo = [_pos, _dir, _loadout, _inVehicle];
    // add
    _workersInfo pushBack _workerInfo;
    // log
    [_logicModule, format["    --> %1 at position %2 with direction %3", _x, _pos, _dir]] call SCAR_UCM_fnc_log;

} forEach (_logicModule getVariable "SCAR_UCM_workers");
_pairs pushBack ["SCAR_UCM_workersInfo", _workersInfo];

// serialize Materials info
[_logicModule, "  --> Materials"] call SCAR_UCM_fnc_log;
private _materialsInfo = [];
{
    // init
    private _material            = _x select 0;
    private _remainingPercentage = _x select 1;
    private _pos                 = getPos _material;
    private _dir                 = getDir _material;
    // format info (format is [position, direction, remaining percentage])
    private _materialInfo = [_pos, _dir, _remainingPercentage];
    // add
    _materialsInfo pushBack _materialInfo;
    // log
    [_logicModule, format["    --> %1 at position %2 with direction %3", _material, _pos, _dir]] call SCAR_UCM_fnc_log;

} forEach (_logicModule getVariable "SCAR_UCM_materials");
_pairs pushBack ["SCAR_UCM_materialsInfo", _materialsInfo];

// build CBA hash
private _moduleHash = [_pairs] call CBA_fnc_hashCreate;

// return
_moduleHash
