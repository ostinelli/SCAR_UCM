/*
    Author: _SCAR

    Description:
    Saves data to ALiVE (both local or cloud, depending on ALiVE Data module settings).

    Parameter(s):
	0: OBJECT - The logicModule.
	1: OBJECT - The ALiVE Store module.
	2: STRING - The unique ALiVE key.

    Return:
    true

    Example:
    [_logicModule, _aliveStore, _aliveKey] call SCAR_UCM_fnc_aliveSaveData;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_aliveStore", "_aliveKey"];

// init
private _pairs = [];

[_logicModule, "Preparing data to be saved to ALiVE."] call SCAR_UCM_fnc_log;

// simply store STRING, BOOL, NUMBER, ARRAY, CBA HASH values
{
    private _value = _logicModule getVariable _x;
    _pairs pushBack [_x, _value];
    // log
    [_logicModule, format["   ---> storing %1 as %2", _x, _value]] call SCAR_UCM_fnc_log;
} forEach [
    "SCAR_UCM_pieceCurrentId",
    "SCAR_UCM_pieceCurrentPercentage"
];

// store Workers info
private _workersInfo = [];
{
    // get loadout
    private _loadout = getUnitLoadout _x;
    // format info
    private _workerInfo = [getPos _x, getDir _x, _loadout];
    // add
    _workersInfo pushBack _workerInfo;
    // log
    [_logicModule, format["   ---> saved worker %1", _x]] call SCAR_UCM_fnc_log;
} forEach (_logicModule getVariable "SCAR_UCM_workers");
_pairs pushBack ["SCAR_UCM_workersInfo", _workersInfo];

// store Materials info
private _materialsInfo = [];
{
    // init
    private _material            = _x select 0;
    private _remainingPercentage = _x select 1;
    // format info
    private _materialInfo = [getPos _material, getDir _material, _remainingPercentage];
    // add
    _materialsInfo pushBack _materialInfo;
    // log
    [_logicModule, format["   ---> saved material %1", _material]] call SCAR_UCM_fnc_log;
} forEach (_logicModule getVariable "SCAR_UCM_materials");
_pairs pushBack ["SCAR_UCM_materialsInfo", _materialsInfo];

// build CBA hash
private _aliveHash = [_pairs, objNull] call CBA_fnc_hashCreate;

// save
private _storeSource = toLower( _aliveStore getVariable ["source", "CouchDB"] );
if (_storeSource == "pns") then {
    // LOCAL
    [_aliveKey, _aliveHash] call ALiVE_fnc_ProfileNameSpaceSave;
    [_logicModule, "Saved data to ALiVE local."] call SCAR_UCM_fnc_log;
} else {
    // CLOUD
    [_aliveKey, _aliveHash] call ALiVE_fnc_setData;
    [_logicModule, "Saved data to ALiVE cloud."] call SCAR_UCM_fnc_log;
};

// return
true
