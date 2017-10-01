/*
    Author: _SCAR

    Description:
    Listen to the endMission event and save.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_aliveOnMissionEnd;
*/

if !(isServer) exitWith {};

// check UCM persistence module is present
if ((count (entities "SCAR_UCM_ModuleUtilitiesConstructionPersistence")) == 0) exitWith {};

// set event to save on mission end
private _eventHandle = addMissionEventHandler ["Ended", {
    // log
    "Mission End trigger activated, saving all UCM data." call SCAR_UCM_fnc_log;
    // save all
    [] call SCAR_UCM_fnc_saveAll;
}];

"Added Mission End EH to save data when ALiVE save is triggered." call SCAR_UCM_fnc_log;

// return
true
