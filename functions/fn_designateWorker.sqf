/*
    Author: Nels0

    Description:
    Designates AI unit as a worker

    Parameter(s):
    0: OBJECT - The DesignateWorkers module.
    1: OBJECT - UCM LogicModule.

    Return:
    0: ARRAY: the workers.

    Example:
    [_logicModule, _workersCount, _vehicle] call SCAR_UCM_fnc_createWorkers;
*/

if !(isServer) exitWith {};

params ["_designateModule""_logicModule"];

// vars
private _factionSide        = _logicModule getVariable "SCAR_UCM_side";
private _randUniform        = _designateModule getVariable "SCAR_UCM_randomiseUniform";
private _workers            = _designateModule getVariable "sync";
//private _workerClass = _logicModule getVariable "SCAR_UCM_workerClass";
//private _workers     = _logicModule getVariable "SCAR_UCM_workers";

// create workers
//private _newWorkers = [];
for "_w" in _workers do {
    // create group
    //private _newGroup = createGroup _side;
    //_newGroup setSpeedMode "LIMITED";
    //_newGroup setBehaviour "CARELESS";


    //Set faction Side (so any AI will become specified side)
    switch ( _factionSide) do { 
        case "BLUFOR" : {  _w joinSilent UCM_west}; 
        case "OPFOR" :  {  _w joinSilent UCM_east}; 
        case "INDEPENDENT" : {_w joinSilent UCM_ind};
        case "CIVILIAN" : { _w joinSilent UCM_civ};
        default {}; 
    };

    // style
    if (_randUniform) then {
        [_worker] call SCAR_UCM_fnc_setRandomWorkerLoadout;
    };

    // add to array
    _newWorkers pushBack _worker; //Unsure how to proceed on this

    // add logicModule to worker
    _worker setVariable ["SCAR_UCM_logicModule", _logicModule, true]; //Need

    // track worker to remove it from the workers array.
    _worker addEventHandler ["Killed", {
        private _killed       = _this select 0;
        private _logicModule  = _killed getVariable "SCAR_UCM_logicModule";
        // worker is dead, remove from array
        _logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") - [_killed] ), true];
        // fire event
        ["UCM_WorkerKilled", [_logicModule, _killed]] call CBA_fnc_serverEvent;
    }];

    // add kill event for everyone
    _worker setVariable ["SCAR_UCM_side", _factionSide, true];
    _worker addMPEventHandler ["MPKilled", {
        // radio
        private _killed = _this select 0;
        private _side   = _killed getVariable "SCAR_UCM_side";
        [_side, "HQ"] sideChat (localize "STR_SCAR_UCM_Radio_WorkerKilled");    //TODO: Make radio calls optional
    }];

    // add actions to server and every client
    [_worker] remoteExec ["SCAR_UCM_fnc_addActionsToWorker"];

    // init worker animations
    [_worker] call SCAR_UCM_fnc_loopWorkerMovements;
};

// logicModule
_logicModule setVariable ["SCAR_UCM_workers", ( (_logicModule getVariable "SCAR_UCM_workers") + _newWorkers ), true];

// return
_newWorkers
