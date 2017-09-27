/*
    Author: _SCAR

    Description:
    Gets the Status string.

    Parameter(s):
    0: OBJECT - The logicModule.

    Return:
    0: Parsed Text

    Example:
    [_logicModule] call SCAR_UCM_fnc_getStatusString;
*/

params ["_logicModule"];

// vars
private _materials              = _logicModule getVariable "SCAR_UCM_materials";
private _workersAreWorking      = _logicModule getVariable "SCAR_UCM_workersAreWorking";
private _pieceCurrentId         = _logicModule getVariable "SCAR_UCM_pieceCurrentId";
private _piecesCount            = _logicModule getVariable "SCAR_UCM_piecesCount";
private _pieceCurrentPercentage = _logicModule getVariable "SCAR_UCM_pieceCurrentPercentage";
private _workers                = _logicModule getVariable "SCAR_UCM_workers";
private _workersCount           = _logicModule getVariable "SCAR_UCM_workersCount";
private _workersInArea          = _logicModule getVariable "SCAR_UCM_workersInArea";
private _materialsInArea        = _logicModule getVariable "SCAR_UCM_materialsInArea";

// compute total percentage
private _totPercentage = round(_pieceCurrentId / _piecesCount * 100);

// compute materials percentages
private _remainingPercentageTot = 0;
{
    private _remainingPercentage = _x select 1;
    _remainingPercentageTot = _remainingPercentageTot + _remainingPercentage;

} forEach _materials;

private _active = "";
if (_workersAreWorking) then {
    _active = "<t color='#11b740'>" + toUpper(localize "STR_SCAR_UCM_Main_Yes") + "</t>";
} else {
    if (_totPercentage == 100) then {
        _active = "<t color='#11b740'>" + toUpper(localize "STR_SCAR_UCM_Main_Finished") + "</t>";
    } else {
        _active = "<t color='#b71111'>" + toUpper(localize "STR_SCAR_UCM_Main_No") + "</t>";
    };
};

private _str = "<t align='left'>";
_str = _str + "<t color='#ffffc8'>" + toUpper(localize "STR_SCAR_UCM_Main_ConstructionStatus") + "</t><br /><br />";
_str = _str + "<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionActive") + ":</t> " + _active + "<br />";
_str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionProgressTotal") + ":</t> %1%2<br />", _totPercentage, "%"];
_str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionPieceProgress") + ":</t> %1%2<br />", round(_pieceCurrentPercentage * 100), "%"];
_str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_Workers") + ":</t> %1/%2 (%3 " + (localize "STR_SCAR_UCM_Main_InArea") + ")<br />", count _workers, _workersCount, count _workersInArea];
_str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_Materials") + ":</t> %1%2 (%3/%4 " + (localize "STR_SCAR_UCM_Main_InArea") + ")", round(_remainingPercentageTot * 100), "%", count _materialsInArea, count _materials];
_str = _str + "</t>";

// return
parseText (_str);
