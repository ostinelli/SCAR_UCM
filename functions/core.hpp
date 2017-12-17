class SCAR_UCM_core {
    tag = "SCAR_UCM";

    class functions {
        file = "\scar_ucm\functions\core";

        class createMaterial {};
        class createWorkers {};
        class dropMaterialFromHelicopter {};
        class getCurrentPiece {};
        class getInVehicle {};
        class getOutVehicle {};
        class getPiecesCount {};
        class getStatusString {};
        class initForeman {};
        class initMarkerWorker {};
        class initMarkerWorkerLocal {};
        class initServer { postInit = true; };
        class initSettings {};
        class loopWorkerMovements {};
        class loopConstructionProgress {};
        class requestMaterial {};
        class requestWorkers {};
        class setMarkerConstruction {};
        class setMarkerConstructionLocal {};
        class setMarkerLandingZone {};
        class setMarkerLandingZoneLocal {};
        class setRandomWorkerLoadout {};
        class setWorkerAnimation {};
    };
};
