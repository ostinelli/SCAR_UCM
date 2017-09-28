

// define idc's for controls
private _listBox = 21950;

private _index = lbCurSel _listBox;

// get worker
private _worker = missionNamespace getVariable "SCAR_UCM_workerInteractedWith";

// get car
private _vehicles = nearestObjects [_worker, ["Car", "Helicopter"], 100];
private _vehicle = _vehicles select _index;

[_worker, _vehicle] call SCAR_UCM_fnc_getInVehicle;

closeDialog 1;
