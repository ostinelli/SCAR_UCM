/*
	Author: _SCAR

	Description:
	Handles all construction work progress (consumption of materials, visibility).

	Parameter(s):
	0: OBJECT - The logicModule.

	Return:
	true

	Example:
	[_logicModule] call SCAR_UCM_fnc_loopConstructionProgress;
*/

if !(isServer) exitWith {};

params ["_logicModule"];

// vars
private _piecesCount      = _logicModule getVariable "SCAR_UCM_piecesCount";
private _pieceNamePrefix  = _logicModule getVariable "SCAR_UCM_pieceNamePrefix";
private _pieceStartHeight = _logicModule getVariable "SCAR_UCM_pieceStartHeight";

// init construction position & visibility
for "_i" from (_logicModule getVariable "SCAR_UCM_pieceCurrentId") to (_piecesCount - 1) do {
    private _pieceName = format["%1%2", _pieceNamePrefix, _i];

	// get piece
	private _piece = missionNamespace getVariable _pieceName;
	// hide
	_piece hideObjectGlobal true;
	// lower to ground
	[_piece, _pieceStartHeight] call SCAR_UCM_fnc_setAltitudeToGround;
};
[_logicModule, "Done hiding construction pieces."] call SCAR_UCM_fnc_log;

// show current piece
private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;
if (_currentPiece isEqualTo objNull) exitWith {}; // construction is finished

_currentPiece hideObjectGlobal false;
private _altitude = _pieceStartHeight + ( (_logicModule getVariable "SCAR_UCM_pieceCurrentPercentage") * (-_pieceStartHeight));
[_currentPiece, _altitude] call SCAR_UCM_fnc_setAltitudeToGround;

// show marker
[_logicModule, _currentPiece] call SCAR_UCM_fnc_setMarkerConstruction;

