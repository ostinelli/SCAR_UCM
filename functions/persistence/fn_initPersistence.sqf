/*
	Author: _SCAR

	Description:
	Initializes persistence support.

	Return:
	true

	Example:
	[] call SCAR_UCM_fnc_initPersistence;
*/

if !(isServer) exitWith {};

// check UCM persistence module is present
if !([] call SCAR_UCM_fnc_isPersistenceEnabled) exitWith {
    "Persistence module not found." call SCAR_UCM_fnc_log;
};

"Persistence module found, initializing." call SCAR_UCM_fnc_log;

// get settings
private _persistenceModule = (entities "SCAR_UCM_ModuleUtilitiesConstructionPersistence") select 0;

// add trigger to save on end mission
private _persistenceSaveOnEndMission = _persistenceModule getVariable ["PersistenceSaveOnEndMission", false];
if (_persistenceSaveOnEndMission) then {

    "UCM data will be saved automatically on mission end as per module settings." call SCAR_UCM_fnc_log;

    private _eventHandle = addMissionEventHandler ["Ended", {
        // log
        "Mission End trigger activated, saving all UCM data." call SCAR_UCM_fnc_log;
        // save all
        [] call SCAR_UCM_fnc_saveAll;
    }];
};

// add to gui to all clients
[] remoteExec ["SCAR_UCM_fnc_guiAddSaveMenu", 0, true];

// load
[] call SCAR_UCM_fnc_loadAll;

// return
true
