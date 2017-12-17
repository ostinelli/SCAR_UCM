/*
    Author: _SCAR

    Description:
    Initializes a worker's animations.

    Parameter(s):
    0: UNIT - The worker.

    Return:
    true

    Example:
    [_worker] call SCAR_UCM_fnc_loopWorkerMovements;
*/

if !(isServer) exitWith {};

params ["_worker"];

private _null = [_worker] spawn {

    params ["_worker"];

    // vars
    private _logicModule      = _worker getVariable "SCAR_UCM_logicModule";
    private _workingDistance  = _logicModule getVariable "SCAR_UCM_workingDistance";
    private _workerAnimations = _logicModule getVariable "SCAR_UCM_workerAnimations";

    [_logicModule, format ["Starting worker %1 movement loop", _worker]] call SCAR_UCM_fnc_log;

    // init
    private _lastPiece = objNull;

    // add kill event
    _worker addEventHandler ["Killed", {
        private _killed = _this select 0;
        // stop animation & sound
        [_killed, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
    }];

    // set movements
    while { alive _worker } do {

        // get current piece
        private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

        // has work ended?
        if (_currentPiece isEqualTo objNull) exitWith {
            // stop animation & sound
            [_worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
        };

        // check presence of worker (on the ground, not flying nearby, not in vehicle)
        if (
            ((_worker distance _currentPiece) < _workingDistance) &&     // in range
            (vehicle _worker == _worker)  &&                             // not in vehicle
            !(_worker getVariable ["SCAR_UCM_goingToVehicle", false]) && // not ordered to get in vehicle
            (_logicModule getVariable "SCAR_UCM_workersAreWorking")      // work is in progress
        ) then {
            // worker is in the area & work is happening

            if !(_currentPiece isEqualTo _lastPiece) then {

                // stop animation & sound
                [_worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

                // get current piece size
                private _box       = boundingBoxReal _currentPiece;
                private _p1        = _box select 0;
                private _p2        = _box select 1;
                private _maxWidth  = abs ((_p2 select 0) - (_p1 select 0));
                private _maxLength = abs ((_p2 select 1) - (_p1 select 1));

                // random position
                private _workersMinDistanceFromCenter = 1;
                private _sideX = selectRandom [1, -1];
                private _sideY = selectRandom [1, -1];

                private _relX = _sideX * (abs(random ((_maxWidth / 2) - _workersMinDistanceFromCenter)) + _workersMinDistanceFromCenter);
                private _relY = _sideY * (abs(random ((_maxLength / 2) - _workersMinDistanceFromCenter)) + _workersMinDistanceFromCenter);
                private _relativePos = [_relX, _relY, 0];

                // move worker close to piece

                // delete all existing waypoints
                private _group = group _worker;
                [_group] call SCAR_UCM_fnc_deleteAllWaypoints;

                // compute position
                private _pieceToWorldPos = _currentPiece modelToWorld _relativePos;

                // vars
                private _animation = selectRandom _workerAnimations;
                private _rotation  = ((getDir _currentPiece) - _sideX * 90);
                _worker setVariable ["SCAR_UCM_animation", _animation, true];
                _worker setVariable ["SCAR_UCM_pieceToWorldPos", _pieceToWorldPos, true];
                _worker setVariable ["SCAR_UCM_rotation", _rotation, true];

                // add waypoint
                private _wp = _group addWaypoint [_pieceToWorldPos, 0];
                _wp setWaypointType "MOVE";
                _wp setWaypointStatements ["true",
                    "private _animation = this getVariable 'SCAR_UCM_animation';" +
                    "private _pieceToWorldPos = this getVariable 'SCAR_UCM_pieceToWorldPos';" +
                    "private _rotation = this getVariable 'SCAR_UCM_rotation';" +
                    "[this, 1, _animation, _pieceToWorldPos, _rotation] call SCAR_UCM_fnc_setWorkerAnimation;"
                ];

                // flag
                _lastPiece = _currentPiece;
            };

        } else {
            // not working

            if !(_lastPiece isEqualTo objNull) then {
                // stop animation & sound
                [_worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
                // reset
                _lastPiece = objNull;
            };
        };

        sleep 5;
    };
};

// return
true
