import random

VALID_CHOICES = ["Rock", "Paper", "Scissors", "Lizard", "Spock"]

# Win relations mapping (Winner, Loser) -> Explanation template
BEATS = {
    ("Scissors", "Paper"): "Scissors cuts Paper! You win this round.",
    ("Paper", "Rock"): "Paper covers Rock! You win this round.",
    ("Rock", "Lizard"): "Rock crushes Lizard! You win this round.",
    ("Lizard", "Spock"): "Lizard poisons Spock! You win this round.",
    ("Spock", "Scissors"): "Spock smashes Scissors! You win this round.",
    ("Scissors", "Lizard"): "Scissors decapitates Lizard! You win this round.",
    ("Lizard", "Paper"): "Lizard eats Paper! You win this round.",
    ("Paper", "Spock"): "Paper disproves Spock! You win this round.",
    ("Spock", "Rock"): "Spock vaporizes Rock! You win this round.",
    ("Rock", "Scissors"): "Rock crushes Scissors! You win this round.",
}


def generate_computer_choice() -> str:
    """Generates a random valid selection for the computer choice."""
    return random.choice(VALID_CHOICES)


def evaluate_round(player_choice: str, computer_choice: str) -> tuple[str, str]:
    """Evaluates the round outcomes based on the classic Rock-Paper-Scissors-Lizard-Spock rules.

    Returns:
        Tuple[str, str]: (Outcome, Explanation)
    """
    if player_choice not in VALID_CHOICES:
        raise ValueError(f"Invalid choice: {player_choice}")
    if computer_choice not in VALID_CHOICES:
        raise ValueError(f"Invalid choice: {computer_choice}")

    if player_choice == computer_choice:
        return "Tie", "It is a tie round! This round does not count."

    if (player_choice, computer_choice) in BEATS:
        return "Player Win", BEATS[(player_choice, computer_choice)]

    if (computer_choice, player_choice) in BEATS:
        base_explanation = BEATS[(computer_choice, player_choice)]
        # Replace "You win" with "You lose" for computer wins
        explanation = base_explanation.replace("You win this round.", "You lose this round.")
        return "Computer Win", explanation

    raise ValueError("Invalid state: rule combination not handled.")
