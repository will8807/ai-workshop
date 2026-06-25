package logical {
    import ScalarValues::*;
    import needs::*;

    // --- Logical Data Types (Item Definitions) ---
    item def GameChoice;     // Represents Rock, Paper, Scissors, Lizard, Spock
    item def RoundResult;    // Represents Player Win, Computer Win, or Tie
    item def MatchScore {
        attribute playerWins : Integer;
        attribute computerWins : Integer;
    }
    item def TimerValue {
        attribute secondsRemaining : Integer;
    }
    item def MatchOutcome {
        attribute isFinished : Boolean;
        attribute matchWinner : String;
    }

    // --- Derived Requirements (INCOSE-Compliant Logical Requirements) ---
    requirement REQ_LOG_001 {
        attribute source : String = "Derivation: User Presentation";
        doc /* The User Presentation Unit shall render the game interface representing the scoreboard, the countdown timer, the selection highlights, and the match results. */
        derive from needs::NEED_SYS_016_1;
        derive from needs::NEED_SYS_016_2;
        derive from needs::NEED_SYS_016_3;
        derive from needs::NEED_SYS_018;
        derive from needs::NEED_SYS_020;
        derive from needs::NEED_SYS_021;
        derive from needs::NEED_SYS_022;
        derive from needs::NEED_SYS_023;
        derive from needs::NEED_SYS_026_1;
    }
    verification case verifyReqLog001;
    verify REQ_LOG_001 by verifyReqLog001;

    requirement REQ_LOG_002 {
        attribute source : String = "Derivation: Game Coordinator";
        doc /* The Game Coordinator shall orchestrate the game state transitions throughout the match. */
        derive from needs::NEED_SYS_017;
    }
    verification case verifyReqLog002;
    verify REQ_LOG_002 by verifyReqLog002;

    requirement REQ_LOG_003 {
        attribute source : String = "Derivation: Random Number Generator";
        doc /* The Random Number Generator Unit shall generate the computer selection asynchronously upon receiving the coordinator trigger. */
        derive from needs::NEED_SYS_009;
        derive from needs::NEED_SYS_019;
    }
    verification case verifyReqLog003;
    verify REQ_LOG_003 by verifyReqLog003;

    requirement REQ_LOG_004 {
        attribute source : String = "Derivation: Rules Engine";
        doc /* The Game Logic Engine shall evaluate the outcome of each round based on the classic Rock-Paper-Scissors-Lizard-Spock rules. */
        derive from needs::NEED_SYS_010;
        derive from needs::NEED_SYS_015;
    }
    verification case verifyReqLog004;
    verify REQ_LOG_004 by verifyReqLog004;

    requirement REQ_LOG_005 {
        attribute source : String = "Derivation: Score Keeper";
        doc /* The Game Coordinator shall terminate the match when either the player or the computer reaches two wins. */
        derive from needs::NEED_SYS_024;
        derive from needs::NEED_SYS_025;
    }
    verification case verifyReqLog005;
    verify REQ_LOG_005 by verifyReqLog005;

    // --- Behavioral Action Definitions (Functional Analysis) ---

    action def StartCountdownAction {
        in item trigger : Boolean;
        out item timerVal : TimerValue;
        satisfy needs::NEED_SYS_017;
    }

    action def CapturePlayerChoiceAction {
        in item timerVal : TimerValue;
        out item playerChoice : GameChoice;
        satisfy needs::NEED_SYS_018;
        satisfy needs::NEED_SYS_020;
    }

    action def GenerateComputerChoiceAction {
        in item trigger : Boolean;
        out item computerChoice : GameChoice;
        satisfy needs::NEED_SYS_009;
        satisfy needs::NEED_SYS_019;
    }

    action def EvaluateRoundAction {
        in item playerChoice : GameChoice;
        in item computerChoice : GameChoice;
        out item roundResult : RoundResult;
        satisfy needs::NEED_SYS_010;
        satisfy needs::NEED_SYS_015;
    }

    action def UpdateScoreAndCheckMatchAction {
        in item result : RoundResult;
        out item updatedScore : MatchScore;
        out item matchResult : MatchOutcome;
        satisfy needs::NEED_SYS_024;
        satisfy needs::NEED_SYS_025;
    }

    action def RenderGameScreenAction {
        in item timerVal : TimerValue;
        in item score : MatchScore;
        in item playerChoice : GameChoice;
        in item computerChoice : GameChoice;
        in item roundResult : RoundResult;
        in item matchResult : MatchOutcome;
        satisfy needs::NEED_SYS_016_1;
        satisfy needs::NEED_SYS_016_2;
        satisfy needs::NEED_SYS_016_3;
        satisfy needs::NEED_SYS_021;
        satisfy needs::NEED_SYS_022;
        satisfy needs::NEED_SYS_023;
        satisfy needs::NEED_SYS_025;
        satisfy needs::NEED_SYS_026_1;
    }

    action def ResetGameAction {
        in item resetTrigger : Boolean;
        out item initialScore : MatchScore;
        satisfy needs::NEED_SYS_026_2;
        satisfy needs::NEED_SYS_026_3;
    }

    // --- Composite Game Behavior (Activity Flow) ---
    action def GameSessionBehavior {
        action startTimer : StartCountdownAction;
        action getPlayerChoice : CapturePlayerChoiceAction;
        action getComputerChoice : GenerateComputerChoiceAction;
        action evaluateRound : EvaluateRoundAction;
        action updateScore : UpdateScoreAndCheckMatchAction;
        action renderScreen : RenderGameScreenAction;

        first startTimer;
        first getComputerChoice;

        then getPlayerChoice;
        
        then evaluateRound;
        then updateScore;
        then renderScreen;

        flow from startTimer.timerVal to getPlayerChoice.timerVal;
        flow from startTimer.timerVal to renderScreen.timerVal;
        flow from getPlayerChoice.playerChoice to evaluateRound.playerChoice;
        flow from getPlayerChoice.playerChoice to renderScreen.playerChoice;
        flow from getComputerChoice.computerChoice to evaluateRound.computerChoice;
        flow from getComputerChoice.computerChoice to renderScreen.computerChoice;
        flow from evaluateRound.roundResult to updateScore.result;
        flow from evaluateRound.roundResult to renderScreen.roundResult;
        flow from updateScore.updatedScore to renderScreen.score;
        flow from updateScore.matchResult to renderScreen.matchResult;
    }

    // --- State Machine Definition (Dynamic Coordination) ---
    state def GameCoordinatorStateMachine {
        state Initialize;
        state WaitingForPlayer;
        state Evaluating;
        state MatchEnded;

        transition initToWait
            first Initialize
            then WaitingForPlayer;

        transition waitToEval
            first WaitingForPlayer
            then Evaluating;

        transition evalToWait
            first Evaluating
            then WaitingForPlayer;

        transition evalToEnd
            first Evaluating
            then MatchEnded;

        transition endToInit
            first MatchEnded
            then Initialize;
    }
}
