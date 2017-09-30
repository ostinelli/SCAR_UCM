/*
	Author: _SCAR

	Description:
	Deerializes UTM relevant data to logicModule and spawns the related objects on map.

	Parameter(s):
	0: OBJECT - The logicModule.
	1: OBJECT - The serialized CBA_HASH.

	Return:
	true

	Example:
	[_logicModule, _persistentHash] call SCAR_UCM_fnc_serializeUcmToData;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_persistentHash"];

[_logicModule, "deserializing data to UTM and spawning objects."] call SCAR_UCM_fnc_log;

// retrieve simple values
[_logicModule, "  --> values"] call SCAR_UCM_fnc_log;
{
    private _value = [_persistentHash, _x] call CBA_fnc_hashGet;
    if !(isNil "_value") then {
        // set
        _logicModule setVariable [_x, _value, true];
        // log
        [_logicModule, format["    --> %1 = %2", _x, _value]] call SCAR_UCM_fnc_log;
    };
} forEach [
    "SCAR_UCM_pieceCurrentId",
    "SCAR_UCM_pieceCurrentPercentage"
];

// retrieve & spawn Workers
[_logicModule, "  --> workers"] call SCAR_UCM_fnc_log;
private _workersInfo = [_persistentHash, "SCAR_UCM_workersInfo"] call CBA_fnc_hashGet;
if !(isNil "_workersInfo") then {
    {
        // init (format is [position, direction, loadout])
        private _pos     = _x select 0;
        private _dir     = _x select 1;
        private _loadout = _x select 2;
        // spawn
        private _worker = ([_logicModule, 1, _pos] call SCAR_UCM_fnc_createWorkers) select 0;
        // set
        _worker setDir _dir;
        _worker setUnitLoadout _loadout;
        // log
        [_logicModule, format["    --> %1 at position %2 with direction %3", _x, _pos, _dir]] call SCAR_UCM_fnc_log;

    } forEach _workersInfo;
};

// retrieve & spawn Materials
[_logicModule, "  --> materials"] call SCAR_UCM_fnc_log;
private _materialsInfo = [_persistentHash, "SCAR_UCM_materialsInfo"] call CBA_fnc_hashGet;
if !(isNil "_materialsInfo") then {
    {
        // init
        private _position            = _x select 0;
        private _dir                 = _x select 1;
        private _remainingPercentage = _x select 2;
        // spawn
        private _material = [_logicModule, _position, _remainingPercentage] call SCAR_UCM_fnc_createMaterial;
        _material setDir _dir;
        // log
        [_logicModule, format["    --> %1 at position %2 with direction %3", _material, _pos, _dir]] call SCAR_UCM_fnc_log;
    } forEach _materialsInfo;
};

// return
true
