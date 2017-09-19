/*
    Author: _SCAR

    Description:
    Gets a random worker loadout

    Parameter(s):
    0: UNIT - The worker.

    Return:
    0:true

    Example:
    [_worker] call SCAR_UCM_fnc_setRandomWorkerLoadout;
*/

params ["_worker"];

// remove all
removeAllWeapons _worker;
removeAllItems _worker;
removeAllAssignedItems _worker;
removeUniform _worker;
removeVest _worker;
removeBackpack _worker;
removeHeadgear _worker;
removeGoggles _worker;

// generate random sets
private _uniform = selectRandom [
    "U_C_ConstructionCoverall_Black_F",
    "U_C_ConstructionCoverall_Blue_F",
    "U_C_ConstructionCoverall_Red_F",
    "U_C_ConstructionCoverall_Vrana_F"
];

private _headgear = selectRandom [
    "H_Construction_earprot_red_F",
    "H_Construction_earprot_yellow_F",
    "H_Construction_earprot_white_F",
    "H_Construction_earprot_vrana_F"
];

private _face = selectRandom [
    "WhiteHead_05",
    "WhiteHead_06",
    "WhiteHead_15",
    "WhiteHead_17"
];

// set
_worker forceAddUniform _uniform;
_worker addItemToUniform "FirstAidKit";
_worker addHeadgear _headgear;
_worker addGoggles "G_Respirator_yellow_F";
_worker linkItem "ItemMap";
_worker linkItem "ItemCompass";
_worker linkItem "ItemWatch";
_worker linkItem "ItemRadio";
_worker setFace _face;
_worker setSpeaker "";

// return
true
