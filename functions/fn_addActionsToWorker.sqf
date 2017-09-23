/*
    Author: _SCAR

    Description:
    Adds the actions to the worker.

    Parameter(s);
    0: OBJECT - The logicModule.
    1: UNIT - the unit to attach the action to.

    Return:
    0: true

    Example:
    [_logicModule, _worker] call SCAR_UCM_fnc_addActionsToWorker;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_worker"];

// add action to GET IN
[_logicModule, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;

// actions
_action = [
    "SCAR_UCM_WorkerGoToConstructionArea",
    (localize "STR_SCAR_UCM_Main_GoToArea"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_logicModule"];

        // stop animation, if any
        [_logicModule, _target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

        // get piece
        private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

        // delete all existing waypoints
        private _group = group _target;
        while {(count (waypoints _group)) > 0} do
        {
            deleteWaypoint ((waypoints _group) select 0);
        };

        // remove handcuffs
        [_target, false] call ACE_captives_fnc_setHandcuffed;

        // set stance
        _target setUnitPos "AUTO";
        _target playAction "PlayerStand";

        // add waypoint
        private _wp = _group addWaypoint [_currentPiece, 10];
        _wp setWaypointType "MOVE";
    },
    // Condition <CODE>
    {
        params ["_target", "_player", "_logicModule"];

        // vars
        private _workingDistance = _logicModule getVariable "SCAR_UCM_workingDistance";

        // get piece
        private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

        // worker is outisde of working area
        (_target distance _currentPiece) > _workingDistance;
    },
    {},
    _logicModule
] call ace_interact_menu_fnc_createAction;
[_worker,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// status
[_logicModule, _worker] call SCAR_UCM_fnc_addActionRequestStatus;

// return
true
