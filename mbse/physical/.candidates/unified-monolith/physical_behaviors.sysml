package unified_monolith {
    import ScalarValues::*;
    import needs::*;
    import logical::*;

    // --- Physical Behavior Definitions ---

    action def CompileStaticBundle {
        doc /* Compile TypeScript and Tailwind assets into static HTML/JS/CSS using Bun build tools */
        allocate logical::RenderGameScreenAction;
    }

    action def MountStaticFiles {
        doc /* Mount static bundle directories in FastAPI using StaticFiles middleware */
    }

    action def FastApiListen {
        doc /* Start Uv FastAPI web server listening on port 8000 for browser requests */
        allocate logical::StartCountdownAction;
    }

    action def CaptureClientChoice {
        doc /* Capture local player selection in static web frontend */
        allocate logical::CapturePlayerChoiceAction;
    }

    action def GenerateCpuSelection {
        doc /* Asynchronously generate computer choice on the FastAPI application server */
        allocate logical::GenerateComputerChoiceAction;
    }

    action def EvaluateRoundOutcome {
        doc /* Evaluate round rules directly on FastAPI */
        allocate logical::EvaluateRoundAction;
    }

    action def UpdateMatchScores {
        doc /* Keep track of wins and verify if match has ended */
        allocate logical::UpdateScoreAndCheckMatchAction;
    }

    action def MonolithSystemBehavior {
        action compile : CompileStaticBundle;
        action mount : MountStaticFiles;
        action listen : FastApiListen;
        action capture : CaptureClientChoice;
        action cpuGen : GenerateCpuSelection;
        action eval : EvaluateRoundOutcome;
        action update : UpdateMatchScores;

        first compile;
        then mount;
        then listen;

        then capture;
        then cpuGen;
        then eval;
        then update;
    }
}
