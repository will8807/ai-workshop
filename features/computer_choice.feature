Feature: Asynchronous Computer Choice Generation
  As the backend game server
  I want to generate a computer choice asynchronously
  So that the choice is randomized, cheat-proof, and completed during the countdown

  @verifyReqLog003
  Scenario: Computer choice generated asynchronously on countdown initiation
    Given the player initiates a new round
    When the countdown timer starts ticking
    Then the backend random number generator shall asynchronously select one of the five valid game options
    And the selection must be completed before the countdown timer reaches 0
    And the selected computer choice must remain hidden from the client until the reveal phase
