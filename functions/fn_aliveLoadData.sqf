/*
    Author: _SCAR

    Description:
    Reads data from ALiVE (both local or cloud, depending on ALiVE Data module settings) & sets it on the logic module.

    Parameter(s):
	0: OBJECT - The logicModule.
	1: OBJECT - The ALiVE Store module.
	2: STRING - The unique ALiVE key.

    Return:
    true

    Example:
    [_logicModule, _aliveStore, _aliveKey ] call SCAR_UCM_fnc_aliveRetrieveData;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_aliveStore", "_aliveKey"];

// get source type
private _storeSource = toLower( _aliveStore getVariable ["source", "pns"] );
[_logicModule, format ["ALiVE storage is of type %1.", _storeSource]] call SCAR_UCM_fnc_log;

// get data
private _aliveHash = objNull;
if (_storeSource == "pns") then {
    // LOCAL
    _aliveHash = _aliveKey call ALiVE_fnc_ProfileNameSpaceLoad;
    [_logicModule, "Loaded data from ALiVE local."] call SCAR_UCM_fnc_log;
} else {
    // CLOUD
    _aliveHash = [_aliveKey] call ALiVE_fnc_getData;
    [_logicModule, "Loaded data from ALiVE cloud."] call SCAR_UCM_fnc_log;
};

if ([_aliveHash] call CBA_fnc_isHash) then {
    // simply load STRING, BOOL, NUMBER, ARRAY, CBA HASH values
    {
        // get
        private _value = [_aliveHash, _x] call CBA_fnc_hashGet;
        // set on logicModule
        if !(isNil "_value") then {
            _logicModule setVariable [_x, _value, true];
            // log
            [_logicModule, format["   ---> set %1 to %2", _x, _value]] call SCAR_UCM_fnc_log;
        };
    } forEach [
        "SCAR_UCM_pieceCurrentId",
        "SCAR_UCM_pieceCurrentPercentage"
    ];

    // retrieve & spawn Workers
    private _workersInfo = [_aliveHash, "SCAR_UCM_workersInfo"] call CBA_fnc_hashGet;
    if !(isNil "_workersInfo") then {
        {
            // init
            private _position     = _x select 0;
            private _dir     = _x select 1;
            private _loadout = _x select 2;
            // spawn
            private _worker = ([_logicModule, 1, _position] call SCAR_UCM_fnc_createWorkers) select 0;
            // set dir
            _worker setDir _dir;
            // set loadout
            _worker setUnitLoadout _loadout;
            // log
            [_logicModule, format["   ---> loaded worker %1", _worker]] call SCAR_UCM_fnc_log;
        } forEach _workersInfo;
    };

    // retrieve & spawn Materials
    private _materialsInfo = [_aliveHash, "SCAR_UCM_materialsInfo"] call CBA_fnc_hashGet;
    if !(isNil "_materialsInfo") then {
        {
            // init
            private _position            = _x select 0;
            private _dir                 = _x select 1;
            private _remainingPercentage = _x select 2;
            // spawn
            private _material = [_logicModule, _position, _remainingPercentage] call SCAR_UCM_fnc_createMaterial;
            // set dir
            _material setDir _dir;
            // log
            [_logicModule, format["   ---> loaded material %1", _material]] call SCAR_UCM_fnc_log;
        } forEach _materialsInfo;
    };
} else {
    [_logicModule, "No persistent data ALiVE found."] call SCAR_UCM_fnc_log;
};

// return
true
