/*
    Author: _SCAR

    Description:
    Convert code into a string to be used when code is to be passed in as string.

    Paramster(s):
    0: CODE

    Return:
    STRING or NIL

    Example:
    { hint "hello";} call SCAR_UCM_fnc_convertCodeToStr;
*/

private _str    = format["%1", _this];
private _length = count(_str);

// return
if (_length > 2) then {
     _str select [1, _length - 2];
} else {
    nil
};
