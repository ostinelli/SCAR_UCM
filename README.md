["SCAR_UCM_ConstructionAreaMoved", [_store, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_ConstructionDone", [_store]] call CBA_fnc_serverEvent;
["SCAR_UCM_ConstructionNowInProgress", [_store, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_NoWorkersInConstructionArea", [_store, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_NoMaterialsInConstructionArea", [_store, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_WorkerKilled", [_store, _worker]] call CBA_fnc_serverEvent;
["SCAR_UCM_RequestedMaterials", [_store]] call CBA_fnc_serverEvent;
["SCAR_UCM_RequestedWorkers", [_store]] call CBA_fnc_serverEvent;
