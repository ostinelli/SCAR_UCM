/*
	Author: _SCAR

	Description:
	Returns the unique profileNameSpace variable name for the current mission.

	Return:
	STRING

	Example:
	[] call SCAR_UCM_fnc_getProfileNamespaceMissionVarName;
*/

// unique profileNameSpace name for mission
format ["SCAR_UCM_persistenceHash_%1", missionName];
