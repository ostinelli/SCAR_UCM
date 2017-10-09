/*
    Author: _SCAR

    Description:
    Rewmoves all waypoints for a group.

    Paramster(s):
    0: GROUPì

    Return:
    true

    Example:
    [_group] call SCAR_UCM_fnc_deleteAllWaypoints;
*/

params ["_group"];

// loop & delete
while {(count (waypoints _group)) > 0} do {
    deleteWaypoint ((waypoints _group) select 0);
};

// return
true
