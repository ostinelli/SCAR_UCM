/*
    Author: _SCAR

    Description:
    Initializes a worker's animations.

    Parameter(s):
    0: OBJECT - The store.
    1: UNIT - The worker.

    Return:
    0: true

    Example:
    [_store, _worker] call SCAR_UCM_fnc_loopWorkerMovements;
*/

if !(isServer) exitWith {};

params ["_store", "_worker"];

private _null = [_store, _worker] spawn {

    params ["_store", "_worker"];

    // vars
    private _workingDistance  = _store getVariable "SCAR_UCM_workingDistance";
    private _workerAnimations = _store getVariable "SCAR_UCM_workerAnimations";

    // init
    private _lastPiece = objNull;

    // add kill event
    _worker setVariable ["_store", _store, true];
    _worker addEventHandler ["Killed", {
        private _killed = _this select 0;
        private _store  = _killed getVariable "_store";
        // stop animation & sound
        [_store, _killed, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];
    }];

    // set movements
    while { alive _worker } do {

        // get current piece
        private _currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;

        // set marker worker
        [_worker] call SCAR_UCM_fnc_setMarkerWorker;

        // check presence of worker (on the ground, not flying nearby, not in vehicle)
        if (
            ((_worker distance _currentPiece) < _workingDistance) &&
            (vehicle _worker == _worker)  &&
            (_store getVariable "SCAR_UCM_workersAreWorking")
        ) then {
            // worker is in the area & work is happening

            if !(_currentPiece isEqualTo _lastPiece) then {

                // stop animation & sound
                [_store, _worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

                // get current piece size
                private _box = boundingBoxReal _currentPiece;
                private _p1 = _box select 0;
                private _p2 = _box select 1;
                private _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
                private _maxLength = abs ((_p2 select 1) - (_p1 select 1));

                // random position
                private _side = selectRandom [1, -1];
                private _relX = _side * (_maxWidth + 1); // ensure at least some space
                private _relY = (random _maxLength) - _maxLength / 2 + 1; // ensure at least some space
                private _relativePos = [_relX, _relY, 0];

                // move worker close to piece

                // delete all existing waypoints
                private _group = group _worker;
                while {(count (waypoints _group)) > 0} do
                {
                    deleteWaypoint ((waypoints _group) select 0);
                };

                // set vars
                private _animation       = selectRandom _workerAnimations;
                private _pieceToWorldPos = _currentPiece modelToWorld _relativePos;
                private _rotation        = ((getDir _currentPiece) - _side * 90);
                _store setVariable ["_store", _store, true];
                _worker setVariable ["_animation", _animation, true];
                _worker setVariable ["_pieceToWorldPos", _pieceToWorldPos, true];
                _worker setVariable ["_rotation", _rotation, true];

                // add waypoint
                private _wp = _group addWaypoint [_pieceToWorldPos, 0];
                _wp setWaypointType "MOVE";
                _wp setWaypointStatements ["true",
                    "private _store = this getVariable '_store';" +
                    "private _animation = this getVariable '_animation';" +
                    "private _pieceToWorldPos = this getVariable '_pieceToWorldPos';" +
                    "private _rotation = this getVariable '_rotation';" +
                    "[_store, this, 1, _animation, _pieceToWorldPos, _rotation] remoteExec ['SCAR_UCM_fnc_setWorkerAnimation'];"
                ];

                // flag
                _lastPiece = _currentPiece;
            };
        } else {
            // not working

            // stop animation & sound
            [_store, _worker, 0] remoteExec ["SCAR_UCM_fnc_setWorkerAnimation"];

            // reset
            _lastPiece = objNull;
        };

        sleep 10;
    };
};

// return
true
