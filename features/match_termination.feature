Feature: Match Termination and Score Limits
  As the scoreboard and score keeper
  I want to track the round wins and terminate the match
  So that the best-of-three condition is enforced and a champion is crowned

  @verifyReqLog005
  Scenario: Score limits and match termination (best 2 out of 3)
    Given the current score is <player_wins> wins for Player and <computer_wins> wins for Computer
    When a round is completed resulting in "<round_winner>"
    Then the score shall be updated to <new_player_wins> for Player and <new_computer_wins> for Computer
    And the match status shall be "<match_status>"
    And the ultimate winner declaration should be "<winner_declaration>"

    Examples:
      | player_wins | computer_wins | round_winner | new_player_wins | new_computer_wins | match_status | winner_declaration |
      | 0           | 0             | Player       | 1               | 0                 | Ongoing      | None               |
      | 1           | 0             | Computer     | 1               | 1                 | Ongoing      | None               |
      | 1           | 1             | Player       | 2               | 1                 | Finished     | Player Wins Match  |
      | 0           | 1             | Computer     | 0               | 2                 | Finished     | Computer Wins Match|

  @verifyReqLog005
  Scenario: Match reset clears score and starts fresh
    Given the match is finished
    When the player triggers a game reset
    Then the player's score shall be reset to 0
    And the computer's score shall be reset to 0
    And the game coordinator shall transition back to the Initialize state
