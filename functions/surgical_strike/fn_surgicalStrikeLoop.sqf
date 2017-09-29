/*
	Author: _SCAR

	Description:
	Handles all of the surgical strikes.

	Parameter(s):
	0: OBJECT - The strikeModule.

	Return:
	true

	Example:
	[_strikeModule] call SCAR_UCM_fnc_surgicalStrikeLoop;
*/

if !(isServer) exitWith {};

params ["_strikeModule"];

private _null = [_strikeModule] spawn {

    params ["_strikeModule"];

    // vars
    private _logicModule = _strikeModule getVariable "SCAR_UCM_Strike_logicModule";

    // loop
    while { true } do {

        // vars
        private _attackProbability = _strikeModule getVariable "SCAR_UCM_Strike_attackProbability";
        private _attackIsOngoing   = _strikeModule getVariable "SCAR_UCM_Strike_attackIsOngoing";
        private _attackIntervalMin = _strikeModule getVariable "SCAR_UCM_Strike_attackIntervalMin";
        private _workersInArea     = _logicModule getVariable "SCAR_UCM_workersInArea";

        if !(_attackIsOngoing) then {
            // should we attack (probability & workers are in area)
            if ( ((random 1) <= _attackProbability) && ((count _workersInArea) > 0) ) then {
                // attack
                [_strikeModule] spawn SCAR_UCM_fnc_surgicalStrikeAttack;
            };
        };

        sleep _attackIntervalMin;
    };
};

// return
true
