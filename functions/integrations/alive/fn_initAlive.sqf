/*
	Author: _SCAR

	Description:
	Initializes ALiVE integration.

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	true

	Example:
	[_logicModule] call SCAR_UCM_fnc_initAlive;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// exit if ALiVE is not present
if (count (entities "ALiVE_require") == 0) exitWith {
    [_logicModule, "ALiVE not found, no integrations activated."] call SCAR_UCM_fnc_log;
};

// check if OPCOMs are present
if (["ALiVE_mil_opcom"] call ALIVE_fnc_isModuleAvailable) then {
    // log
    [_logicModule, "ALiVE OPCOMs found, adding custom objectives support to target construction area."] call SCAR_UCM_fnc_log;
    // add objectives when construction area is moved
    [] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;
};

// add event to save on mission end
[] call SCAR_UCM_fnc_aliveOnMissionEnd;

// return
true
