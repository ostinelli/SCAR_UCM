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
            class initForeman {};
            class initSettings {};

            // events
            class onUnloadedCargoPos {};

            // loops
            class loopWorkerMovements {};
            class loopConstructionProgress {};

            // actions
            class addActionsToForeman {};
            class addActionsToWorker {};
            class addActionRequestStatus {};
            class addActionWorkerGetIn {};
            class addActionWorkerGetOut {};

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
            class setMarkerWorker {};
            class setGlobalVariableIfUnset {};
            class setRandomWorkerLoadout {};

            // other
            class safetyDeleteVehicleAndCrew {};
        };
    };
};
