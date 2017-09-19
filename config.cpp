class CfgPatches
{
    class SCAR_UCM
    {
        name = "Utilities Construction Mod";
        author = "_SCAR";
        units[] = {"SCAR_ModuleUtilitiesConstructionMod"};
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {
            "A3_Modules_F",
            "ace_cargo",
            "ace_interactions",
            "ace_interact_menu"
        };
        fileName = "scar_ucm.pbo";
    };
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Edit;
            class Units;
        };
        // Description base classes, for more information see below
        class ModuleDescription	{
            class AnyPlayer;
        };
    };

    class SCAR_ModuleUtilitiesConstructionMod: Module_F
    {
        // Standard object definitions
        scope = 2;
        displayName = "Utilities Construction Mod";
        icon = "\scar_ucm\gfx\logo.paa";
        category = "Sites";

        // Name of function triggered once conditions are met
        function = "SCAR_UCM_fnc_moduleUtilitiesConstructionMod";
        // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
        functionPriority = 1;
        // 0 for server only execution, 1 for global execution, 2 for persistent global execution
        isGlobal = 1;
        // 1 for module waiting until all synced triggers are activated
        isTriggerActivated = 0;
        // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
        isDisposable = 0;

        // Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
        class Attributes: AttributesBase
        {
            // Arguments shared by specific module type (have to be mentioned in order to be present)
            class Units: Units {};

            // Module specific arguments
            class Side: Edit
            {
                property     = "SCAR_UCM_Side";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_Side_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_Side_description;
                typeName     = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                defaultValue = """BLUFOR"""; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
            };
            class WorkersCount: Edit
            {
                property     = "SCAR_UCM_WorkersCount";
                displayName  = "Workers Count";
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersCount_displayName
                typeName     = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersCount_description;
                defaultValue = "3";
            };
            class PieceWorkingManSeconds: Edit
            {
                property     = "SCAR_UCM_PieceWorkingManSeconds";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceWorkingManSeconds_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceWorkingManSeconds_description;
                typeName     = "NUMBER";
                defaultValue = "300";
            };
            class PieceNamePrefix: Edit
            {
                property     = "SCAR_UCM_PieceNamePrefix";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceNamePrefix_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceNamePrefix_description;
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_""";
            };
            class PiecesFromMaterial: Edit
            {
                property     = "SCAR_UCM_piecesFromMaterial";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PiecesFromMaterial_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_PiecesFromMaterial_description;
                typeName     = "NUMBER";
                defaultValue = "3";
            };
            class WorkingDistance: Edit
            {
                property     = "SCAR_UCM_WorkingDistance";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkingDistance_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkingDistance_description;
                typeName     = "NUMBER";
                defaultValue = "75";
            };
            class PieceStartHeight: Edit
            {
                property     = "SCAR_UCM_pieceStartHeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceStartHeight_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceStartHeight_description;
                typeName     = "NUMBER";
                defaultValue = "-0.6";
            };
            class MaterialEndHeight: Edit
            {
                property     = "SCAR_UCM_materialEndHeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialEndHeight_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialEndHeight_description;
                typeName     = "NUMBER";
                defaultValue = "-1.4";
            };
            class WorkersBoss: Edit
            {
                property     = "SCAR_UCM_WorkersBoss";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersBoss_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersBoss_description;
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_worker_boss""";
            };
            class HelicopterLandingZone: Edit
            {
                property     = "SCAR_UCM_HelicopterLandingZone";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterLandingZone_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterLandingZone_description;
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_helicopter_landing_zone""";
            };
            class HelicopterOrigin: Edit
            {
                property     = "SCAR_UCM_HelicopterOrigin";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterOrigin_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterOrigin_description;
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_helicopter_origin""";
            };
            class HelicopterClass: Edit
            {
                property     = "SCAR_UCM_HelicopterClass";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterClass_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterClass_description;
                typeName     = "STRING";
                defaultValue = """B_Heli_Transport_03_unarmed_F""";
            };
            class MaterialsClass: Edit
            {
                property     = "SCAR_UCM_MaterialsClass";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsClass_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsClass_description;
                typeName     = "STRING";
                defaultValue = """Land_IronPipes_F""";
            };
            class MaterialsWeight: Edit
            {
                property     = "SCAR_UCM_MaterialsWeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsWeight_displayName;
                description  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsWeight_description;
                typeName     = "NUMBER";
                defaultValue = "20";
            };
        };

        class ModuleDescription: ModuleDescription
        {
            description = "Utilities Construction Mod";
            sync[] = {};
        };
    };
};

#include "functions.hpp"
#include "sounds.hpp"
