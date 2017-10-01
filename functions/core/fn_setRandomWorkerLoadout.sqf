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
    "U_C_ConstructionCoverall_Vrana_F",
    "U_C_IDAP_Man_Cargo_F",
    "U_C_IDAP_Man_Jeans_F"
];

private _vest = selectRandom [
    "V_Safety_yellow_F",
    "V_Safety_orange_F",
    "V_Safety_blue_F"
];

private _headgear = selectRandom [
    "H_Construction_earprot_orange_F",
    "H_Construction_earprot_red_F",
    "H_Construction_earprot_white_F",
    "H_Construction_earprot_vrana_F",
    "H_Construction_earprot_yellow_F"
];

private _face = selectRandom [
    "AfricanHead_01",
    "AfricanHead_02",
    "AfricanHead_03",
    "AsianHead_A3_01",
    "AsianHead_A3_02",
    "AsianHead_A3_03",
    "GreekHead_A3_01",
    "GreekHead_A3_02",
    "GreekHead_A3_03",
    "GreekHead_A3_04",
    "GreekHead_A3_05",
    "GreekHead_A3_06",
    "GreekHead_A3_07",
    "GreekHead_A3_08",
    "GreekHead_A3_09",
    "PersianHead_A3_01",
    "PersianHead_A3_02",
    "PersianHead_A3_03",
    "NATOHead_01",
    "WhiteHead_02",
    "WhiteHead_03 ",
    "WhiteHead_04",
    "WhiteHead_05",
    "WhiteHead_06",
    "WhiteHead_07",
    "WhiteHead_08",
    "WhiteHead_09",
    "WhiteHead_10",
    "WhiteHead_11",
    "WhiteHead_12",
    "WhiteHead_13",
    "WhiteHead_14",
    "WhiteHead_15"
];

private _goggles = selectRandom [
    "G_Respirator_blue_F",
    "G_Respirator_white_F",
    "G_Respirator_yellow_F",
    "G_EyeProtectors_F"
];

// set
_worker forceAddUniform _uniform;
_worker addItemToUniform "FirstAidKit";
_worker addHeadgear _headgear;
_worker addGoggles _goggles;
_worker linkItem "ItemMap";
_worker linkItem "ItemCompass";
_worker linkItem "ItemWatch";
_worker linkItem "ItemRadio";
_worker setFace _face;
_worker setSpeaker "";

// optionals
if ((random 1) > 0.25) then {
    _worker addVest _vest;
};
if ((random 1) > 0.25) then {
    _worker addBackpack "B_LegStrapBag_black_repair_F";
    _worker addItemToBackpack "ToolKit";
};

// return
true
