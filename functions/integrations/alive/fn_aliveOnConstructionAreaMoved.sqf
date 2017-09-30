/*
    Author: _SCAR

    Description:
    Listen to the UCM_ConstructionAreaMoved event and sets the ALiVE objective.

    Return:
    true

    Example:
    [] call SCAR_UCM_fnc_aliveOnConstructionAreaMoved;
*/

["UCM_ConstructionAreaMoved", {

    params ["_logicModule", "_currentPiece"];

    // vars
    private _side            = _logicModule getVariable "SCAR_UCM_side";
    private _objectiveId     = "SCAR_UCM_OPCOM_constructionArea";
    private _size            = 30;
    private _priority        = 1000;
    private _objectiveParams = [_objectiveId, (getPos _currentPiece), _size, "CIV", _priority];

    {
        // remove previous custom objective
        [_x, "removeObjective", _objectiveId] call ALiVE_fnc_OPCOM;

        // add custom objective
        private _opcomSideStr = [_x, "side", ""] call ALiVE_fnc_HashGet;
        private _opcomSide    = [_opcomSideStr] call SCAR_UCM_fnc_convertSideStrToSide;
        private _isEnemy      = [_side, _opcomSide] call BIS_fnc_sideIsEnemy;

        if (_isEnemy) then {
            [_x, "addObjective", _objectiveParams] call ALiVE_fnc_OPCOM;
        };

    } forEach OPCOM_INSTANCES;

}] call CBA_fnc_addEventHandler;

// return
true
