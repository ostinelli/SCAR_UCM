/*
	Author: _SCAR

	Description:
	Handles all construction work progress (consumption of materials, visibility).

	Parameter(s):
	0: OBJECT - The store.

	Return:
	0: true

	Example:
	[_store] call SCAR_UCM_fnc_loopConstructionProgress;
*/

if !(isServer) exitWith {};

params ["_store"];

// vars
private _piecesCount      = _store getVariable "SCAR_UCM_piecesCount";
private _pieceNamePrefix  = _store getVariable "SCAR_UCM_pieceNamePrefix";
private _pieceStartHeight = _store getVariable "SCAR_UCM_pieceStartHeight";

// init construction position & visibility
for "_i" from (_store getVariable "SCAR_UCM_pieceCurrentId") to (_piecesCount - 1) do {
    private _pieceName = format["%1%2", _pieceNamePrefix, _i];

    diag_log format ["SCAR_UCG: hiding piece %1", _pieceName];

	// get piece
	private _piece = missionNamespace getVariable _pieceName;
	// hide
	_piece hideObjectGlobal true;
	// lower to ground
	[_piece, _pieceStartHeight] call SCAR_UCM_fnc_setAltitudeToGround;
};

// show current piece
private _currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;
_currentPiece hideObjectGlobal false;
private _altitude = _pieceStartHeight + ( (_store getVariable "SCAR_UCM_pieceCurrentPercentage") * (-_pieceStartHeight));
[_currentPiece, _altitude] call SCAR_UCM_fnc_setAltitudeToGround;

// show marker
[_store, getPos _currentPiece] call SCAR_UCM_fnc_setMarkerConstruction;

