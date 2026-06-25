export type GameChoice = "ROCK" | "PAPER" | "SCISSORS" | "LIZARD" | "SPOCK";

export type GameState =
	| "START"
	| "COUNTDOWN"
	| "REVEAL"
	| "RESET"
	| "MATCH_OVER";

export interface RoundResult {
	player_choice: GameChoice;
	computer_choice: GameChoice;
	outcome: "Player Win" | "Computer Win" | "Tie";
	explanation: string;
}

export interface MatchScore {
	playerWins: number;
	computerWins: number;
}
