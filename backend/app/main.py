import os
import uuid
from typing import TypedDict

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.engine import evaluate_round, generate_computer_choice
from app.schemas import (
    EvaluateRoundRequest,
    EvaluateRoundResponse,
    MatchEvaluateRequest,
    MatchEvaluateResponse,
    MatchResetResponse,
    MatchStartResponse,
    StartRoundResponse,
)

app = FastAPI(
    title="Rock-Paper-Scissors-Lizard-Spock Backend",
    description="Core game coordinator and rules engine logic.",
    version="0.1.0",
)

# Enable CORS for local development when running separate ports
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-memory database structures
# Stores: round_id -> computer_choice
rounds_db: dict[str, str] = {}


class MatchState(TypedDict):
    player_score: int
    computer_score: int
    status: str
    winner: str
    active_rounds: dict[str, str]  # round_id -> computer_choice


# Stores: match_id -> MatchState
matches_db: dict[str, MatchState] = {}


@app.post("/api/start-round", response_model=StartRoundResponse)
def start_round() -> StartRoundResponse:
    """Initiates a new round by generating a hidden computer choice."""
    round_id = str(uuid.uuid4())
    # Asynchronously select the computer's choice and hide it from the client
    computer_choice = generate_computer_choice()
    rounds_db[round_id] = computer_choice
    return StartRoundResponse(round_id=round_id, status="WaitingForPlayer")


@app.post("/api/evaluate-round", response_model=EvaluateRoundResponse)
def evaluate_round_endpoint(request: EvaluateRoundRequest) -> EvaluateRoundResponse:
    """Evaluates the round using player selection and the stored hidden computer choice."""
    round_id = request.round_id
    player_choice = request.player_choice

    if round_id not in rounds_db:
        raise HTTPException(status_code=404, detail="Round not found")

    computer_choice = rounds_db[round_id]

    try:
        outcome, explanation = evaluate_round(player_choice, computer_choice)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e

    # Clean up the round from our active database once evaluated
    del rounds_db[round_id]

    return EvaluateRoundResponse(
        round_id=round_id,
        player_choice=player_choice,
        computer_choice=computer_choice,
        outcome=outcome,
        explanation=explanation,
    )


# --- Stateful Match API Endpoints ---


@app.post("/api/match/start", response_model=MatchStartResponse)
def start_match() -> MatchStartResponse:
    """Starts a new stateful best-of-three match."""
    match_id = str(uuid.uuid4())
    matches_db[match_id] = {
        "player_score": 0,
        "computer_score": 0,
        "status": "Ongoing",
        "winner": "None",
        "active_rounds": {},
    }
    return MatchStartResponse(
        match_id=match_id,
        player_score=0,
        computer_score=0,
        status="Ongoing",
        winner="None",
    )


@app.post("/api/match/{match_id}/round", response_model=StartRoundResponse)
def start_match_round(match_id: str) -> StartRoundResponse:
    """Starts a countdown and round within a specific active match."""
    if match_id not in matches_db:
        raise HTTPException(status_code=404, detail="Match not found")

    match = matches_db[match_id]
    if match["status"] == "Finished":
        raise HTTPException(status_code=400, detail="Match is already finished")

    round_id = str(uuid.uuid4())
    computer_choice = generate_computer_choice()
    match["active_rounds"][round_id] = computer_choice

    return StartRoundResponse(round_id=round_id, status="WaitingForPlayer")


@app.post("/api/match/{match_id}/round/{round_id}/evaluate", response_model=MatchEvaluateResponse)
def evaluate_match_round(
    match_id: str,
    round_id: str,
    request: MatchEvaluateRequest,
) -> MatchEvaluateResponse:
    """Evaluates a round within a match, updates cumulative scores, and checks match termination."""
    if match_id not in matches_db:
        raise HTTPException(status_code=404, detail="Match not found")

    match = matches_db[match_id]
    if match["status"] == "Finished":
        raise HTTPException(status_code=400, detail="Match is already finished")

    if round_id not in match["active_rounds"]:
        raise HTTPException(status_code=404, detail="Round not found in match")

    computer_choice = match["active_rounds"][round_id]
    player_choice = request.player_choice

    try:
        outcome, explanation = evaluate_round(player_choice, computer_choice)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e)) from e

    # Update Match Scores based on the outcome
    if outcome == "Player Win":
        match["player_score"] += 1
    elif outcome == "Computer Win":
        match["computer_score"] += 1

    # Check for best-of-three termination (first to 2 wins)
    if match["player_score"] == 2:
        match["status"] = "Finished"
        match["winner"] = "Player Wins Match"
    elif match["computer_score"] == 2:
        match["status"] = "Finished"
        match["winner"] = "Computer Wins Match"

    # Clean up evaluated round
    del match["active_rounds"][round_id]

    return MatchEvaluateResponse(
        round_id=round_id,
        player_choice=player_choice,
        computer_choice=computer_choice,
        outcome=outcome,
        explanation=explanation,
        player_score=match["player_score"],
        computer_score=match["computer_score"],
        status=match["status"],
        winner=match["winner"],
    )


@app.post("/api/match/{match_id}/reset", response_model=MatchResetResponse)
def reset_match(match_id: str) -> MatchResetResponse:
    """Resets the state of a match to begin a brand new session."""
    if match_id not in matches_db:
        raise HTTPException(status_code=404, detail="Match not found")

    match = matches_db[match_id]
    match["player_score"] = 0
    match["computer_score"] = 0
    match["status"] = "Ongoing"
    match["winner"] = "None"
    match["active_rounds"].clear()

    return MatchResetResponse(
        player_score=0,
        computer_score=0,
        status="Ongoing",
        winner="None",
    )


# --- Static Frontend Serving ---

# Try to conditionally mount static compiled assets if they exist
frontend_dist_path = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "..", "frontend", "dist")
)


@app.get("/api/health")
def health_check() -> dict[str, str]:
    """Health check endpoint."""
    return {"status": "ok"}


# API root fallback if static files are not compiled/mounted
@app.get("/")
def root_route() -> dict[str, str]:
    """Root route description fallback."""
    return {"message": "Rock-Paper-Scissors-Lizard-Spock FastAPI Game Server"}


if os.path.isdir(frontend_dist_path):
    app.mount("/", StaticFiles(directory=frontend_dist_path, html=True), name="static")
