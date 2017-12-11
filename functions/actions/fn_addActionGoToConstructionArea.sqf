/*
    Author: _SCAR

    Description:
    Adds the action to a worker to got to the construction area.

    Parameter(s):
    0:: OBJECT - The worker.

    Return:
    true

    Example:
    [ _worker] call SCAR_UCM_fnc_addActionGoToConstructionArea;
*/

if !(hasInterface) exitWith {};

params ["_worker"];

// check side
if !((side group player) == (side _worker)) exitWith {};

// code
private _statement = {
    params ["_target"];
    private _logicModule = _target getVariable "SCAR_UCM_logicModule";

    // stop animation, if any
    [_target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

    // get piece
    private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

    // delete all existing waypoints
    private _group = group _target;
    [_group] call SCAR_UCM_fnc_deleteAllWaypoints;

    // remove handcuffs if ACE is enabled
    if (SCAR_UCM_ACE) then {
        [_target, false] call ACE_captives_fnc_setHandcuffed;
    };

    // set stance
    _target setUnitPos "AUTO";
    _target playAction "PlayerStand";

    // add waypoint
    private _wp = _group addWaypoint [getPos _currentPiece, 10];
    _wp setWaypointType "MOVE";
};

private _condition = {
    if (isNil "_target") then { private _target = _this select 0; }; // compatibility vanilla & ACE

    // vars
    private _logicModule     = _target getVariable "SCAR_UCM_logicModule";
    private _workingDistance = _logicModule getVariable "SCAR_UCM_workingDistance";

    // get piece
    private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;
    // worker is outisde of working area
    private _isOutside = ((_target distance _currentPiece) > _workingDistance);
    // can?
    private _canRespondToActions = [_target] call SCAR_UCM_fnc_canRespondToActions;

    // check
    _isOutside && _canRespondToActions
};

if (SCAR_UCM_ACE) then {
    // ACE

    _action = [
        "SCAR_UCM_WorkerGoToConstructionArea",
        (localize "STR_SCAR_UCM_Main_GoToArea"),
        "",
        _statement,
        _condition
    ] call ace_interact_menu_fnc_createAction;
    [_worker, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

} else {
    // VANILLA

    _worker addAction [
        (localize "STR_SCAR_UCM_Main_GoToArea"),
        _statement,
        nil,  // arguments
        1.5,  // priority
        true, // showWindow
        true, // hideOnUse
        "",   // shortcut
        (_condition call SCAR_UCM_fnc_convertCodeToStr),
        5     // radius
    ];
};

// return
true
