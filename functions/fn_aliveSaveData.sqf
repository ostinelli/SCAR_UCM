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

// build hash
private _varKeys = [
    "SCAR_UCM_pieceCurrentId",
    "SCAR_UCM_pieceCurrentPercentage",
    "SCAR_UCM_workers",
    "SCAR_UCM_materials",
    "SCAR_UCM_workersAreWorking",
    "SCAR_UCM_workersInArea",
    "SCAR_UCM_materialsInArea"
];
private _pairs = [];
{
    private _value = _logicModule getVariable _x;
    _pairs pushBack [_x, _value];

} forEach _varKeys;
private _aliveHash = [_pairs, objNull] call CBA_fnc_hashCreate;

// save
private _storeSource = toLower( _aliveStore getVariable ["source", "CouchDB"] );
if (_storeSource == "pns") then {
    // LOCAL
    diag_log "UCM: saving data to ALiVE local.";
    [_aliveKey, _aliveHash] call ALiVE_fnc_ProfileNameSpaceSave;
} else {
    // CLOUD
    diag_log "UCM: saving data to ALiVE cloud.";
    [_aliveKey, _aliveHash] call ALiVE_fnc_setData;
};

// return
true
