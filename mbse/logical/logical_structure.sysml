package logical {
    import ScalarValues::*;
    import needs::*;

    // --- Logical Port Definitions (Interfaces) ---
    port def TimerPort {
        out item value : TimerValue;
    }

    port def ChoicePort {
        out item selection : GameChoice;
    }

    port def ResultPort {
        out item outcome : RoundResult;
    }

    port def MatchStatusPort {
        out item score : MatchScore;
        out item finalResult : MatchOutcome;
    }

    port def ControlSignalPort {
        out item trigger : Boolean;
    }

    // --- Structural Logical Components ---

    part def UserPresentationUnit {
        satisfy needs::NEED_SYS_002;
        satisfy needs::NEED_SYS_003;
        satisfy needs::NEED_SYS_004;
        satisfy needs::NEED_SYS_005;

        // Ports
        port playerChoiceOut : ChoicePort;
        port timerIn : ~TimerPort;
        port computerChoiceIn : ~ChoicePort;
        port roundResultIn : ~ResultPort;
        port matchStatusIn : ~MatchStatusPort;
        port controlSignalOut : ControlSignalPort;

        // Behaviors performed by this part
        perform action renderGameScreen : RenderGameScreenAction {
            in item timerVal = timerIn.value;
            in item score = matchStatusIn.score;
            in item playerChoice = playerChoiceOut.selection;
            in item computerChoice = computerChoiceIn.selection;
            in item roundResult = roundResultIn.outcome;
            in item matchResult = matchStatusIn.finalResult;
        }

        perform action capturePlayerChoice : CapturePlayerChoiceAction {
            in item timerVal = timerIn.value;
            out item playerChoice = playerChoiceOut.selection;
        }
    }

    part def GameCoordinator {
        satisfy needs::NEED_SYS_006;
        satisfy needs::NEED_SYS_007;
        satisfy needs::NEED_SYS_008;

        // Ports
        port controlSignalIn : ~ControlSignalPort;
        port timerOut : TimerPort;
        port rngTriggerOut : ControlSignalPort;
        port computerChoiceIn : ~ChoicePort;
        port playerChoiceIn : ~ChoicePort;
        port playerChoiceOut : ChoicePort;
        port computerChoiceOut : ChoicePort;
        port roundResultIn : ~ResultPort;
        port roundResultOut : ResultPort;
        port matchStatusOut : MatchStatusPort;

        // Behaviors performed by this part
        perform action startCountdown : StartCountdownAction {
            in item trigger = controlSignalIn.trigger;
            out item timerVal = timerOut.value;
        }

        perform action updateScoreAndCheckMatch : UpdateScoreAndCheckMatchAction {
            in item result = roundResultIn.outcome;
            out item updatedScore = matchStatusOut.score;
            out item matchResult = matchStatusOut.finalResult;
        }
    }

    part def RngUnit {
        satisfy needs::NEED_SYS_009;

        // Ports
        port triggerIn : ~ControlSignalPort;
        port choiceOut : ChoicePort;

        // Behaviors performed by this part
        perform action generateComputerChoice : GenerateComputerChoiceAction {
            in item trigger = triggerIn.trigger;
            out item computerChoice = choiceOut.selection;
        }
    }

    part def GameLogicEngine {
        satisfy needs::NEED_SYS_010;
        satisfy needs::NEED_SYS_015;

        // Ports
        port playerChoiceIn : ~ChoicePort;
        port computerChoiceIn : ~ChoicePort;
        port resultOut : ResultPort;

        // Behaviors performed by this part
        perform action evaluateRound : EvaluateRoundAction {
            in item playerChoice = playerChoiceIn.selection;
            in item computerChoice = computerChoiceIn.selection;
            out item roundResult = resultOut.outcome;
        }
    }

    // --- System Context Component (Assembling the internal elements) ---

    part def WebGameSystem {
        satisfy needs::NEED_SYS_001;
        satisfy needs::NEED_SYS_011;
        satisfy needs::NEED_SYS_012;
        satisfy needs::NEED_SYS_013;
        satisfy needs::NEED_SYS_014;

        part userPresentation : UserPresentationUnit;
        part gameCoordinator : GameCoordinator;
        part rngUnit : RngUnit;
        part gameLogicEngine : GameLogicEngine;

        // Structural connections between ports
        connect userPresentation.controlSignalOut to gameCoordinator.controlSignalIn;
        connect gameCoordinator.timerOut to userPresentation.timerIn;
        connect userPresentation.playerChoiceOut to gameCoordinator.playerChoiceIn;
        connect gameCoordinator.rngTriggerOut to rngUnit.triggerIn;
        connect rngUnit.choiceOut to gameCoordinator.computerChoiceIn;
        
        connect gameCoordinator.playerChoiceOut to gameLogicEngine.playerChoiceIn;
        connect gameCoordinator.computerChoiceOut to gameLogicEngine.computerChoiceIn;
        connect gameLogicEngine.resultOut to gameCoordinator.roundResultIn;
        
        connect gameCoordinator.roundResultOut to userPresentation.roundResultIn;
        connect gameCoordinator.matchStatusOut to userPresentation.matchStatusIn;
        connect rngUnit.choiceOut to userPresentation.computerChoiceIn;

        // Composite Behavior Allocation
        perform action gameBehavior : GameSessionBehavior {
            action startTimer = gameCoordinator.startCountdown;
            action getPlayerChoice = userPresentation.capturePlayerChoice;
            action getComputerChoice = rngUnit.generateComputerChoice;
            action evaluateRound = gameLogicEngine.evaluateRound;
            action updateScore = gameCoordinator.updateScoreAndCheckMatch;
            action renderScreen = userPresentation.renderGameScreen;
        }
    }
}
