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
    private _objectiveParams = [_objectiveId, (getPos _currentPiece), 30, "CIV", 200];

    {
        // remove previous custom objective
        [_x, "removeObjective", _objectiveId] call ALiVE_fnc_OPCOM;

        // add custom objective
        _opcomSide = [_x, "side", ""] call ALiVE_fnc_HashGet;
        if( _opcomSide == _side) then {
            [_opcom, "addObjective", _objectiveParams] call ALiVE_fnc_OPCOM;
        };

    } forEach OPCOM_INSTANCES;

}] call CBA_fnc_addEventHandler;
