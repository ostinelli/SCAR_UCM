/*
	Author: _SCAR

	Description:
	Launch attack to the construction area.

	Parameter(s):
	0: OBJECT - The strikeModule.

	Return:
	true

	Example:
	[_strikeModule] spawn SCAR_UCM_fnc_surgicalStrikeAttack;
*/

if !(isServer) exitWith {};

params ["_strikeModule"];

systemchat "ATTACK!!!";

// flag
_strikeModule setVariable ["SCAR_UCM_Strike_attackIsOngoing", true, true];

// args
private _logicModule = _strikeModule getVariable "SCAR_UCM_Strike_logicModule";

// current area
private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;
if (_currentPiece isEqualTo objNull) exitWith {};

// get pos
private _attackPos = getPos _currentPiece;

// create transport TODO make these as settings & modules
private _originPos = [15715, 16327];
private _side = OPFOR;
private _unitsCount = 5;

private _result  = [_originPos, 0, "O_Truck_03_transport_F", _side] call BIS_fnc_spawnVehicle;
private _vehicle = _result select 0;
private _crew    = _result select 1;
private _transportGroup   = _result select 2;

// create units
private _cargoGroup = [_originPos, _side, _unitsCount] call BIS_fnc_spawnGroup;

// assign as cargo & move in
{
    _x assignAsCargo _vehicle;
    _x moveInCargo _vehicle;
} forEach (units _cargoGroup);

// behaviours
_transportGroup setBehaviour "COMBAT";
_transportGroup setCombatMode "GREEN";
_cargoGroup setBehaviour "COMBAT";
_cargoGroup setCombatMode "RED";

// --> vehicle: unload
private _relativeDir      = [_vehicle, _currentPiece] call BIS_fnc_relativeDirTo;
private _relativeDistance = 150;
private _destinationPos   = _attackPos getPos [_relativeDistance, - _relativeDir];

private _wpUnload = _transportGroup addWaypoint [_destinationPos, 0];
_wpUnload setWaypointType "TR UNLOAD";

// --> cargo: get out
private _wpGetOut = _cargoGroup addWaypoint [_destinationPos, 0];
_wpGetOut setWaypointType "GETOUT";

// --> cargo: SAD
private _wpGetOut = _cargoGroup addWaypoint [_attackPos, 0];
_wpGetOut setWaypointType "SAD";

// --> vehicle: leave
private _wpLeave = _transportGroup addWaypoint [_originPos, 0];
_wpLeave setWaypointType "MOVE";
_wpLeave setWaypointStatements ["true", "deleteVehicle (vehicle this); { deleteVehicle _x } forEach thisList;"];


// TODO: set end of attack & clean armies if long forgotten

// return
true
