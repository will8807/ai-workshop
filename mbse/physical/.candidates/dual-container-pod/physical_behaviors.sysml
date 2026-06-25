package dual_container_pod {
    import ScalarValues::*;
    import needs::*;
    import logical::*;

    // --- Physical Item Definitions ---
    item def HttpPayload;

    // --- Physical Behavior Definitions ---

    action def BunBuildFrontend {
        doc /* Build frontend assets with Bun and render user presentation screens */
        allocate logical::RenderGameScreenAction;
    }

    action def CapturePlayerChoice {
        doc /* Capture local player selection from interactive dashboard */
        allocate logical::CapturePlayerChoiceAction;
    }

    action def UvStartFastApi {
        doc /* Start Uv FastAPI backend server to coordinate state and routes */
        allocate logical::StartCountdownAction;
    }

    action def TransmitHttpPayload {
        doc /* Transmit player choices and control actions to backend over localhost HTTP */
    }

    action def GenerateComputerChoice {
        doc /* Generate random computer selection using Python random module on FastAPI */
        allocate logical::GenerateComputerChoiceAction;
    }

    action def EvaluateRounds {
        doc /* Evaluate round outcome on FastAPI rules engine */
        allocate logical::EvaluateRoundAction;
    }

    action def UpdateScoreAndCheck {
        doc /* Update score tracking on FastAPI backend */
        allocate logical::UpdateScoreAndCheckMatchAction;
    }

    action def PhysicalPodBehavior {
        action buildFe : BunBuildFrontend;
        action startBe : UvStartFastApi;
        action captureInput : CapturePlayerChoice;
        action transmit : TransmitHttpPayload;
        action genCpuChoice : GenerateComputerChoice;
        action evalRound : EvaluateRounds;
        action updateScore : UpdateScoreAndCheck;

        first buildFe;
        first startBe;

        then captureInput;
        then genCpuChoice;

        then transmit;
        then evalRound;
        then updateScore;
    }
}