private _null = [_logicModule] spawn {

	params ["_logicModule"];

	// vars
	private _pieceStartHeight       = _logicModule getVariable "SCAR_UCM_pieceStartHeight";
	private _materialEndHeight      = _logicModule getVariable "SCAR_UCM_materialEndHeight";
	private _workingDistance        = _logicModule getVariable "SCAR_UCM_workingDistance";
	private _pieceWorkingManSeconds = _logicModule getVariable "SCAR_UCM_pieceWorkingManSeconds";
	private _piecesFromMaterial     = _logicModule getVariable "SCAR_UCM_piecesFromMaterial";
	private _piecesCount            = _logicModule getVariable "SCAR_UCM_piecesCount";
	private _side                   = _logicModule getVariable "SCAR_UCM_side";

	// init
	private _sleepTime = 5;
	private _continue  = true;
	private _previous_workersAreWorking = false;

	while { _continue } do {

		// sleep
		sleep _sleepTime;

		// get piece
		private _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

		// check presence of workers (on the ground, not flying nearby, not in vehicle)
		private _workersInArea = [];
		{
			if (
			    ((_x distance _currentPiece) < _workingDistance)  // in area
			    && (vehicle _x == _x)                             // not in vehicle
			) then {
				_workersInArea pushBack _x;
			};
		} forEach (_logicModule getVariable "SCAR_UCM_workers");
		_logicModule setVariable ["SCAR_UCM_workersInArea", _workersInArea, true];

        // check workers that are actually working
		private _workersWorking = [];
		{
			if ((speed _x) < 2) then {  // not moving
			    _workersWorking pushBack _x;
			};
		} forEach _workersInArea;

		// check presence of material (on the ground, not flying nearby)
		private _materialsInArea = [];
		{
			// init
			private _material = _x select 0;

			// altitude
			private _materialZ = getPos _material select 2;
			if (
			    _materialZ < 2      // material on ground
			    && _materialZ > -50 // not loaded on vehicle
			) then {
				// count
				if ( (_material distance _currentPiece) < _workingDistance) then {
					_materialsInArea pushBack _x;
				};
			};
		} forEach (_logicModule getVariable "SCAR_UCM_materials");
		_logicModule setVariable ["SCAR_UCM_materialsInArea", _materialsInArea, true];

		// advance work?
		if ( (count _workersInArea) > 0 && (count _materialsInArea) > 0) then {
		    // workers & materials are in area

			// set flag
			_logicModule setVariable ["SCAR_UCM_workersAreWorking", true, true];

			// compute the work that has been done on the current piece
			private _totalSecondsWorked     = (count _workersWorking) * _sleepTime;
			private _pieceCurrentPercentage = (_logicModule getVariable "SCAR_UCM_pieceCurrentPercentage") + (_totalSecondsWorked / _pieceWorkingManSeconds);
			if (_pieceCurrentPercentage > 1) then { _pieceCurrentPercentage = 1.0; }; // round for division errors
			_logicModule setVariable ["SCAR_UCM_pieceCurrentPercentage", _pieceCurrentPercentage, true];

			// set piece height for current work
			private _altitude = _pieceStartHeight + ((_logicModule getVariable "SCAR_UCM_pieceCurrentPercentage") * (-_pieceStartHeight));
			[_currentPiece, _altitude] call SCAR_UCM_fnc_setAltitudeToGround;

            // piece status?
			if ((_logicModule getVariable "SCAR_UCM_pieceCurrentPercentage") == 1) then {
				// a piece has been finished

                // compute consumption of first available material
				private _materialEntry = _materialsInArea select 0; // simplify and just get get first element
				private _materials     = (_logicModule getVariable "SCAR_UCM_materials") - [_materialEntry]; // remove element, will be either updated here below or not added back

				private _material              = _materialEntry select 0;
				private _remainingPercentage   = _materialEntry select 1;
				private _consumptionPercentage = 1.0 / _piecesFromMaterial;
				_remainingPercentage           = _remainingPercentage - _consumptionPercentage;

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
				_logicModule setVariable ["SCAR_UCM_materials", _materials, true];

				// increase id to next piece
				private _nextId = (_logicModule getVariable "SCAR_UCM_pieceCurrentId") + 1;
				_logicModule setVariable ["SCAR_UCM_pieceCurrentId", _nextId, true];

				if (_nextId < _piecesCount) then {
					// pieces are still available, reset current percentage
					_logicModule setVariable ["SCAR_UCM_pieceCurrentPercentage", 0.0, true];

					// make next piece visible
					private _newPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;
					_newPiece hideObjectGlobal false;

					// move marker
					[_logicModule, _newPiece] call SCAR_UCM_fnc_setMarkerConstruction;

					// fire event
					["UCM_ConstructionAreaMoved", [_logicModule, _newPiece]] spawn CBA_fnc_serverEvent;
				} else {
					// construction work is done

					// flags
					_logicModule setVariable ["SCAR_UCM_workersAreWorking", false, true];
					_continue = false;

					// fire event
					["UCM_ConstructionDone", [_logicModule, _currentPiece]] spawn CBA_fnc_serverEvent;
				};
			};
		} else {
			_logicModule setVariable ["SCAR_UCM_workersAreWorking", false, true];
		};

		if !(_previous_workersAreWorking isEqualTo (_logicModule getVariable "SCAR_UCM_workersAreWorking")) then {
		    _currentPiece = [_logicModule] call SCAR_UCM_fnc_getCurrentPiece;

			if (_logicModule getVariable "SCAR_UCM_workersAreWorking") then {
			    // fire event
			    ["UCM_ConstructionNowInProgress", [_logicModule, _currentPiece]] spawn CBA_fnc_serverEvent;
			    // radio
                [_side, "STR_SCAR_UCM_Radio_ConstructionNowInProgress"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];
			} else {
				if ( (count _workersInArea) == 0) then {
                    // fire event
                    ["UCM_NoWorkersInConstructionArea", [_logicModule, _currentPiece]] spawn CBA_fnc_serverEvent;
                    // radio
                    [_side, "STR_SCAR_UCM_Radio_NoWorkersInConstructionArea"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];
				};
				if ( (count _materialsInArea) == 0) then {
                    // fire event
                    ["UCM_NoMaterialsInConstructionArea", [_logicModule, _currentPiece]] spawn CBA_fnc_serverEvent;
                    // radio
                    [_side, "STR_SCAR_UCM_Radio_NoMaterialsInConstructionArea"] remoteExec ["SCAR_UCM_fnc_sideChatLocalized", 0];
				};
			};
		};

		// flag
		_previous_workersAreWorking = (_logicModule getVariable "SCAR_UCM_workersAreWorking");
	};
};

// return
true
