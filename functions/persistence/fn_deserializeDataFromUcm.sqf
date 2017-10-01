/*
	Author: _SCAR

	Description:
	Deserializes UTM relevant data to logicModule and spawns the related objects on map.

	Parameter(s):
	0: OBJECT - The logicModule.
	1: OBJECT - The serialized CBA_HASH.

	Return:
	true

	Example:
	[_logicModule, _moduleHash] call SCAR_UCM_fnc_deserializeDataFromUcm;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_moduleHash"];

[_logicModule, "deserializing data to UTM and spawning objects."] call SCAR_UCM_fnc_log;

// retrieve simple values
[_logicModule, "  --> values"] call SCAR_UCM_fnc_log;
{
    private _value = [_moduleHash, _x] call CBA_fnc_hashGet;
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
private _workersInfo = [_moduleHash, "SCAR_UCM_workersInfo"] call CBA_fnc_hashGet;
if !(isNil "_workersInfo") then {
    {
        // init (format is [position, direction, loadout])
        private _pos       = _x select 0;
        private _dir       = _x select 1;
        private _loadout   = _x select 2;
        private _inVehicle = _x select 3;
        // spawn
        private _worker = ([_logicModule, 1, _pos] call SCAR_UCM_fnc_createWorkers) select 0;
        // set
        _worker setDir _dir;
        _worker setUnitLoadout _loadout;
        // in vehicle?
        if (_inVehicle) then {
            private _closeVehicles = nearestObjects [_pos, ["LandVehicle", "Air", "Ship"], 30];
            if ((count _closeVehicles) > 0) then {
                // assign as cargo & move in
                private _vehicle = _closeVehicles select 0;
                _worker assignAsCargo _vehicle;
                _worker moveInCargo _vehicle;
            };
        };
        // log
        [_logicModule, format["    --> %1 at position %2 with direction %3", _x, _pos, _dir]] call SCAR_UCM_fnc_log;

    } forEach _workersInfo;
};

// retrieve & spawn Materials
[_logicModule, "  --> materials"] call SCAR_UCM_fnc_log;
private _materialsInfo = [_moduleHash, "SCAR_UCM_materialsInfo"] call CBA_fnc_hashGet;
if !(isNil "_materialsInfo") then {
    {
        // init
        private _pos                 = _x select 0;
        private _dir                 = _x select 1;
        private _remainingPercentage = _x select 2;
        // spawn
        private _material = [_logicModule, _pos, _remainingPercentage] call SCAR_UCM_fnc_createMaterial;
        _material setDir _dir;
        // log
        [_logicModule, format["    --> %1 at position %2 with direction %3", _material, _pos, _dir]] call SCAR_UCM_fnc_log;
    } forEach _materialsInfo;
};

// return
true
