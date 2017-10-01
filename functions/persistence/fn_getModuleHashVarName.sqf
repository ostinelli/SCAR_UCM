/*
	Author: _SCAR

	Description:
	Returns the logicModule hash variable name.

	Return:
	STRING

	Example:
	[_logicModule] call SCAR_UCM_fnc_getModuleHashVarName;
*/

// module hash name
format ["SCAR_UCM_module:%1", _logicModule];
