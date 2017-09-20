# Utilities Construction Mod

The **Utilities Construction Mod** is a module for Arma 3. Quickly add construction areas in your missions such as pipelines, railways, electric lines, and such.

> This module is still in pre-release.

## Core Features

  - Easy setup.
  - Customizable.
  - Compatible with persistency (ALiVE, EXILE, ...).

## Demo



## Getting Started



## Dependencies

  - ACE3 ([Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057), [Github](https://github.com/acemod/ACE3/releases/latest))
  - CBA_A3 ([Steam](https://steamcommunity.com/workshop/filedetails/?id=450814997), [Github](https://github.com/CBATeam/CBA_A3/releases/latest))

## Events

| NAME | DESCRIPTION | PARAMS
|------|------|------
| `UCM_ConstructionAreaMoved` | Construction Area was moved. | `_module`, `_currentId`, `_currentPiece`
| `UCM_ConstructionDone` | Construction is completed. | `_module`
| `UCM_ConstructionNowInProgress` | Construction work is now ongoing. | `_module`, `_currentId`, `_currentPiece`
| `UCM_NoWorkersInConstructionArea` | Construction works are stopped, there are no more workers on the site. | `_module`, `_currentId`, `_currentPiece`
| `UCM_NoMaterialsInConstructionArea` | Construction works are stopped, there are no more materials on the site. | `_module`, `_currentId`, `_currentPiece`
| `UCM_WorkerKilled` | A worker has been killed. | `_module`, `_worker`
| `UCM_RequestedMaterials` | New workers have been requested. | `_module`
| `UCM_RequestedWorkers` | New materials have been requested. | `_module`

All events will be called on the server only.

You can subscribe to events in your scripts with [`CBA_fnc_addEventHandler`](https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandler-sqf.html) or [`CBA_fnc_addEventHandlerArgs`](https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addEventHandlerArgs-sqf.html). For instance:

```sqf
private _id = ["UCM_ConstructionAreaMoved", {

	params ["_module", "_currentId", "_currentPiece"];

	private _mapPosition = mapGridPosition getPos _currentPiece;
	systemChat format ["Construction area is now at %1", _mapPosition];

}] call CBA_fnc_addEventHandler;
```


## Contribute

So you want to contribute? That's great! Please follow the guidelines below. It will make it easier to get merged in.

Before implementing a new feature, please submit a ticket to discuss what you intend to do. Your feature might already be in the works, or an alternative implementation might have already been discussed.

Do not commit to master in your fork. Provide a clean branch without merge commits. Every pull request should have its own topic branch. In this way, every additional adjustments to the original pull request might be done easily, and squashed with `git rebase -i`. The updated branch will be visible in the same pull request, so there will be no need to open new pull requests when there are changes to be applied.`
