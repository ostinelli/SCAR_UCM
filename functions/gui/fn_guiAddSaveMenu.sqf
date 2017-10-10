/*
    Author: _SCAR

    Description:
    Attach to the save button click event in Arma to save UCM data too.
    If the button is disabled, adds custom button to save UCM data only.

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

        if (([] call SCAR_UCM_fnc_isAdmin)) then {

            // get display
            private _displayPause = uiNamespace getVariable _displayType;

            // get UCM menu
            private _ucmMenuTitle  = _displayPause displayCtrl 20950;
            private _ucmSaveCtrl   = _displayPause displayCtrl 20951;
            private _ucmDeleteCtrl = _displayPause displayCtrl 20952;

            // prepare menu
            _ucmMenuTitle ctrlSetPosition [(1 * GUI_GRID_W + GUI_GRID_X), (4.1 * GUI_GRID_H + GUI_GRID_Y), 15 * GUI_GRID_W, GUI_GRID_H];
            _ucmMenuTitle ctrlShow true;
            _ucmMenuTitle ctrlCommit 0;
            _ucmSaveCtrl ctrlSetPosition [(1 * GUI_GRID_W + GUI_GRID_X), (5.2 * GUI_GRID_H + GUI_GRID_Y), 15 * GUI_GRID_W, GUI_GRID_H];
            _ucmSaveCtrl ctrlShow true;
            _ucmSaveCtrl ctrlCommit 0;
            _ucmDeleteCtrl ctrlSetPosition [(1 * GUI_GRID_W + GUI_GRID_X), (6.3 * GUI_GRID_H + GUI_GRID_Y), 15 * GUI_GRID_W, GUI_GRID_H];
            _ucmDeleteCtrl ctrlShow true;
            _ucmDeleteCtrl ctrlCommit 0;

            // add save event
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

            // add delete event
             _ucmDeleteCtrl ctrlAddEventHandler ["buttonClick", {
                private _null = [] spawn {
                    // are you sure?
                    _result = [(localize "STR_SCAR_UCM_Menu_UCM_DeleteAreYouSure"), "UCM", true, true] call BIS_fnc_guiMessage;
                    if (_result) then {
                        // delete all on server
                        [] remoteExec ["SCAR_UCM_fnc_profileNamespaceClear", 2];
                        // message
                        hint localize "STR_SCAR_UCM_Menu_UCM_DeletedOK";
                    };
                };
            }];

            // get save control & text
            private _saveCtrl = _displayPause displayCtrl 103;

            if (ctrlEnabled _saveCtrl) then {
                // original save enabled, hook into original save control to also save UCM

                // add UCM portion to original text
                private _originalText = ctrlText _saveCtrl;
                _saveCtrl ctrlSetText format ["%1 (%2)", _originalText, localize ("STR_SCAR_UCM_Menu_WithUCM")];

                // add event to save jointly
                _saveCtrl ctrlAddEventHandler ["buttonClick", {
                    // save on server
                    [] remoteExec ["SCAR_UCM_fnc_saveAll", 2];
                    // message
                    hint localize "STR_SCAR_UCM_Menu_UCM_SavedOK";
                }];
            };
        };

        waitUntil { ((uiNamespace getVariable _displayType) isEqualTo displayNull) }; // wait until closed
    };
};

// return
true
