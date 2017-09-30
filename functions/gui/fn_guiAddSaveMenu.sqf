/*
    Author: _SCAR

    Description:
    Adds custom save with UCM to menu.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_guiAddSaveMenu;
*/

if !(hasInterface) exitWith {};

waitUntil { !((findDisplay 46) isEqualTo displayNull) };

(findDisplay 46) displayAddEventHandler ["KeyDown", {

	params ["_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];

	if (_dikCode == 0x01) then { // escape

        private _isAdmin = ((call BIS_fnc_admin) > 0) || !isMultiplayer;

	    if (_isAdmin) then {
	        // client is admin
            private _null = [] spawn {

                // get menu display
                disableSerialization;
                private _displayType = if (isMultiplayer) then {"RscDisplayMPInterrupt"} else {"RscDisplayInterrupt"};
                waitUntil { !((uiNamespace getVariable _displayType) isEqualTo displayNull) };
                private _displayPause = uiNamespace getVariable _displayType;

                // get control
                private _saveControl = _displayPause displayCtrl 103;
                // set text
                private _originalText = ctrlText _saveControl;
                _saveControl ctrlSetText format ["%1 (%2)", _originalText, localize ("STR_SCAR_UCM_Menu_WithUCM")];

                // add event
                _saveControl ctrlAddEventHandler ["buttonClick", {
                    // save on server
                    [] remoteExec ["SCAR_UCM_fnc_saveAll", 2];
                }];
            };
	    };
	};
}];

// return
true
