![Utilities Construction Mod logo](https://cldup.com/jVkD9k4D9t.png)

# Utilities Construction Mod

The **Utilities Construction Mod** is a module for Arma 3. Quickly add construction areas in your missions for pipelines, railways, electric lines, and such.

> This module is still in early beta. Some changes and bugs are to be expected.

## Core Features

  - Easy setup.
  - Customizable.
  - Compatible with persistency (ALiVE, ...).

## Video Trailer

[![Click to watch video](https://img.youtube.com/vi/ZIp2BfbvO1E/0.jpg)](https://www.youtube.com/watch?v=ZIp2BfbvO1E)


## Video Tutorial

[![Click to watch video](https://img.youtube.com/vi/sbx0QSRaUt4/0.jpg)](https://www.youtube.com/watch?v=sbx0QSRaUt4)


## Dependencies

  - ACE3 ([Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057), [Github](https://github.com/acemod/ACE3/releases/latest))
  - CBA_A3 ([Steam](https://steamcommunity.com/workshop/filedetails/?id=450814997), [Github](https://github.com/CBATeam/CBA_A3/releases/latest))

## Example mission

You can download an example mission from [here](https://github.com/ostinelli/SCAR_UCM/raw/master/resources/ucm_demo.Altis.zip).

## Download

You can get the module from [Steam](http://steamcommunity.com/sharedfiles/filedetails/?id=1145478729).

## Functions

##### SCAR_UCM_fnc_isInitialized
```
Description:
Returns if the UCM module is initialized.

Parameter(s):
0: OBJECT - The logicModule.

Return:
0: BOOLEAN

Example:
[_logicModule] call SCAR_UCM_fnc_isInitialized;
```

## Events

| NAME | DESCRIPTION | PARAMS
|------|------|------
| `UCM_ConstructionAreaMoved` | Construction Area was moved. | `_logicModule`, `_currentPiece`
| `UCM_ConstructionDone` | Construction is completed. | `_logicModule`
| `UCM_ConstructionNowInProgress` | Construction work is now ongoing. | `_logicModule`, `_currentPiece`
| `UCM_NoWorkersInConstructionArea` | Construction works are stopped, there are no more workers on the site. | `_logicModule`, `_currentPiece`
| `UCM_NoMaterialsInConstructionArea` | Construction works are stopped, there are no more materials on the site. | `_logicModule`, `_currentPiece`
| `UCM_WorkerKilled` | A worker has been killed. | `_logicModule`, `_worker`
| `UCM_RequestedMaterials` | New workers have been requested. | `_logicModule`
| `UCM_RequestedWorkers` | New materials have been requested. | `_logicModule`

All events will be called on the server only.

You can subscribe to events in your scripts with [`CBA_fnc_addEventHandler`](https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandler-sqf.html) or [`CBA_fnc_addEventHandlerArgs`](https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandlerArgs-sqf.html). For instance:

```sqf
private _id = ["UCM_ConstructionAreaMoved", {

	params ["_logicModule", "_currentPiece"];

	private _mapPosition = mapGridPosition getPos _currentPiece;
	systemChat format ["Construction area is now at %1", _mapPosition];

}] call CBA_fnc_addEventHandler;
```


## Contribute

So you want to contribute? That's great! Please follow the guidelines below. It will make it easier to get merged in.

Before implementing a new feature, please submit a ticket to discuss what you intend to do. Your feature might already be in the works, or an alternative implementation might have already been discussed.

Do not commit to master in your fork. Provide a clean branch without merge commits. Every pull request should have its own topic branch. In this way, every additional adjustments to the original pull request might be done easily, and squashed with `git rebase -i`. The updated branch will be visible in the same pull request, so there will be no need to open new pull requests when there are changes to be applied.`
