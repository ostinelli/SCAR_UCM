["SCAR_UCM_ConstructionAreaMoved", [_module, _currentId, _currentPiece, ]] call CBA_fnc_serverEvent;
["SCAR_UCM_ConstructionDone", [_module]] call CBA_fnc_serverEvent;
["SCAR_UCM_ConstructionNowInProgress", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_NoWorkersInConstructionArea", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_NoMaterialsInConstructionArea", [_module, _currentId, _currentPiece]] call CBA_fnc_serverEvent;
["SCAR_UCM_WorkerKilled", [_module, _worker]] call CBA_fnc_serverEvent;
["SCAR_UCM_RequestedMaterials", [_module]] call CBA_fnc_serverEvent;
["SCAR_UCM_RequestedWorkers", [_module]] call CBA_fnc_serverEvent;
