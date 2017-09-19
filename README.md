["UCM_ConstructionAreaMoved", [_module, _currentId, _currentPiece, ]] call CBA_fnc_serverEvent;
["UCM_ConstructionDone", [_module]] call CBA_fnc_serverEvent;
["UCM_ConstructionNowInProgress", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["UCM_NoWorkersInConstructionArea", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["UCM_NoMaterialsInConstructionArea", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["UCM_WorkerKilled", [_module, _worker]] call CBA_fnc_serverEvent;
["UCM_RequestedMaterials", [_module]] call CBA_fnc_serverEvent;
["UCM_RequestedWorkers", [_module]] call CBA_fnc_serverEvent;


Sounds
sander-12.ogg | License: Attribution 3.0 | Recorded by Mike Koenig
drill-6.ogg  | License: Attribution 3.0 | Recorded by Mike Koenig

Other sounds are of Public Domain.
