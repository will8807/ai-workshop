import pytest

from app.engine import VALID_CHOICES, evaluate_round, generate_computer_choice


# Test computer choice generation
def test_generate_computer_choice_randomness() -> None:
    # Test that the computer choice is always one of the five valid options
    choices = [generate_computer_choice() for _ in range(100)]
    for choice in choices:
        assert choice in VALID_CHOICES

    # Verify that we generate multiple distinct choices (not hardcoded to just one option)
    unique_choices = set(choices)
    assert len(unique_choices) > 1


# Test all 20 outcomes and ties from features/rules_engine.feature
@pytest.mark.parametrize(
    "player_choice, computer_choice, expected_outcome, expected_explanation",
    [
        # Player Wins
        ("Scissors", "Paper", "Player Win", "Scissors cuts Paper! You win this round."),
        ("Paper", "Rock", "Player Win", "Paper covers Rock! You win this round."),
        ("Rock", "Lizard", "Player Win", "Rock crushes Lizard! You win this round."),
        ("Lizard", "Spock", "Player Win", "Lizard poisons Spock! You win this round."),
        ("Spock", "Scissors", "Player Win", "Spock smashes Scissors! You win this round."),
        ("Scissors", "Lizard", "Player Win", "Scissors decapitates Lizard! You win this round."),
        ("Lizard", "Paper", "Player Win", "Lizard eats Paper! You win this round."),
        ("Paper", "Spock", "Player Win", "Paper disproves Spock! You win this round."),
        ("Spock", "Rock", "Player Win", "Spock vaporizes Rock! You win this round."),
        ("Rock", "Scissors", "Player Win", "Rock crushes Scissors! You win this round."),
        # Computer Wins
        ("Paper", "Scissors", "Computer Win", "Scissors cuts Paper! You lose this round."),
        ("Rock", "Paper", "Computer Win", "Paper covers Rock! You lose this round."),
        ("Lizard", "Rock", "Computer Win", "Rock crushes Lizard! You lose this round."),
        ("Spock", "Lizard", "Computer Win", "Lizard poisons Spock! You lose this round."),
        ("Scissors", "Spock", "Computer Win", "Spock smashes Scissors! You lose this round."),
        ("Lizard", "Scissors", "Computer Win", "Scissors decapitates Lizard! You lose this round."),
        ("Paper", "Lizard", "Computer Win", "Lizard eats Paper! You lose this round."),
        ("Spock", "Paper", "Computer Win", "Paper disproves Spock! You lose this round."),
        ("Rock", "Spock", "Computer Win", "Spock vaporizes Rock! You lose this round."),
        ("Scissors", "Rock", "Computer Win", "Rock crushes Scissors! You lose this round."),
        # Ties
        ("Rock", "Rock", "Tie", "It is a tie round! This round does not count."),
        ("Spock", "Spock", "Tie", "It is a tie round! This round does not count."),
        ("Scissors", "Scissors", "Tie", "It is a tie round! This round does not count."),
        ("Paper", "Paper", "Tie", "It is a tie round! This round does not count."),
        ("Lizard", "Lizard", "Tie", "It is a tie round! This round does not count."),
    ],
)
def test_evaluate_round_rules(
    player_choice: str, computer_choice: str, expected_outcome: str, expected_explanation: str
) -> None:
    outcome, explanation = evaluate_round(player_choice, computer_choice)
    assert outcome == expected_outcome
    assert explanation == expected_explanation


def test_evaluate_round_invalid_choices() -> None:
    with pytest.raises(ValueError, match="Invalid choice"):
        evaluate_round("Invalid", "Rock")
    with pytest.raises(ValueError, match="Invalid choice"):
        evaluate_round("Rock", "Invalid")
