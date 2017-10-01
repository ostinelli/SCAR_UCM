/*
    Author: _SCAR

    Description:
    Attach to the save button click event in ALiVE to save UCM data too.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_aliveSaveOnQuit;
*/

if !(hasInterface) exitWith {};

// check UCM persistence module is present
if ((count (entities "SCAR_UCM_ModuleUtilitiesConstructionPersistence")) == 0) exitWith {};

// set event to save on mission end
private _null = [] spawn {

    // init
    disableSerialization;
    private _displayType = if (isMultiplayer) then { "RscDisplayMPInterrupt" } else { "RscDisplayInterrupt" };

    while { true } do {

        waitUntil { !((uiNamespace getVariable _displayType) isEqualTo displayNull) };

        // get display
        private _displayPause = uiNamespace getVariable _displayType;

        // get control
        private _titleControl = _displayPause displayCtrl 599;
        private _saveControl  = _displayPause displayCtrl 195;

        // set text on title
        private _originalText = ctrlText _titleControl;
        _titleControl ctrlSetText format ["%1 (%2)", _originalText, localize ("STR_SCAR_UCM_Menu_WithUCM")];

        // add event on save
        _saveControl ctrlAddEventHandler ["buttonClick", {
            // save on server
            [] remoteExec ["SCAR_UCM_fnc_saveAll", 2];
        }];

        waitUntil { ((uiNamespace getVariable _displayType) isEqualTo displayNull) }; // wait until closed
    };
};

// return
true
