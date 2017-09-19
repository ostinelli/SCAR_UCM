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
            "ace_interact_menu",
            "ace_cargo"
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
                displayName  = "Side";
                description  = "The side of the construction workers (can be 'blufor', 'opfor', 'independent', 'civilian')";
                typeName     = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                defaultValue = """BLUFOR"""; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
            };
            class WorkersCount: Edit
            {
                property     = "SCAR_UCM_WorkersCount";
                displayName  = "Workers Count";
                description  = "The number of construction workers";
                typeName     = "NUMBER";
                defaultValue = "3";
            };
            class PieceWorkingManSeconds: Edit
            {
                property     = "SCAR_UCM_PieceWorkingManSeconds";
                displayName  = "Man Seconds per piece";
                description  = "The number of man seconds needed to complete a single piece";
                typeName     = "NUMBER";
                defaultValue = "300";
            };
            class PieceNamePrefix: Edit
            {
                property     = "SCAR_UCM_PieceNamePrefix";
                displayName  = "Pieces' name prefix";
                description  = "The prefix to be used in piece variables";
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_""";
            };
            class PiecesFromMaterial: Edit
            {
                property     = "SCAR_UCM_piecesFromMaterial";
                displayName  = "Pieces from material";
                description  = "The total number of pieces that can be built with a single material";
                typeName     = "NUMBER";
                defaultValue = "3";
            };
            class WorkingDistance: Edit
            {
                property     = "SCAR_UCM_WorkingDistance";
                displayName  = "Working Distance (m)";
                description  = "The distance of workers and materials from the current piece for the construction to be active";
                typeName     = "NUMBER";
                defaultValue = "75";
            };
            class PieceStartNegativeHeight: Edit
            {
                property     = "SCAR_UCM_pieceStartHeight";
                displayName  = "Piece starting position (Z)";
                description  = "The starting Z position of a piece in the ground, at the end it will raise to be Z = 0";
                typeName     = "NUMBER";
                defaultValue = "-0.6";
            };
            class MaterialEndNegativeHeight: Edit
            {
                property     = "SCAR_UCM_materialEndHeight";
                displayName  = "Material end position (Z)";
                description  = "The ending Z position of a material on the ground, at the start it is Z = 0";
                typeName     = "NUMBER";
                defaultValue = "-1.4";
            };
            class WorkersBoss: Edit
            {
                property     = "SCAR_UCM_WorkersBoss";
                displayName  = "The workers' boss";
                description  = "The workers' boss (variable name)";
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_worker_boss""";
            };
            class HelicopterLandingZone: Edit
            {
                property     = "SCAR_UCM_HelicopterLandingZone";
                displayName  = "The landing zone";
                description  = "The landing zone (area object variable name)";
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_helicopter_landing_zone""";
            };
            class HelicopterOrigin: Edit
            {
                property     = "SCAR_UCM_HelicopterOrigin";
                displayName  = "The helicopters' origin";
                description  = "The helicopters' origin (area object variable name)";
                typeName     = "STRING";
                defaultValue = """SCAR_UCM_helicopter_origin""";
            };
            class HelicopterClass: Edit
            {
                property     = "SCAR_UCM_HelicopterClass";
                displayName  = "The helicopters' class";
                description  = "The helicopters' class name";
                typeName     = "STRING";
                defaultValue = """B_Heli_Transport_03_unarmed_F""";
            };
            class MaterialsClass: Edit
            {
                property     = "SCAR_UCM_MaterialsClass";
                displayName  = "The materials' class";
                description  = "The materials' class name";
                typeName     = "STRING";
                defaultValue = """Land_IronPipes_F""";
            };
            class MaterialsWeight: Edit
            {
                property     = "SCAR_UCM_MaterialsWeight";
                displayName  = "The materials' weight";
                description  = "The weight of a single material unit";
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

class CfgFunctions {

    class SCAR_UCM {
        tag = "SCAR_UCM";

        class functions {
            file = "\scar_ucm\functions";

            // module
            class moduleUtilitiesConstructionMod {};

            // inits
            class initServer {};
            class initPlayer {};
            class initBoss {};
            class initSettings {};

            // events
            class onUnloadedCargoPos {};

            // loops
            class loopWorkerMovements {};
            class loopConstructionProgress {};

            // actions
            class addActionsToBoss {};
            class addActionsToWorker {};
            class addActionRequestStatus {};
            class addActionWorkerGetIn {};
            class addActionWorkerGetOut {};

            // resources
            class requestWorkers {};
            class requestMaterial {};
            class createWorkers {};
            class dropMaterialFromHelicopter {};

            // various
            class getCurrentPiece {};
            class getPiecesCount {};
            class setAltitudeToGround {};
            class setWorkerAnimation {};
            class setMarkerConstruction {};
            class setMarkerWorker {};
            class safetyDeleteVehicleAndCrew {};
            class setGlobalVariableIfUnset {};
            class setRandomWorkerLoadout {};
        };
    };
};

class CfgSounds
{
    sounds[] = {};
    class SCAR_UCM_working_1
    {
        name = "working_1";
        sound[] = {"\scar_ucm\sounds\chisel-45.ogg", 1, 1, 150}; // filename, volume, pitch, distance
        titles[] = {};
    };
    class SCAR_UCM_working_2
    {
        name = "working_2";
        sound[] = {"\scar_ucm\sounds\grinder_small-28.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_3
    {
        name = "working_3";
        sound[] = {"\scar_ucm\sounds\grinder-62.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_4
    {
        name = "working_4";
        sound[] = {"\scar_ucm\sounds\hammering-6.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_5
    {
        name = "working_5";
        sound[] = {"\scar_ucm\sounds\sander-31.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_6
    {
        name = "working_6";
        sound[] = {"\scar_ucm\sounds\scratching-16.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_7
    {
        name = "working_7";
        sound[] = {"\scar_ucm\sounds\wrench_losen-10.ogg", 1, 1, 150};
        titles[] = {};
    };
    class SCAR_UCM_working_8
    {
        name = "working_8";
        sound[] = {"\scar_ucm\sounds\wrench-10.ogg", 1, 1, 150};
        titles[] = {};
    };
};

