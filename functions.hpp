class CfgFunctions {

    class SCAR_UCM {
        tag = "SCAR_UCM";

        class functions {
            file = "\scar_ucm\functions";

            // modules
            class moduleUtilitiesConstructionMod {};

            // inits
            class initServer {};
            class initPlayer {};
            class initSettings {};
            class initForeman {};

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
            class addActionGetIn {};
            class addActionGetOut {};
            class removeActionGetOut {};

            // resources
            class requestWorkers {};
            class requestMaterial {};
            class createWorkers {};
            class dropMaterialFromHelicopter {};

            // getters & setters
            class getCurrentPiece {};
            class getPiecesCount {};
            class getStatusString {};
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
            class convertSideStrToSide {};

            // ALiVE
            class aliveInit {};
            class aliveOnConstructionAreaMoved {};

            // helpers
            class isInitialized {};
        };
    };
};
