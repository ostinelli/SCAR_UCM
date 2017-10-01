/*
    Author: _SCAR

    Description:
    Adds custom save with UCM to menu.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_guiAddSaveMenu;
*/

#include "\A3\ui_f\hpp\defineCommonGrids.inc"

if !(hasInterface) exitWith {};

private _null = [] spawn {

    // init
    disableSerialization;
    private _displayType = if (isMultiplayer) then { "RscDisplayMPInterrupt" } else { "RscDisplayInterrupt" };

    while { true } do {

        waitUntil { !((uiNamespace getVariable _displayType) isEqualTo displayNull) };

        // get display
        private _displayPause = uiNamespace getVariable _displayType;

        // get save control & text
        private _saveCtrl     = _displayPause displayCtrl 103;
        private _originalText = ctrlText _saveCtrl;

        if (ctrlEnabled _saveCtrl) then {
            // hook into original save control to also save UCM

            // set text
            _saveCtrl ctrlSetText format ["%1 (%2)", _originalText, localize ("STR_SCAR_UCM_Menu_WithUCM")];

            // add event
            _saveCtrl ctrlAddEventHandler ["buttonClick", {
                // save on server
                [] remoteExec ["SCAR_UCM_fnc_saveAll", 2];
            }];

        } else {
            // save control disabled, add button to save only UCM

            // save position
            _savePosition = ctrlPosition _saveCtrl;

            // spacing
            _spacing = 0.003;

            // move all buttons including save UP
            {
                _control  = _displayPause displayCtrl _x;
                _position = ctrlPosition _control;
                _control ctrlSetPosition [_position select 0, (_position select 1) - GUI_GRID_H - _spacing];
                _control ctrlCommit 0;
            } forEach [1050, 523, 109, 2, 103]; // title background, title, player name, continue, save

            // create UCM button
            private _saveText = ctrlText _saveCtrl;
            _ucmSaveCtrl = _displayPause ctrlCreate ["RscButtonMenu", -1];
            _ucmSaveCtrl ctrlSetText format ["%1 (%2)", _saveText, localize ("STR_SCAR_UCM_Menu_UCM_Only")];
            _ucmSaveCtrl ctrlSetPosition _savePosition;
            _ucmSaveCtrl ctrlCommit 0;

            // add event
            _ucmSaveCtrl ctrlAddEventHandler ["buttonClick", {
                // save on server
                [] remoteExec ["SCAR_UCM_fnc_saveAll", 2];
                // close interface
                private _displayType = if (isMultiplayer) then { "RscDisplayMPInterrupt" } else { "RscDisplayInterrupt" };
                private _displayPause = uiNamespace getVariable _displayType;
                _displayPause closeDisplay 1;
                // message
                hint localize "STR_SCAR_UCM_Menu_UCM_SavedOK";
            }];
        };

        waitUntil { ((uiNamespace getVariable _displayType) isEqualTo displayNull) }; // wait until closed
    };
};

// return
true
