/*
	Author: _SCAR

	Description:
	Initializes integrations.

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	true

	Example:
	[_logicModule] call SCAR_UCM_fnc_initIntegrations;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// init ALiVE integration
[_logicModule] call SCAR_UCM_fnc_initAlive;

// return
true
