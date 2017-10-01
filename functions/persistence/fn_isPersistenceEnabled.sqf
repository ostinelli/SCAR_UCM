/*
	Author: _SCAR

	Description:
	Returns if persistence is enabled.

	Return:
	BOOLEAN

	Example:
	[] call SCAR_UCM_fnc_isPersistenceEnabled;
*/

(count (entities "SCAR_UCM_ModuleUtilitiesConstructionPersistence")) > 0
