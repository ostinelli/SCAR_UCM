/*
    Author: _SCAR

    Description:
    Creates the specified number of workers at the specified position or in the specified vehicle.

    Parameter(s):
    0: OBJECT   - The logicModule.
    1: NUMBER   - The count of workers to create.
    2: POSITION or OBJECT - Where to spawn the workers, or the vehicle in which the workers needs to be assigned as cargo to.

    Return:
    0: ARRAY: the workers.

    Example:
    [_logicModule, _workersCount, _position_or_vehicle] call SCAR_UCM_fnc_createWorkers;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_workersCount", "_position_or_vehicle"];

// vars
private _side        = _logicModule getVariable "SCAR_UCM_side";
private _workerClass = _logicModule getVariable "SCAR_UCM_workerClass";
private _workers     = _logicModule getVariable "SCAR_UCM_workers";

// vehicle or pos?
private _position = objNull;
private _vehicle  = objNull;

if ((typeName _position_or_vehicle) == "ARRAY") then {
    // position specified
    _position = _position_or_vehicle;
};
if ((typeName _position_or_vehicle) == "OBJECT") then {
    // vehicle specified
    _vehicle  = _position_or_vehicle;
    _position = (getPos _vehicle) getPos [30, random(360)];
};

[_logicModule, format ["Creating %1 worker(s) at %2", _workersCount, _position]] call SCAR_UCM_fnc_log;

// create workers
private _newWorkers = [];
for "_i" from 1 to _workersCount do {
    // create group
    private _newGroup = createGroup _side;
    _newGroup setSpeedMode "LIMITED";
    _newGroup setBehaviour "CARELESS";

    // create worker
    private _worker = _newGroup createUnit [_workerClass, _position, [], 0, "NONE"];

    // style
    [_worker] call SCAR_UCM_fnc_setRandomWorkerLoadout;

    // in vehicle?
    if !(_vehicle isEqualTo objNull) then {
        // assign as cargo & move in
        _worker assignAsCargo _vehicle;
        _worker moveInCargo _vehicle;
    };

    // add to array
    _newWorkers pushBack _worker;

    // add logicModule to worker
    _worker setVariable ["SCAR_UCM_logicModule", _logicModule, true];

    // add qualifier variable to worker
    _worker setVariable ["SCAR_UCM_isWorker", true, true];

    // track worker to remove it from the workers array.
    _worker setVariable ["SCAR_UCM_side", _side, true];
    _worker addEventHandler ["Killed", {
        private _killed       = _this select 0;
        private _logicModule  = _killed getVariable "SCAR_UCM_logicModule";
        // worker is dead, remove from array
        _logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") - [_killed] ), true];
        // message
        private _side = _killed getVariable "SCAR_UCM_side";
        [_side, "STR_SCAR_UCM_Radio_WorkerKilled"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];
        // fire event
        ["UCM_WorkerKilled", [_logicModule, _killed]] call CBA_fnc_serverEvent;
    }];

    // add actions
    [_worker] call SCAR_UCM_fnc_addActionsToWorker;

    // init worker animations
    [_worker] call SCAR_UCM_fnc_loopWorkerMovements;
};

// logicModule
_logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") + _newWorkers ), true];

// return
_newWorkers
