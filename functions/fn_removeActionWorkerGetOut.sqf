/*
    Author: _SCAR

    Description:
    Removes the action to a vehicle to allow passengers to get out.

    Parameter(s):
    0: OBJECT - The logicModule.
    1: OBJECT - The worker.
    2: UNIT - The vehicle.

    Return:
    0: true

    Example:
    [_logicModule, _worker, _vehicle] call SCAR_UCM_fnc_removeActionWorkerGetOut;
*/

if !(hasInterface) exitWith {};

params ["_logicModule", "_worker", "_vehicle"];

// remove
[_vehicle, 0, ["ACE_MainActions", "ACE_Passengers", str _worker, "SCAR_UCM_WorkerGetOutOfVehicle"]] remoteExec ["ace_interact_menu_fnc_removeActionFromObject"];

// return
true
