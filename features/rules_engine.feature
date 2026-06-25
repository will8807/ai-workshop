Feature: Classic Rules Engine Evaluation
  As the core game logic engine
  I want to evaluate the outcome of player and computer choices
  So that the classic Rock-Paper-Scissors-Lizard-Spock rules are accurately enforced

  @verifyReqLog004
  Scenario: Classic rules evaluation for Rock-Paper-Scissors-Lizard-Spock
    Given the player selects "<player_choice>"
    And the computer selects "<computer_choice>"
    When the round is evaluated
    Then the result of the round shall be "<round_outcome>"
    And the explanation message shall be "<explanation>"

    Examples:
      | player_choice | computer_choice | round_outcome | explanation                                |
      | Scissors      | Paper           | Player Win    | Scissors cuts Paper! You win this round.   |
      | Paper         | Rock            | Player Win    | Paper covers Rock! You win this round.     |
      | Rock          | Lizard          | Player Win    | Rock crushes Lizard! You win this round.   |
      | Lizard        | Spock           | Player Win    | Lizard poisons Spock! You win this round. |
      | Spock         | Scissors        | Player Win    | Spock smashes Scissors! You win this round.|
      | Scissors      | Lizard          | Player Win    | Scissors decapitates Lizard! You win this round. |
      | Lizard        | Paper           | Player Win    | Lizard eats Paper! You win this round.     |
      | Paper         | Spock           | Player Win    | Paper disproves Spock! You win this round. |
      | Spock         | Rock            | Player Win    | Spock vaporizes Rock! You win this round.  |
      | Rock          | Scissors        | Player Win    | Rock crushes Scissors! You win this round. |
      | Paper         | Scissors        | Computer Win  | Scissors cuts Paper! You lose this round.   |
      | Rock          | Paper           | Computer Win  | Paper covers Rock! You lose this round.     |
      | Lizard        | Rock            | Computer Win  | Rock crushes Lizard! You lose this round.   |
      | Spock         | Lizard          | Computer Win  | Lizard poisons Spock! You lose this round. |
      | Scissors      | Spock           | Computer Win  | Spock smashes Scissors! You lose this round.|
      | Lizard        | Scissors        | Computer Win  | Scissors decapitates Lizard! You lose this round. |
      | Paper         | Lizard          | Computer Win  | Lizard eats Paper! You lose this round.     |
      | Spock         | Paper           | Computer Win  | Paper disproves Spock! You lose this round. |
      | Rock          | Spock           | Computer Win  | Spock vaporizes Rock! You lose this round.  |
      | Scissors      | Rock            | Computer Win  | Rock crushes Scissors! You lose this round. |
      | Rock          | Rock            | Tie           | It is a tie round! This round does not count. |
      | Spock         | Spock           | Tie           | It is a tie round! This round does not count. |
