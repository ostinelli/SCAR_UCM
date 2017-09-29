class CfgPatches
{
    class SCAR_UCM
    {
        name = "Utilities Construction Mod";
        author = "_SCAR";
        units[] = {
            "SCAR_UCM_ModuleUtilitiesConstructionMod",
            "SCAR_UCM_ModuleUtilitiesConstructionLandingZone",
            "SCAR_UCM_ModuleUtilitiesConstructionHelicopterOrigin"
        };
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {
            "A3_Modules_F",
            "CBA_common",
            "CBA_events"
        };
        fileName = "scar_ucm.pbo";
    };
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class SCAR_UCM_UtilitiesConstructionMod: NO_CATEGORY
	{
		displayName = "Utilities Construction Mod";
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
            class Combo;
        };
    };

    class SCAR_UCM_ModuleUtilitiesConstructionMod: Module_F
    {
        // Standard object definitions
        scope = 2;
        displayName = $STR_SCAR_UCM_ModuleUtilitiesConstructionMod;
        icon = "\scar_ucm\gfx\logo.paa";
        category = "SCAR_UCM_UtilitiesConstructionMod";

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
            // Module specific arguments
            class Side: Combo
            {
                property     = "SCAR_UCM_Side";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_Side_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_Side_tooltip;
                typeName     = "STRING";
                defaultValue = "BLUFOR";

                class Values {
                    class Blufor      { name = "BLUFOR"; value = "BLUFOR"; default = 1; };
                    class Opfor       { name = "OPFOR"; value = "OPFOR"; };
                    class Independent { name = "INDEPENDENT"; value = "INDEPENDENT"; };
                    class Civilian    { name = "CIVILIAN"; value = "CIVILIAN"; };
                };
            };
            class WorkersCount: Edit
            {
                property     = "SCAR_UCM_WorkersCount";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersCount_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_WorkersCount_tooltip;
                typeName     = "NUMBER";
                defaultValue = "3";
            };
            class PieceWorkingManSeconds: Edit
            {
                property     = "SCAR_UCM_PieceWorkingManSeconds";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceWorkingManSeconds_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_PieceWorkingManSeconds_tooltip;
                typeName     = "NUMBER";
                defaultValue = "1800";
            };
            class PiecesFromMaterial: Edit
            {
                property     = "SCAR_UCM_PiecesFromMaterial";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PiecesFromMaterial_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_PiecesFromMaterial_tooltip;
                typeName     = "NUMBER";
                defaultValue = "3";
            };

            class PieceNamePrefix: Edit
            {
                property     = "SCAR_UCM_PieceNamePrefix";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceNamePrefix_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_PieceNamePrefix_tooltip;
                typeName     = "STRING";
                defaultValue = """UCM_piece_""";
            };
            class PieceStartHeight: Edit
            {
                property     = "SCAR_UCM_PieceStartHeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_PieceStartHeight_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_PieceStartHeight_tooltip;
                typeName     = "NUMBER";
                defaultValue = "-0.6";
            };

            class MaterialsClass: Edit
            {
                property     = "SCAR_UCM_MaterialsClass";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsClass_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsClass_tooltip;
                typeName     = "STRING";
                defaultValue = """Land_IronPipes_F""";
            };
            class MaterialEndHeight: Edit
            {
                property     = "SCAR_UCM_MaterialEndHeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialEndHeight_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialEndHeight_tooltip;
                typeName     = "NUMBER";
                defaultValue = "-1.4";
            };
            class MaterialsWeight: Edit
            {
                property     = "SCAR_UCM_MaterialsWeight";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsWeight_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_MaterialsWeight_tooltip;
                typeName     = "NUMBER";
                defaultValue = "16";
            };

            class WorkingDistance: Edit
            {
                property     = "SCAR_UCM_WorkingDistance";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_WorkingDistance_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_WorkingDistance_tooltip;
                typeName     = "NUMBER";
                defaultValue = "75";
            };

            class Foreman: Edit
            {
                property     = "SCAR_UCM_Foreman";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_Foreman_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_Foreman_tooltip;
                typeName     = "STRING";
                defaultValue = """UCM_foreman""";
            };

            class HelicopterClass: Edit
            {
                property     = "SCAR_UCM_HelicopterClass";
                displayName  = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterClass_displayName;
                tooltip      = $STR_SCAR_UCM_Module_SCAR_UCM_HelicopterClass_tooltip;
                typeName     = "STRING";
                defaultValue = """B_Heli_Transport_03_unarmed_F""";
            };
        };
    };

    class SCAR_UCM_ModuleUtilitiesConstructionLandingZone: Module_F
    {
        // Standard object definitions
        scope = 2;
        displayName = $STR_SCAR_UCM_Module_SCAR_UCM_ModuleUtilitiesConstructionLandingZone;
        icon = "\scar_ucm\gfx\logo.paa";
        category = "SCAR_UCM_UtilitiesConstructionMod";

        isGlobal           = 1;
        isTriggerActivated = 0;
        isDisposable       = 0;
    };

    class SCAR_UCM_ModuleUtilitiesConstructionHelicopterOrigin: Module_F
    {
        // Standard object definitions
        scope = 2;
        displayName = $STR_SCAR_UCM_ModuleUtilitiesConstructionHelicopterOrigin;
        icon = "\scar_ucm\gfx\logo.paa";
        category = "SCAR_UCM_UtilitiesConstructionMod";

        isGlobal           = 1;
        isTriggerActivated = 0;
        isDisposable       = 0;
    };

    class SCAR_UCM_ModuleUtilitiesConstructionSurgicalStrike: Module_F
    {
        // Standard object definitions
        scope = 2;
        displayName = $STR_SCAR_UCM_ModuleUtilitiesConstructionSurgicalStrike;
        icon = "\scar_ucm\gfx\logo.paa";
        category = "SCAR_UCM_UtilitiesConstructionMod";

        isGlobal           = 1;
        isTriggerActivated = 0;
        isDisposable       = 0;
    };
};

#include "gui/gui.hpp"
#include "functions/functions.hpp"
#include "sounds.hpp"
