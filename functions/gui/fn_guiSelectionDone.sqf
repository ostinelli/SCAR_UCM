/*
    Author: _SCAR

    Description:
    Callback after having done a selection. Dispatcher to desired function.

    Return:
    true

    Example:
    [] spawn SCAR_UCM_fnc_guiSelectionDone;
*/

// IDc
private _listBox = 21950;

// get index
private _index = lbCurSel _listBox;

// get data & function
private _options  = missionNamespace getVariable "SCAR_UCM_SelectionOptions";
private _object   = missionNamespace getVariable "SCAR_UCM_SelectionObject";
private _function = missionNamespace getVariable "SCAR_UCM_SelectionFunction";

// get selection
private _selection = _options select _index;

// call it
private _code = format ["[_object, _selection] call %1;", _function];
call (compile _code);

// return
true
