package physical {
    import ScalarValues::*;
    import needs::*;
    import logical::*;

    // --- Physical Port Definitions ---
    port def HostPort;

    // --- Physical Component Definitions ---

    part def UnifiedGameContainer {
        satisfy needs::NEED_SYS_001;
        satisfy needs::NEED_SYS_002;
        satisfy needs::NEED_SYS_003;
        satisfy needs::NEED_SYS_004;
        satisfy needs::NEED_SYS_005;
        satisfy needs::NEED_SYS_006;
        satisfy needs::NEED_SYS_007;
        satisfy needs::NEED_SYS_008;
        satisfy needs::NEED_SYS_011;

        port externalPort : HostPort;

        // Monolithic physical allocation of all logical elements
        allocate logical::UserPresentationUnit;
        allocate logical::GameCoordinator;
        allocate logical::RngUnit;
        allocate logical::GameLogicEngine;
        allocate logical::WebGameSystem;
    }
}
