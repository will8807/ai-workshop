---
type: Component
title: Backend Core
description: FastAPI backend server coordinating state and routing for Rock-Paper-Scissors-Lizard-Spock
resource: backend/app/main.py
tags: [fastapi, python, backend]
timestamp: 2026-06-25T12:00:00Z
---

# Backend Core

The **Backend Core** is built with FastAPI and runs under `uv`. It provides the API endpoints for starting game rounds, evaluating the player's choices against the computer's choices, and coordinating stateful best-of-three matches.

## Key APIs

### 1. Stateless Game Logic Endpoints

#### POST `/api/start-round`
Starts a new game round and generates a random computer choice. The choice is stored in memory and kept hidden from the client to prevent cheating.
- **Response**: `StartRoundResponse` containing `round_id` and `status` ("WaitingForPlayer").

#### POST `/api/evaluate-round`
Evaluates the round with player selection and the stored hidden computer choice.
- **Request**: `EvaluateRoundRequest` containing `round_id` and `player_choice`.
- **Response**: `EvaluateRoundResponse` containing `round_id`, `player_choice`, `computer_choice`, `outcome`, and `explanation`.

### 2. Stateful Match Endpoints

#### POST `/api/match/start`
Starts a new stateful best-of-three match session.
- **Response**: `MatchStartResponse` containing `match_id`, scores, status ("Ongoing"), and winner ("None").

#### POST `/api/match/{match_id}/round`
Starts a countdown and round within a specific active match.
- **Response**: `StartRoundResponse` containing `round_id` and `status` ("WaitingForPlayer").

#### POST `/api/match/{match_id}/round/{round_id}/evaluate`
Evaluates a round within a match, updates cumulative scores, and checks match termination.
- **Request**: `MatchEvaluateRequest` containing `player_choice`.
- **Response**: `MatchEvaluateResponse` containing round outcome, updated scores, status ("Ongoing" or "Finished"), and match winner ("None", "Player Wins Match", "Computer Wins Match").

#### POST `/api/match/{match_id}/reset`
Resets the state of a match to begin a brand new session.
- **Response**: `MatchResetResponse` with scores reset to 0.

# Schema

| Field | Type | Description |
|---|---|---|
| `round_id` | `str` | Unique identifier for the game round |
| `player_choice` | `str` | Move selected by the player ("Rock", "Paper", "Scissors", "Lizard", "Spock") |
| `computer_choice` | `str` | Move randomly generated for the computer |
| `outcome` | `str` | Result of evaluation ("Player Win", "Computer Win", "Tie") |
| `explanation` | `str` | Specific text explaining why the winner won |

# Examples

```python
import httpx

# Example API round evaluation call
client = httpx.Client()
response = client.post(
    "http://localhost:8000/api/evaluate-round",
    json={"round_id": "8b51d6df-85f8-45a8-bd2e-504689845583", "player_choice": "Spock"}
)
print(response.json())
```
