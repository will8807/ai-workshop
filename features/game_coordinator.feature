Feature: Game Coordinator State Loop
  As the core orchestrator
  I want to transition the game through specific phases
  So that the state loop is synchronized and correct

  @verifyReqLog002
  Scenario: Starting the game triggers countdown and timer tick
    Given the game is on the welcoming screen
    When the player clicks the "Start Game" button
    Then the game coordinator shall transition to the countdown phase
    And the timer shall begin counting down from 5 seconds
    And the state machine shall transition from "Initialize" to "WaitingForPlayer"

  @verifyReqLog002
  Scenario: Handling timer expiration and transitioning to evaluation
    Given the game is in the countdown phase with a player selection
    When the 5-second countdown timer expires
    Then the game coordinator shall transition to the evaluation phase
    And the state machine shall transition from "WaitingForPlayer" to "Evaluating"
    And the coordinator shall trigger the rules engine to resolve the round
