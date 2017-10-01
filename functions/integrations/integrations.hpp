// main
class SCAR_UCM_integrations {
    tag = "SCAR_UCM";

    class functions {
        file = "\scar_ucm\functions\integrations";

        class initIntegrations {};
    };
};

// ACE
class SCAR_UCM_integrations_ace {
    tag = "SCAR_UCM";

    class functions {
        file = "\scar_ucm\functions\integrations\ace";

        class isAceAvailable {};
        class onUnloadedCargoPos {};
    };
};

// ALiVE
class SCAR_UCM_integrations_alive {
    tag = "SCAR_UCM";

    class functions {
        file = "\scar_ucm\functions\integrations\alive";

        class aliveOnConstructionAreaMoved {};
        class aliveSaveOnQuit {};
        class initAlive {};
    };
};
