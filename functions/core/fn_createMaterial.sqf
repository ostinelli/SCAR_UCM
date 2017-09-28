/*
    Author: _SCAR

    Description:
    Creates the material in the specified vehicle.

    Parameter(s):
    0: OBJECT   - The logicModule.
    1: POSITION - Where to spawn the material.
    2: NUMBER   - The remaining material percentage.

    Return:
    OBJECT: The material.

    Example:
    [_logicModule, _position, _remainingPercentage] call SCAR_UCM_fnc_createMaterial;
*/

if !(isServer) exitWith {};

params ["_logicModule", "_position", "_remainingPercentage"];

//vars
private _materialsClass  = _logicModule getVariable "SCAR_UCM_materialsClass";
private _materialsWeight = _logicModule getVariable "SCAR_UCM_materialsWeight";

// create
private _material = _materialsClass createVehicle _position;

// make materials loadable
[_material, _materialsWeight] remoteExec ["ace_cargo_fnc_setSize"];

// add to available materials
private _materials = _logicModule getVariable "SCAR_UCM_materials";
_materials pushBack [_material, _remainingPercentage];
_logicModule setVariable ["SCAR_UCM_materials", _materials, true];

// return
_material
