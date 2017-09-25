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
            class initSettings {};

            // events
            class onUnloadedCargoPos {};

            // loops
            class loopWorkerMovements {};
            class loopConstructionProgress {};

            // actions
            class addActionsToForeman {};
            class addActionsToWorker {};

            class addActionGoToConstructionArea {};
            class addActionRequestStatus {};
            class addActionRequestWorkers {};
            class addActionRequestMaterials {};
            class addActionWorkerGetIn {};
            class addActionWorkerGetOut {};
            class removeActionWorkerGetOut {};

            // resources
            class requestWorkers {};
            class requestMaterial {};
            class createWorkers {};
            class dropMaterialFromHelicopter {};

            // getters & setters
            class getCurrentPiece {};
            class getPiecesCount {};
            class setAltitudeToGround {};
            class setWorkerAnimation {};
            class setMarkerConstruction {};
            class setMarkerLandingZone {};
            class setMarkerWorker {};
            class setGlobalVariableIfUnset {};
            class setRandomWorkerLoadout {};

            // other
            class safetyDeleteVehicleAndCrew {};
            class canRespondToActions {};

            // helpers
            class isInitialized {};
        };
    };
};
