package dual_container_pod {
    import ScalarValues::*;
    import needs::*;
    import logical::*;

    // --- Physical Port Definitions ---
    port def HttpPort;
    port def HostPort;

    // --- Physical Component Definitions ---

    part def BunFrontendContainer {
        satisfy needs::NEED_SYS_001;
        satisfy needs::NEED_SYS_002;
        satisfy needs::NEED_SYS_003;
        satisfy needs::NEED_SYS_004;
        satisfy needs::NEED_SYS_005;
        satisfy needs::NEED_SYS_011;

        port httpPort : HttpPort;
        port externalPort : HostPort;

        allocate logical::UserPresentationUnit;
    }

    part def UvBackendContainer {
        satisfy needs::NEED_SYS_006;
        satisfy needs::NEED_SYS_007;
        satisfy needs::NEED_SYS_008;
        satisfy needs::NEED_SYS_011;

        port httpPort : HttpPort;

        allocate logical::GameCoordinator;
        allocate logical::RngUnit;
        allocate logical::GameLogicEngine;
    }

    part def K8sGamePod {
        satisfy needs::NEED_SYS_012;
        satisfy needs::NEED_SYS_013;
        satisfy needs::NEED_SYS_014;

        part frontend : BunFrontendContainer;
        part backend : UvBackendContainer;

        connect frontend.httpPort to backend.httpPort;

        allocate logical::WebGameSystem;
    }
}
