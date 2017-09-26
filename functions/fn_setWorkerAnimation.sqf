/*
    Author: _SCAR

    Description:
    Sets worker animations, sound and objects. Must be called on every machine, including server.

    Parameter(s):
    0: UNIT   - The worker.
    1: NUMBER - 1 to start, 0 to stop.
    2: STRING - the animation name.
    3: POS - the position.
    4: NUMBER - the desired rotation.

    Return:
    true

    Example:
    [_worker, 1, _animation, _pos, _rotation] call SCAR_UCM_fnc_setWorkerAnimation;
*/

params ["_worker", "_state", "_animation", "_pos", "_rotation"];

// vars
private _logicModule   = _worker getVariable "SCAR_UCM_logicModule";
private _workerObjects = _logicModule getVariable "SCAR_UCM_workerObjects";

if (_state == 1) then {

    if (isServer) then {
        // set to ground and correct rotation
        _worker setPos [_pos select 0, _pos select 1, 0];
        _worker setDir _rotation;

        // create tool next to worker, checking for collisions
        private _toolClass = selectRandom _workerObjects;
        private _tool      = _toolClass createVehicle _pos;
        _tool setVehiclePosition [ [getPos _worker select 0, getPos _worker select 1, 0], [], 2, "NONE"];

        // save var
        _worker setVariable ["SCAR_UCM_tool", _tool, true];
    };

    if (hasInterface) then {
        // start
        [_worker, _animation, "FULL"] call BIS_fnc_ambientAnim;

        // init sound
        private _soundSource = "Logic" createVehicleLocal getPos _worker;
        _soundSource attachTo [_worker, [0, 0, 0]];
        private _sound     = format["SCAR_UCM_working_%1", (floor(random 5) + 1)];
        private _soundInfo = getArray (configFile  >> "CfgSounds" >> _sound >> "sound");
        private _duration  = parseNumber( ((_soundInfo select 0) splitString "-.") select 1 );

        // create light
        private _light = "#lightpoint" createVehicleLocal getPos _worker;
        _light setLightBrightness 0.2;
        _light setLightAmbient [1.0, 1.0, 0.85];
        _light setLightColor [1.0, 1.0, 0.85];
        _light attachto [_worker, [0,1.5,0], "head"];

        // save vars
        _worker setVariable ["SCAR_UCM_soundSource", _soundSource];
        _worker setVariable ["SCAR_UCM_light", _light];

        // loop sound
        private _null = [_worker, _soundSource, _sound, _duration] spawn {

            params ["_worker", "_soundSource", "_sound", "_duration"];

            while { !((_worker getVariable ["SCAR_UCM_soundSource", objNull]) isEqualTo objNull) } do {
                _soundSource say3D _sound;
                sleep _duration;
            };
        };
    };
};

if (_state == 0) then {

    if (isServer) then {
        private _tool = _worker getVariable ["SCAR_UCM_tool", objNull];

        if !(_tool isEqualTo objNull) then {
            // delete tool
            deleteVehicle _tool;
            // reset var
            _worker setVariable ["SCAR_UCM_tool", objNull, true];
        };
    };

    if (hasInterface) then {
        private _soundSource = _worker getVariable ["SCAR_UCM_soundSource", objNull];
        private _light       = _worker getVariable ["SCAR_UCM_light", objNull];

        if !(_soundSource isEqualTo objNull) then {
            // end animation
            _worker call BIS_fnc_ambientAnim__terminate;
            // delete source & light
            detach _soundSource;
            deleteVehicle _soundSource;
            deleteVehicle _light;
            // reset var
            _worker setVariable ["SCAR_UCM_soundSource", objNull];
            _worker setVariable ["SCAR_UCM_light", objNull];
        };
    };
};

// return
true
