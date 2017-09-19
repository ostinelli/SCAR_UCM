/*
    Author: _SCAR

    Description:
    Sets worker animations, sound and objects. Must be called on every machine, including server.

    Parameter(s):
    0: OBJECT - The store.
    1: UNIT   - The worker.
    2: NUMBER - 1 to start, 0 to stop.
    3: STRING - the animation name.
    4: POS - the position.
    5: NUMBER - the desired rotation.

    Return:
    0: true

    Example:
    [_store, _worker, 1, _animation, _pos, _rotation] call SCAR_UCM_fnc_setWorkerAnimation;
*/

params ["_store", "_worker", "_state", "_animation", "_pos", "_rotation"];

// vars
private _workerObjects = _store getVariable "SCAR_UCM_workerObjects";

if (_state == 1) then {
    // set to ground and correct rotation
    _worker setPos [_pos select 0, _pos select 1, 0];
    _worker setDir _rotation;

    // start
    [_worker, _animation, "FULL"] call BIS_fnc_ambientAnim;

    // init sound
    private _soundSource = "Logic" createVehicleLocal getPos _worker;
    _soundSource attachTo [_worker, [0, 0, 0]];
    _sound     = format["SCAR_UCM_working_%1", (floor(random 8) + 1)];
    _soundInfo = getArray (configFile  >> "CfgSounds" >> _sound >> "sound");
    _duration  = parseNumber( ((_soundInfo select 0) splitString "-.") select 1 );

    // create light
    private _light = "#lightpoint" createVehicleLocal getPos _worker;
    _light setLightBrightness 0.2;
    _light setLightAmbient [1.0, 1.0, 0.85];
    _light setLightColor [1.0, 1.0, 0.85];
    _light attachto [_worker, [0,1.5,0], "head"];

    // save vars
    _worker setVariable ["SCAR_UCM_soundSource", _soundSource];
    _worker setVariable ["SCAR_UCM_light", _light];

    if (isServer) then {
        // create tool next to worker, checking for collisions
        private _toolClass = selectRandom _workerObjects;
        private _tool      = _toolClass createVehicle _pos;
        _tool setVehiclePosition [ [getPos _worker select 0, getPos _worker select 1, 0], [], 2, "NONE"];
        _worker setVariable ["SCAR_UCM_tool", _tool];
    };

    // loop sound
    private _null = [_worker, _soundSource, _sound, _duration] spawn {

        params ["_worker", "_soundSource", "_sound", "_duration"];

        while { !((_worker getVariable ["SCAR_UCM_soundSource", objNull]) isEqualTo objNull) } do {
            _soundSource say3D _sound;
            sleep _duration;
        };
    };
};

if (_state == 0) then {
    private _soundSource = _worker getVariable ["SCAR_UCM_soundSource", objNull];
    private _light       = _worker getVariable ["SCAR_UCM_light", objNull];

    if !(_soundSource isEqualTo objNull) then {
        // end animation
        _worker call BIS_fnc_ambientAnim__terminate;
        // delete source & tool
        detach _soundSource;
        deleteVehicle _soundSource;
        deleteVehicle _light;

        if (isServer) then {
            _tool = _worker getVariable ["SCAR_UCM_tool", objNull];
            deleteVehicle _tool;
            _worker setVariable ["SCAR_UCM_tool", objNull];
        };
        // reset var
        _worker setVariable ["SCAR_UCM_soundSource", objNull];
        _worker setVariable ["SCAR_UCM_light", objNull];
    };
};

// return
true
