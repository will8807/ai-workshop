Feature: UI Presentation and Scoreboard
  As a player
  I want a clear, interactive user interface
  So that I can see my score, the countdown, and the final results

  @verifyReqLog001
  Scenario: Initial game screen presentation and scoreboard rendering
    Given the game is in the initial state
    Then the user interface shall display the player's score as 0
    And the user interface shall display the computer's score as 0
    And the user interface shall present a "Start Game" control element
    And the selection options should not be interactive

  @verifyReqLog001
  Scenario: Visual countdown and selection highlights during active round
    Given the game is in the countdown state
    Then the user interface shall render a countdown timer starting at 5 seconds
    And the user interface shall enable the selection options for "Rock", "Paper", "Scissors", "Lizard", and "Spock"
    When the player selects "Spock"
    Then the "Spock" option shall be visually highlighted
    And the game outcome should not be displayed yet

  @verifyReqLog001
  Scenario: Simultaneous choice reveal and round outcome display
    Given the game is in the reveal state
    And the player selected "Scissors"
    And the computer selected "Paper"
    Then the user interface shall simultaneously display the player choice "Scissors" and the computer choice "Paper"
    And the user interface shall display the evaluation outcome text "Scissors cuts Paper! You win this round."
