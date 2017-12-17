/*
    Author: _SCAR

    Description:
    Drop materials from provided vehicle.

    Parameter(s):
    0: UNIT - The vehicle dropping the materials.

    Return:
    true

    Example:
    [_vehicle] call SCAR_UCM_fnc_dropMaterialFromHelicopter;
*/

if !(isServer) exitWith {};

params ["_vehicle"];

// vars
private _logicModule     = _vehicle getVariable "SCAR_UCM_logicModule";
private _materialsClass  = _logicModule getVariable "SCAR_UCM_materialsClass";

// create parachute & materials
private _pos = getPos _vehicle;
private _chute = createVehicle ["B_Parachute_02_F", [100, 100, 200], [], 0, 'FLY'];
_chute setPos [_pos select 0, _pos select 1, (_pos select 2) - 20];

private _material = createVehicle [_materialsClass, getPos _chute, [], 0, 'NONE'];
_material attachTo [_chute, [0, 0, -1.3]];

// fall
waitUntil { position _material select 2 < 0.5 || isNull _chute };

// detach parachute
detach _material;

// duplicate the material to solve the arma "hurting object" bug
_pos = getPos _material;
deleteVehicle _material;
[_logicModule, _pos, 1.0] call SCAR_UCM_fnc_createMaterial;

// destroy chute
sleep 5;
deleteVehicle _chute;

// return
true
