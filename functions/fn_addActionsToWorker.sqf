/*
	Author: _SCAR

	Description:
	Adds the actions to the worker.

	Parameter(s);
	0: OBJECT - The store.
	1: UNIT - the unit to attach the action to.

	Return:
	0: true

	Example:
	[_store, _worker] call SCAR_UCM_fnc_addActionsToWorker;
*/

if !(hasInterface) exitWith {};

params ["_store", "_worker"];

// add action to GET IN
[_store, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;

// actions
_action = [
	"SCAR_UCM_WorkerGoToConstructionArea",
	(localize "STR_SCAR_UCM_Main_GoToArea"),
	"",
	// Statement <CODE>
	{
		params ["_target", "_player", "_store"];

		// stop animation, if any
		[_store, _target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

		// get piece
		_currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;

		// delete all existing waypoints
		_group = group _target;
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
		_wp = _group addWaypoint [_currentPiece, 10];
		_wp setWaypointType "MOVE";
	},
	// Condition <CODE>
	{
		params ["_target", "_player", "_store"];

		// vars
		_workingDistance = _store getVariable "SCAR_UCM_workingDistance";

		// get piece
		_currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;

		// worker is outisde of working area
		(_target distance _currentPiece) > _workingDistance;
	},
	{},
	_store
] call ace_interact_menu_fnc_createAction;
[_worker,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// status
[_store, _worker] call SCAR_UCM_fnc_addActionRequestStatus;

// return
true
