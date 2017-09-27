/*
    Author: _SCAR

    Description:
    Returns if ACE is available on the system or not.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_isAceAvailable;
*/

// return
isClass(configFile >> "CfgPatches" >> "ace_main")
&& isClass(configFile >> "CfgPatches" >> "ace_interact_menu")
&& isClass(configFile >> "CfgPatches" >> "ace_cargo")
