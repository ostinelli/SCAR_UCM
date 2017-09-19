/*
    Author: _SCAR

    Description:
    Adds the status action to a unit.

    Parameter(s):
    0: OBJECT - The store.
    1: UNIT   - The unit to attach the action to.

    Return:
    0: true

    Example:
    [_store, _unit] call SCAR_UCM_fnc_addActionRequestStatus;
*/

if !(hasInterface) exitWith {};

params ["_store", "_unit"];

private _action = [
    "SCAR_UCM_Status",
    (localize "STR_SCAR_UCM_Main_RequestStatus"),
    "",
    // Statement <CODE>
    {
        params ["_target", "_player", "_store"];

        // vars
        private _materials      = _store getVariable "SCAR_UCM_materials";
        _workersAreWorking      = _store getVariable "SCAR_UCM_workersAreWorking";
        _pieceCurrentId         = _store getVariable "SCAR_UCM_pieceCurrentId";
        _piecesCount            = _store getVariable "SCAR_UCM_piecesCount";
        _pieceCurrentPercentage = _store getVariable "SCAR_UCM_pieceCurrentPercentage";
        _workers                = _store getVariable "SCAR_UCM_workers";
        _workersCount           = _store getVariable "SCAR_UCM_workersCount";
        _workersInArea          = _store getVariable "SCAR_UCM_workersInArea";
        _materialsInArea        = _store getVariable "SCAR_UCM_materialsInArea";
        _materialsInArea        = _store getVariable "SCAR_UCM_materialsInArea";

        // compute percentages
        _remainingPercentageTot = 0;
        {
            _remainingPercentage    = _x select 1;
            _remainingPercentageTot = _remainingPercentageTot + _remainingPercentage;

        } forEach _materials;

        _active = "";
        if (_workersAreWorking) then {
            _active = "<t color='#11b740'>" + toUpper(localize "STR_SCAR_UCM_Main_Yes") + "</t>";
        } else {
            _active = "<t color='#b71111'>" + toUpper(localize "STR_SCAR_UCM_Main_No") + "</t>";
        };

        _str = "<t align='left'>";
        _str = _str + "<t color='#ffffc8'>" + toUpper(localize "STR_SCAR_UCM_Main_ConstructionStatus") + "</t><br /><br />";
        _str = _str + "<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionActive") + ":</t> " + _active + "<br />";
        _str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionProgressTotal") + ":</t> %1%2<br />", round(_pieceCurrentId / _piecesCount * 100), "%"];
        _str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_ConstructionPieceProgress") + ":</t> %1%2<br />", round(_pieceCurrentPercentage * 100), "%"];
        _str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_Workers") + ":</t> %1/%2 (%3 " + (localize "STR_SCAR_UCM_Main_InArea") + ")<br />", count _workers, _workersCount, count _workersInArea];
        _str = _str + format["<t color='#a8a8a8'>" + (localize "STR_SCAR_UCM_Main_Materials") + ":</t> %1%2 (%3/%4 " + (localize "STR_SCAR_UCM_Main_InArea") + ")", round(_remainingPercentageTot * 100), "%", count _materialsInArea, count _materials];
        _str = _str + "</t>";
        hint parseText (_str);
    },
    // Condition <CODE>
    { true },
    {},
    _store
] call ace_interact_menu_fnc_createAction;
[_unit,	0, ["ACE_MainActions"],	_action] call ace_interact_menu_fnc_addActionToObject;

// return
true
