/*
    Author: _SCAR

    Description:
    Shows a progress bar and disables player input.

    Parameter(s):
    0: NUMBER - Progress bar seconds duration.

    Return:
    true

    Example:
    [15] call SCAR_UCM_fnc_guiShowProgressBar;
*/

params ["_duration", "_text"];

// IDc
private _textId = 22950;
private _barId  = 22951;

// init
disableSerialization;

// disable input
disableUserInput true;

// create dialog
createDialog "SCAR_UCM_ProgressBar";

// get control
private _display = uiNamespace getVariable "SCAR_UCM_ProgressBar_Display";
private _bar     = _display displayCtrl _barId;
private _barText = _display displayCtrl _textId;

// set text
_barText ctrlSetText _text;

// progress
private _interval = 0.05;
private _counter = _duration / _interval;
for "_i" from 0 to _counter do {
    _bar progressSetPosition (_i / _counter);
    sleep 0.05;
};

// close dialog
closeDialog 1;

// enable input
disableUserInput false;

// return
true
