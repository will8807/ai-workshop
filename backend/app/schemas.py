from pydantic import BaseModel, Field


class EvaluateRoundRequest(BaseModel):
    round_id: str = Field(..., description="Unique identifier for the current round")
    player_choice: str = Field(..., description="The player's chosen move")


class EvaluateRoundResponse(BaseModel):
    round_id: str
    player_choice: str
    computer_choice: str
    outcome: str
    explanation: str


class StartRoundResponse(BaseModel):
    round_id: str
    status: str


# Stateful Match Schemas
class MatchStartResponse(BaseModel):
    match_id: str
    player_score: int
    computer_score: int
    status: str
    winner: str


class MatchEvaluateRequest(BaseModel):
    player_choice: str


class MatchEvaluateResponse(BaseModel):
    round_id: str
    player_choice: str
    computer_choice: str
    outcome: str
    explanation: str
    player_score: int
    computer_score: int
    status: str
    winner: str


class MatchResetResponse(BaseModel):
    player_score: int
    computer_score: int
    status: str
    winner: str
