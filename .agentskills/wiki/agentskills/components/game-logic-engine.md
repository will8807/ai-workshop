---
type: Component
title: Game Logic Engine
description: Core rules engine and computer choice generator for Rock-Paper-Scissors-Lizard-Spock
resource: backend/app/engine.py
tags: [rules-engine, game-logic, rock-paper-scissors-lizard-spock]
timestamp: 2026-06-25T12:00:00Z
---

# Game Logic Engine

The **Game Logic Engine** implements the exact rules of the classic *Rock-Paper-Scissors-Lizard-Spock* game. It is designed to be decoupled from the FastAPI HTTP layer to ensure clean, modular testing.

## Valid Options
The 5 valid options in the game are:
- `Rock`
- `Paper`
- `Scissors`
- `Lizard`
- `Spock`

## Game Rules (The Outcomes)
There are exactly 20 win/loss combinations and 5 possible tie combinations:
- **Scissors** cuts **Paper**
- **Paper** covers **Rock**
- **Rock** crushes **Lizard**
- **Lizard** poisons **Spock**
- **Spock** smashes **Scissors**
- **Scissors** decapitates **Lizard**
- **Lizard** eats **Paper**
- **Paper** disproves **Spock**
- **Spock** vaporizes **Rock**
- **Rock** crushes **Scissors**

## Key Functions

### `generate_computer_choice() -> str`
Uses Python's standard `random.choice` to asynchronously and securely select one of the five valid options.

### `evaluate_round(player_choice: str, computer_choice: str) -> Tuple[str, str]`
Compares the player's choice and the computer's choice. It returns a tuple of `(Outcome, Explanation)` where:
- `Outcome`: "Player Win", "Computer Win", or "Tie".
- `Explanation`: Specific text matched exactly to the BDD feature scenarios (e.g. `Spock vaporizes Rock! You win this round.`).

# Examples

```python
from app.engine import evaluate_round

outcome, explanation = evaluate_round("Spock", "Rock")
print(outcome)      # Output: "Player Win"
print(explanation)  # Output: "Spock vaporizes Rock! You win this round."
```
