/*
    Author: _SCAR

    Description:
    Adds the action to a unit to got to the construction area.

    Parameter(s):
    0:: OBJECT - The worker.

    Return:
    true

    Example:
    [ _unit] call SCAR_UCM_fnc_addActionGoToConstructionArea;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

_action = [
    "SCAR_UCM_WorkerGoToConstructionArea",
    (localize "STR_SCAR_UCM_Main_GoToArea"),
    "",
    // Statement <CODE>
    {
        params ["_target"];
        private _logicModule = _target getVariable "SCAR_UCM_logicModule";

        // stop animation, if any
        [_target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

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
        private _wp = _group addWaypoint [getPos _currentPiece, 10];
        _wp setWaypointType "MOVE";
    },
    // Condition <CODE>
    {
        params ["_target"];

        // vars
        private _logicModule = _target getVariable "SCAR_UCM_logicModule";

        // vars
        private _workingDistance = _logicModule getVariable "SCAR_UCM_workingDistance";

        // get piece
        private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

        // worker is outisde of working area
        private _isOutside = ((_target distance _currentPiece) > _workingDistance);

        // can?
        private _canRespondToActions = [_target] call SCAR_UCM_fnc_canRespondToActions;

        // sum
        _isOutside && _canRespondToActions
    }
] call ace_interact_menu_fnc_createAction;
[_worker, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// return
true
