import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_start_round_hides_choice() -> None:
    # 1. Start a new round
    response = client.post("/api/start-round")
    assert response.status_code == 200
    data = response.json()
    assert "round_id" in data
    # Ensure computer choice is NOT returned (cheat-proof)
    assert "computer_choice" not in data
    assert "choice" not in data


def test_evaluate_round_not_found() -> None:
    # 2. Evaluate an invalid/non-existent round
    response = client.post(
        "/api/evaluate-round", json={"round_id": "non-existent-uuid", "player_choice": "Spock"}
    )
    assert response.status_code == 404
    assert response.json()["detail"] == "Round not found"


def test_evaluate_round_success() -> None:
    # 3. Start a round, then evaluate it successfully
    start_resp = client.post("/api/start-round")
    assert start_resp.status_code == 200
    round_id = start_resp.json()["round_id"]

    eval_resp = client.post(
        "/api/evaluate-round", json={"round_id": round_id, "player_choice": "Spock"}
    )
    assert eval_resp.status_code == 200
    data = eval_resp.json()
    assert data["round_id"] == round_id
    assert data["player_choice"] == "Spock"
    assert data["computer_choice"] in ["Rock", "Paper", "Scissors", "Lizard", "Spock"]
    assert data["outcome"] in ["Player Win", "Computer Win", "Tie"]
    assert "explanation" in data


def test_evaluate_round_invalid_input() -> None:
    # 4. Start a round, then evaluate with invalid player choice
    start_resp = client.post("/api/start-round")
    round_id = start_resp.json()["round_id"]

    eval_resp = client.post(
        "/api/evaluate-round", json={"round_id": round_id, "player_choice": "InvalidChoice"}
    )
    assert eval_resp.status_code == 400
    assert "Invalid choice" in eval_resp.json()["detail"]


# Stateful Match API Integration Tests
def test_stateful_match_flow() -> None:
    # 1. Start a match
    match_resp = client.post("/api/match/start")
    assert match_resp.status_code == 200
    match_data = match_resp.json()
    assert "match_id" in match_data
    assert match_data["player_score"] == 0
    assert match_data["computer_score"] == 0
    assert match_data["status"] == "Ongoing"
    assert match_data["winner"] == "None"

    match_id = match_data["match_id"]

    # 2. Start a round under that match
    round_resp = client.post(f"/api/match/{match_id}/round")
    assert round_resp.status_code == 200
    round_data = round_resp.json()
    assert "round_id" in round_data
    assert "computer_choice" not in round_data

    round_id = round_data["round_id"]

    # 3. Evaluate the round
    eval_resp = client.post(
        f"/api/match/{match_id}/round/{round_id}/evaluate", json={"player_choice": "Spock"}
    )
    assert eval_resp.status_code == 200
    eval_data = eval_resp.json()
    assert eval_data["round_id"] == round_id
    assert eval_data["player_choice"] == "Spock"
    assert eval_data["computer_choice"] in ["Rock", "Paper", "Scissors", "Lizard", "Spock"]
    assert eval_data["outcome"] in ["Player Win", "Computer Win", "Tie"]

    # Ensure scores and match status are returned
    assert "player_score" in eval_data
    assert "computer_score" in eval_data
    assert eval_data["status"] in ["Ongoing", "Finished"]
    assert "winner" in eval_data


def test_match_score_tracking_and_termination() -> None:
    # Test best-of-three (first to 2 wins) match termination flow
    match_resp = client.post("/api/match/start")
    match_id = match_resp.json()["match_id"]

    # We will simulate consecutive rounds until someone reaches 2 wins
    for _ in range(10):  # safety break to avoid infinite loop
        # Start round
        round_resp = client.post(f"/api/match/{match_id}/round")
        round_id = round_resp.json()["round_id"]

        # Evaluate
        eval_resp = client.post(
            f"/api/match/{match_id}/round/{round_id}/evaluate", json={"player_choice": "Spock"}
        )
        assert eval_resp.status_code == 200
        eval_data = eval_resp.json()

        if eval_data["status"] == "Finished":
            assert eval_data["winner"] in ["Player Wins Match", "Computer Wins Match"]
            assert max(eval_data["player_score"], eval_data["computer_score"]) == 2
            break
    else:
        pytest.fail("Match did not terminate in 10 rounds")


def test_match_reset() -> None:
    # 1. Start match
    match_resp = client.post("/api/match/start")
    match_id = match_resp.json()["match_id"]

    # 2. Reset match
    reset_resp = client.post(f"/api/match/{match_id}/reset")
    assert reset_resp.status_code == 200
    reset_data = reset_resp.json()
    assert reset_data["player_score"] == 0
    assert reset_data["computer_score"] == 0
    assert reset_data["status"] == "Ongoing"
    assert reset_data["winner"] == "None"
