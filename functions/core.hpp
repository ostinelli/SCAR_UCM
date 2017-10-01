class SCAR_UCM_core {
    tag = "SCAR_UCM";

    class functions {
        file = "\scar_ucm\functions\core";

        class createMaterial {};
        class createWorkers {};
        class dropMaterialFromHelicopter {};
        class getCurrentPiece {};
        class getInVehicle {};
        class getPiecesCount {};
        class getStatusString {};
        class initForeman {};
        class initPlayer { postInit = true; };
        class initServer { postInit = true; };
        class initSettings {};
        class loopWorkerMovements {};
        class loopConstructionProgress {};
        class requestMaterial {};
        class requestWorkers {};
        class setMarkerConstruction {};
        class setMarkerLandingZone {};
        class setMarkerWorker {};
        class setRandomWorkerLoadout {};
        class setWorkerAnimation {};
    };
};
