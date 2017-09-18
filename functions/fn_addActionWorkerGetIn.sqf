/*
	Author: _SCAR

	Description:
	Adds the action to a worker to get in vehicles.

	Parameter(s):
	0: OBJECT - The store.
	1: OBJECT - The worker.

	Return:
	0: true

	Example:
	[_store, _worker] call SCAR_UCM_fnc_addActionWorkerGetIn;
*/

if !(hasInterface) exitWith {};

params ["_store", "_worker"];

// add action
_actionInfo = [
	"SCAR_UCM_WorkerGetInVehicle",
	(localize "STR_SCAR_UCM_Main_GoToVehicle"),
	"",
	// Statement <CODE>
	{},
	// Condition <CODE>
	{ true },
	// Children code <CODE> (Optional)
	{
		params ["_target", "_player", "_store"];

		// find cars
		_vehicles = nearestObjects [_target, ["Car", "Helicopter"], 100];

		private _actions = [];
		{
			// display name
			_displayName = getText (configFile >>  "CfgVehicles" >> (typeOf _x) >> "displayName");
			_displayName = _displayName + format[" (a %1m)", round(_x distance _target)];

			// define action to order GETIN
			private _action = [
				format ["SCAR_UCM_WorkerGetInVehicle:%1", _x],
				_displayName,
				"",
				{
					// order to GETIN

					// stop animation, if any
					[_store, _target, 0] call SCAR_UCM_fnc_setWorkerAnimation;

					// set stance
					_target setUnitPos "AUTO";
					_target playAction "PlayerStand";

					// remove handcuffs, if any
					[_target, false] call ACE_captives_fnc_setHandcuffed;

					// init
					_vehicle = (_this select 2);
					// move worker in vehicle
					unassignVehicle _target;
					[_target] allowGetIn true;
					_target assignAsCargo _vehicle;
					[_target] orderGetIn true;

					// add action to GETOUT to all clients
					[_store, _target, _vehicle] remoteExec ["SCAR_UCM_fnc_addActionWorkerGetOut"];
				},
				{ true },
				{},
				_x
			] call ace_interact_menu_fnc_createAction;

			// add to actions
			_actions pushBack [_action, [], _target];
		} forEach _vehicles;

		// return
		_actions
	},
	_store
];
 _action = _actionInfo call ace_interact_menu_fnc_createAction;
[_worker, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// return
true