private _null = [_store] spawn {

	params ["_store"];

	// vars
	private _pieceStartHeight       = _store getVariable "SCAR_UCM_pieceStartHeight";
	private _materialEndHeight      = _store getVariable "SCAR_UCM_materialEndHeight";
	private _workingDistance        = _store getVariable "SCAR_UCM_workingDistance";
	private _pieceWorkingManSeconds = _store getVariable "SCAR_UCM_pieceWorkingManSeconds";
	private _piecesFromMaterial     = _store getVariable "SCAR_UCM_piecesFromMaterial";
	private _piecesCount            = _store getVariable "SCAR_UCM_piecesCount";
	private _side                   = _store getVariable "SCAR_UCM_side";

	// init
	private _sleepTime = 10;
	private _continue  = true;
	private _previous_workersAreWorking = false;

	while { _continue } do {

		// sleep
		sleep _sleepTime;

		// get piece
		private _currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;

		// check presence of workers (on the ground, not flying nearby, not in vehicle)
		private _workersInArea = [];
		{
			if ( ((_x distance _currentPiece) < _workingDistance) && (vehicle _x == _x) ) then {
				_workersInArea pushBack _x;
			};
		} forEach (_store getVariable "SCAR_UCM_workers");
		_store setVariable ["SCAR_UCM_workersInArea", _workersInArea, true];

		// check presence of material (on the ground, not flying nearby)
		private _materialsInArea = [];
		{
			// init
			private _material            = _x select 0;
			private _remainingPercentage = _x select 1;

			// altitude
			private _materialZ = getPos _material select 2;
			if (_materialZ < 2 && _materialZ > -50) then {  // loaded ACE items have a -100 height, see <https://github.com/acemod/ACE3/blob/master/addons/cargo/functions/fnc_loadItem.sqf#L37>
				// count
				if ( (_material distance _currentPiece) < _workingDistance) then {
					_materialsInArea pushBack _x;
				};
			};
		} forEach (_store getVariable "SCAR_UCM_materials");
		_store setVariable ["SCAR_UCM_materialsInArea", _materialsInArea, true];

		// advance work?
		if ( (count _workersInArea) > 0 && (count _materialsInArea) > 0) then {
		    // workers & materials are in area

			// set flag
			_store setVariable ["SCAR_UCM_workersAreWorking", true, true];

			// compute the work that has been done on the current piece
			_totalSecondsWorked     = (count _workersInArea) * _sleepTime;
			_pieceCurrentPercentage = (_store getVariable "SCAR_UCM_pieceCurrentPercentage") + (_totalSecondsWorked / _pieceWorkingManSeconds);
			if (_pieceCurrentPercentage > 1) then { _pieceCurrentPercentage = 1.0; }; // round for division errors
			_store setVariable ["SCAR_UCM_pieceCurrentPercentage", _pieceCurrentPercentage, true];

			// set piece height for current work
			_altitude = _pieceStartHeight + ((_store getVariable "SCAR_UCM_pieceCurrentPercentage") * (-_pieceStartHeight));
			[_currentPiece, _altitude] call SCAR_UCM_fnc_setAltitudeToGround;

            // piece status?
			if ((_store getVariable "SCAR_UCM_pieceCurrentPercentage") == 1) then {
				// a piece has been finished

                // compute consumption of first available material
				_materialEntry = _materialsInArea select 0; // simplify and just get get first element
				_materials     = (_store getVariable "SCAR_UCM_materials") - [_materialEntry]; // remove element, will be either updated here below or not added back

				_material              = _materialEntry select 0;
				_remainingPercentage   = _materialEntry select 1;
				_consumptionPercentage = 1.0 / _piecesFromMaterial;
				_remainingPercentage   = _remainingPercentage - _consumptionPercentage;

				// update materials
				if (_remainingPercentage <= 0.01) then { // round for division errors
					deleteVehicle _material;
				} else {
					// material still usable, update percentage
					_materials pushBack [_material, _remainingPercentage];
					// set altitude
					_altitude = _materialEndHeight + (_remainingPercentage * (-_materialEndHeight));
					[_material, _altitude] call SCAR_UCM_fnc_setAltitudeToGround;
				};
				_store setVariable ["SCAR_UCM_materials", _materials, true];

				// increase id to next piece
				private _nextId = (_store getVariable "SCAR_UCM_pieceCurrentId") + 1;
				_store setVariable ["SCAR_UCM_pieceCurrentId", _nextId, true];

				if (_nextId < _piecesCount) then {
					// pieces are still available, reset current percentage
					_store setVariable ["SCAR_UCM_pieceCurrentPercentage", 0.0, true];

					// make next piece visible
					private _newPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;
					_newPiece hideObjectGlobal false;

					// move marker
					[_store, getPos _newPiece] call SCAR_UCM_fnc_setMarkerConstruction;

					// fire event
					["UCM_ConstructionAreaMoved", [_store, _nextId, _newPiece]] call CBA_fnc_serverEvent;
				} else {
					// construction work is done, TODO call event

					// flags
					_store setVariable ["SCAR_UCM_workersAreWorking", false, true];
					_continue = false;

					// fire event
					["UCM_ConstructionDone", [_store]] call CBA_fnc_serverEvent;
				};
			};
		} else {
			_store setVariable ["SCAR_UCM_workersAreWorking", false, true];
		};

		if !(_previous_workersAreWorking isEqualTo (_store getVariable "SCAR_UCM_workersAreWorking")) then {
		    _currentPiece = [_store] call SCAR_UCM_fnc_getCurrentPiece;
		    private _currentPieceId  = _store getVariable "SCAR_UCM_pieceCurrentId";

			if (_store getVariable "SCAR_UCM_workersAreWorking") then {
			    // fire event
			    ["UCM_ConstructionNowInProgress", [_store, _currentPieceId, _currentPiece]] call CBA_fnc_serverEvent;
			    // radio
				[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_ConstructionNowInProgress")] remoteExec ["sideChat"];
			} else {
				if ( (count _workersInArea) == 0) then {
                    // fire event
                    ["UCM_NoWorkersInConstructionArea", [_store, _currentPieceId, _currentPiece]] call CBA_fnc_serverEvent;
                    // radio
					[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_NoWorkersInConstructionArea")] remoteExec ["sideChat"];
				};
				if ( (count _materialsInArea) == 0) then {
                    // fire event
                    ["UCM_NoMaterialsInConstructionArea", [_store, _currentPieceId, _currentPiece]] call CBA_fnc_serverEvent;
                    // radio
					[[_side, "HQ"], (localize "STR_SCAR_UCM_Radio_NoMaterialsInConstructionArea")] remoteExec ["sideChat"];
				};
			};
		};

		// flag
		_previous_workersAreWorking = (_store getVariable "SCAR_UCM_workersAreWorking");
	};
};

// return
true
