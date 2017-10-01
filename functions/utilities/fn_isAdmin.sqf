/*
    Author: _SCAR

    Description:
    Checks if admin.

    Return:
    BOOLEAN

    Example:
    [] call SCAR_UCM_fnc_isAdmin;
*/

// return
serverCommandAvailable "#kick" || !isMultiplayer;
