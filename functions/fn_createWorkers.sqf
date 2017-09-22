/*
    Author: _SCAR

    Description:
    Create the specified number of workers in the specified vehicle.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: NUMBER - The count of workers to create.
    2: OBJECT - The vehicle in which the worker needs to be assigned as cargo to.

    Return:
    0: ARRAY: the workers.

    Example:
    [_logicModule, _workersCount, _vehicle] call SCAR_UCM_fnc_createWorkers;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_workersCount", "_vehicle"];

// vars
private _side        = _logicModule getVariable "SCAR_UCM_side";
private _workerClass = _logicModule getVariable "SCAR_UCM_workerClass";
private _workers     = _logicModule getVariable "SCAR_UCM_workers";

// create workers
private _newWorkers = [];
for "_i" from 1 to _workersCount do {
    // create group
    private _newGroup = createGroup _side;
    _newGroup setSpeedMode "LIMITED";
    _newGroup setBehaviour "CARELESS";

    // create worker
    private _worker = _newGroup createUnit [_workerClass, getPos _vehicle, [], 0, "NONE"];

    // style
    [_worker] call SCAR_UCM_fnc_setRandomWorkerLoadout;

    // asign as cargo & move in
    _worker assignAsCargo _vehicle;
    _worker moveInCargo _vehicle;

    // add to array
    _newWorkers pushBack _worker;

    // track worker to remove it from the workers array.
    // Note: we cannot use addEventHandler since it does not allow to pass custom params and we need to pass the _logicModule variable.
    private _null = [_logicModule, _worker] spawn {
        params ["_logicModule", "_worker"];
        while { alive _worker} do { sleep 1; };
        // worker is dead, remove from array
        _logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") - [_worker] ), true];
        // fire event
        ["UCM_WorkerKilled", [_logicModule, _worker]] call CBA_fnc_serverEvent;
    };

    // add kill event for everyone
    _worker setVariable ["_side", _side, true];
    _worker addMPEventHandler ["MPKilled", {
        // radio
        private _killed = _this select 0;
        private _side   = _killed getVariable "_side";
        [_side, "HQ"] sideChat (localize "STR_SCAR_UCM_Radio_WorkerKilled");
    }];

    // add action to order GETIN to everyone
    [_logicModule, _worker] remoteExec ["SCAR_UCM_fnc_addActionsToWorker"];

    // init worker animations
    [_logicModule, _worker] call SCAR_UCM_fnc_loopWorkerMovements;
};

// logicModule
_logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") + _newWorkers ), true];

// return
_newWorkers
