import { useEffect, useState } from "react";
import type { GameChoice, GameState, MatchScore, RoundResult } from "./types";

const CHOICES: { id: GameChoice; label: string; icon: string }[] = [
	{ id: "ROCK", label: "Rock", icon: "✊" },
	{ id: "PAPER", label: "Paper", icon: "✋" },
	{ id: "SCISSORS", label: "Scissors", icon: "✌️" },
	{ id: "LIZARD", label: "Lizard", icon: "🤏" },
	{ id: "SPOCK", label: "Spock", icon: "🖖" },
];

const toBackendChoice = (fc: GameChoice): string => {
	return fc.charAt(0) + fc.slice(1).toLowerCase();
};

const toFrontendChoice = (bc: string): GameChoice => {
	return bc.toUpperCase() as GameChoice;
};

interface BackendRoundResponse {
	round_id: string;
	computer_choice: string;
	player_score: number;
	computer_score: number;
	outcome: "Player Win" | "Computer Win" | "Tie";
	explanation: string;
	status: string;
	winner: string;
}

export default function App() {
	const [gameState, setGameState] = useState<GameState>("START");
	const [matchId, setMatchId] = useState<string | null>(null);
	const [roundId, setRoundId] = useState<string | null>(null);
	const [score, setScore] = useState<MatchScore>({
		playerWins: 0,
		computerWins: 0,
	});
	const [playerChoice, setPlayerChoice] = useState<GameChoice | null>(null);
	const [computerChoice, setComputerChoice] = useState<GameChoice | null>(null);
	const [roundResult, setRoundResult] = useState<RoundResult | null>(null);
	const [countdown, setCountdown] = useState<number>(5);
	const [isEvaluating, setIsEvaluating] = useState<boolean>(false);
	const [winnerDeclaration, setWinnerDeclaration] = useState<string>("");
	const [error, setError] = useState<string | null>(null);

	// Handle 5-second countdown timer
	useEffect(() => {
		if (gameState !== "COUNTDOWN") return;

		if (countdown === 0) {
			handleEvaluateRound();
			return;
		}

		const timer = setTimeout(() => {
			setCountdown((prev) => prev - 1);
		}, 1000);

		return () => clearTimeout(timer);
	}, [countdown, gameState]);

	const handleStartGame = async () => {
		setError(null);
		try {
			// Step 1: Start match
			const startResp = await fetch("/api/match/start", { method: "POST" });
			if (!startResp.ok) throw new Error("Failed to start match");
			const matchData = (await startResp.json()) as { match_id: string };
			const mId = matchData.match_id;
			setMatchId(mId);

			setScore({ playerWins: 0, computerWins: 0 });
			setPlayerChoice(null);
			setComputerChoice(null);
			setRoundResult(null);
			setWinnerDeclaration("");
			setGameState("COUNTDOWN");
			setCountdown(5);

			// Step 2: Start first round
			const roundResp = await fetch(`/api/match/${mId}/round`, {
				method: "POST",
			});
			if (!roundResp.ok) throw new Error("Failed to start round");
			const roundData = (await roundResp.json()) as { round_id: string };
			setRoundId(roundData.round_id);
		} catch (err: unknown) {
			const errorMsg =
				err instanceof Error
					? err.message
					: "An error occurred starting the game";
			setError(errorMsg);
			setGameState("START");
		}
	};

	const handleEvaluateRound = async () => {
		if (!matchId || !roundId) {
			setError("Missing active match or round context.");
			setGameState("START");
			return;
		}

		setIsEvaluating(true);
		const choiceToSend = playerChoice || "ROCK";
		if (!playerChoice) {
			setPlayerChoice("ROCK");
		}

		try {
			const response = await fetch(
				`/api/match/${matchId}/round/${roundId}/evaluate`,
				{
					method: "POST",
					headers: {
						"Content-Type": "application/json",
					},
					body: JSON.stringify({
						player_choice: toBackendChoice(choiceToSend),
					}),
				},
			);

			if (!response.ok) {
				throw new Error(`API error: ${response.status}`);
			}

			const data = (await response.json()) as BackendRoundResponse;

			setComputerChoice(toFrontendChoice(data.computer_choice));
			setScore({
				playerWins: data.player_score,
				computerWins: data.computer_score,
			});
			setRoundResult({
				player_choice: choiceToSend,
				computer_choice: toFrontendChoice(data.computer_choice),
				outcome: data.outcome,
				explanation: data.explanation,
			});

			if (data.status === "Finished") {
				setWinnerDeclaration(data.winner);
				setGameState("MATCH_OVER");
			} else {
				setGameState("REVEAL");
			}
		} catch (err: unknown) {
			const errorMsg =
				err instanceof Error
					? err.message
					: "An error occurred during round evaluation";
			setError(errorMsg);
			setGameState("REVEAL");
		} finally {
			setIsEvaluating(false);
		}
	};

	const handleNextRound = async () => {
		if (!matchId) return;
		setError(null);
		try {
			setPlayerChoice(null);
			setComputerChoice(null);
			setRoundResult(null);
			setGameState("COUNTDOWN");
			setCountdown(5);

			const roundResp = await fetch(`/api/match/${matchId}/round`, {
				method: "POST",
			});
			if (!roundResp.ok) throw new Error("Failed to start next round");
			const roundData = (await roundResp.json()) as { round_id: string };
			setRoundId(roundData.round_id);
		} catch (err: unknown) {
			const errorMsg =
				err instanceof Error
					? err.message
					: "An error occurred starting next round";
			setError(errorMsg);
			setGameState("START");
		}
	};

	const handleResetMatch = async () => {
		if (!matchId) return;
		setError(null);
		try {
			const resetResp = await fetch(`/api/match/${matchId}/reset`, {
				method: "POST",
			});
			if (!resetResp.ok) throw new Error("Failed to reset match");

			setMatchId(null);
			setRoundId(null);
			setPlayerChoice(null);
			setComputerChoice(null);
			setRoundResult(null);
			setScore({ playerWins: 0, computerWins: 0 });
			setWinnerDeclaration("");
			setGameState("START");
		} catch (err: unknown) {
			const errorMsg =
				err instanceof Error
					? err.message
					: "An error occurred resetting the match";
			setError(errorMsg);
		}
	};

	return (
		<div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-4">
			<div className="max-w-md w-full bg-slate-900 border border-slate-800 rounded-2xl shadow-xl overflow-hidden">
				{/* Header Title */}
				<div className="bg-gradient-to-r from-blue-600 to-indigo-600 px-6 py-4 text-center">
					<h1 className="text-2xl font-bold tracking-wide">RPSLS Game</h1>
					<p className="text-sm text-blue-100 mt-1">Multi-Step Game Wizard</p>
				</div>

				{/* Scoreboard Unit */}
				<div className="px-6 py-4 bg-slate-900/50 border-b border-slate-800 flex justify-between items-center">
					<div className="text-center w-1/3">
						<span className="block text-xs uppercase tracking-wider text-slate-400">
							Player
						</span>
						<span
							className="text-3xl font-extrabold text-blue-500"
							data-testid="player-score"
						>
							{score.playerWins}
						</span>
					</div>
					<div className="text-center w-1/3 border-x border-slate-800 py-1">
						<span className="text-xs font-semibold text-slate-500 uppercase tracking-widest">
							VS
						</span>
					</div>
					<div className="text-center w-1/3">
						<span className="block text-xs uppercase tracking-wider text-slate-400">
							Computer
						</span>
						<span
							className="text-3xl font-extrabold text-red-500"
							data-testid="computer-score"
						>
							{score.computerWins}
						</span>
					</div>
				</div>

				{/* Dynamic Wizard Steps */}
				<div className="p-6 min-h-[300px] flex flex-col justify-between">
					{error && (
						<div className="mb-4 p-3 bg-red-950/50 border border-red-800 rounded-xl text-red-400 text-sm text-center">
							{error}
						</div>
					)}

					{gameState === "START" && (
						<div className="flex flex-col items-center text-center space-y-6">
							<div className="space-y-2">
								<h2 className="text-xl font-bold">Welcome to the Arena</h2>
								<p className="text-sm text-slate-400">
									Defeat the computer in a best 2 out of 3 match. Click the
									button below to start.
								</p>
							</div>
							<button
								type="button"
								onClick={handleStartGame}
								data-testid="start-game-btn"
								className="w-full py-3 bg-blue-600 hover:bg-blue-500 active:bg-blue-700 transition font-bold rounded-xl shadow-lg shadow-blue-500/20"
							>
								Start Game
							</button>
						</div>
					)}

					{gameState === "COUNTDOWN" && (
						<div className="flex flex-col items-center text-center space-y-6">
							<div className="space-y-2">
								<h2 className="text-xl font-bold">Make Your Choice</h2>
								<p className="text-sm text-slate-400">
									Select an option before the timer runs out!
								</p>
							</div>
							<div className="w-16 h-16 rounded-full bg-slate-800 border-2 border-blue-500 flex items-center justify-center text-2xl font-extrabold text-blue-400 animate-pulse">
								{countdown}
							</div>
							<p className="text-xs text-slate-500">Timer is active</p>
						</div>
					)}

					{gameState === "REVEAL" && roundResult && (
						<div className="flex flex-col items-center text-center space-y-6">
							<div className="space-y-2">
								<h2 className="text-xl font-bold">Round Result</h2>
								<span
									className={`text-lg font-bold px-3 py-1 rounded-full ${
										roundResult.outcome === "Player Win"
											? "bg-blue-950 text-blue-400 border border-blue-800"
											: roundResult.outcome === "Computer Win"
												? "bg-red-950 text-red-400 border border-red-800"
												: "bg-slate-800 text-slate-400 border border-slate-700"
									}`}
								>
									{roundResult.outcome}
								</span>
							</div>

							<div className="flex justify-around items-center w-full bg-slate-900/50 p-4 border border-slate-800 rounded-xl">
								<div className="flex flex-col items-center space-y-1">
									<span className="text-xs text-slate-400 uppercase font-semibold">
										You
									</span>
									<span className="text-3xl">
										{CHOICES.find((c) => c.id === playerChoice)?.icon}
									</span>
									<span className="text-sm font-medium text-slate-300">
										{CHOICES.find((c) => c.id === playerChoice)?.label}
									</span>
								</div>
								<span className="text-slate-600 font-extrabold text-lg">
									VS
								</span>
								<div className="flex flex-col items-center space-y-1">
									<span className="text-xs text-slate-400 uppercase font-semibold">
										Computer
									</span>
									<span className="text-3xl">
										{CHOICES.find((c) => c.id === computerChoice)?.icon}
									</span>
									<span className="text-sm font-medium text-slate-300">
										{CHOICES.find((c) => c.id === computerChoice)?.label}
									</span>
								</div>
							</div>

							<p className="text-sm text-slate-300 italic px-4 font-medium leading-relaxed">
								{roundResult.explanation}
							</p>

							{roundResult.outcome === "Tie" && (
								<p className="text-xs text-amber-500 font-semibold bg-amber-950/20 px-3 py-1 rounded-full border border-amber-900/30">
									A tie round does not increment the win count.
								</p>
							)}

							<button
								type="button"
								onClick={handleNextRound}
								data-testid="next-round-btn"
								className="w-full py-3 bg-blue-600 hover:bg-blue-500 active:bg-blue-700 transition font-bold rounded-xl shadow-lg shadow-blue-500/20"
							>
								Next Round
							</button>
						</div>
					)}

					{gameState === "MATCH_OVER" && roundResult && (
						<div className="flex flex-col items-center text-center space-y-6">
							<div className="space-y-2">
								<h2 className="text-2xl font-extrabold bg-gradient-to-r from-yellow-400 via-amber-500 to-yellow-500 bg-clip-text text-transparent uppercase tracking-wider">
									Champion Crowned!
								</h2>
								<p
									className={`text-xl font-extrabold ${winnerDeclaration.includes("Player") ? "text-blue-400" : "text-red-400"}`}
								>
									{winnerDeclaration}
								</p>
							</div>

							<div className="flex justify-around items-center w-full bg-slate-900/50 p-4 border border-slate-800 rounded-xl">
								<div className="flex flex-col items-center space-y-1">
									<span className="text-xs text-slate-400 uppercase font-semibold">
										You
									</span>
									<span className="text-3xl">
										{CHOICES.find((c) => c.id === playerChoice)?.icon}
									</span>
									<span className="text-sm font-medium text-slate-300">
										{CHOICES.find((c) => c.id === playerChoice)?.label}
									</span>
								</div>
								<span className="text-slate-600 font-extrabold text-lg">
									VS
								</span>
								<div className="flex flex-col items-center space-y-1">
									<span className="text-xs text-slate-400 uppercase font-semibold">
										Computer
									</span>
									<span className="text-3xl">
										{CHOICES.find((c) => c.id === computerChoice)?.icon}
									</span>
									<span className="text-sm font-medium text-slate-300">
										{CHOICES.find((c) => c.id === computerChoice)?.label}
									</span>
								</div>
							</div>

							<p className="text-sm text-slate-300 italic px-4 font-medium leading-relaxed">
								{roundResult.explanation}
							</p>

							<button
								type="button"
								onClick={handleResetMatch}
								data-testid="reset-game-btn"
								className="w-full py-3 bg-red-600 hover:bg-red-500 active:bg-red-700 transition font-bold rounded-xl shadow-lg shadow-red-500/20"
							>
								Reset Match
							</button>
						</div>
					)}

					{isEvaluating && (
						<div className="flex flex-col items-center justify-center space-y-4 py-8">
							<div className="w-12 h-12 border-4 border-blue-500 border-t-transparent rounded-full animate-spin" />
							<p className="text-sm text-slate-400 font-semibold animate-pulse">
								Evaluating outcome, please wait...
							</p>
						</div>
					)}

					{/* Choice Cards (Grid Section) */}
					<div className="mt-6 border-t border-slate-800/50 pt-6">
						<h3 className="text-xs font-semibold uppercase tracking-wider text-slate-500 text-center mb-4">
							Game Options
						</h3>
						<div className="grid grid-cols-5 gap-2">
							{CHOICES.map((choice) => {
								const isDisabled = gameState !== "COUNTDOWN" || isEvaluating;
								const isSelected = playerChoice === choice.id;
								return (
									<button
										key={choice.id}
										type="button"
										disabled={isDisabled}
										onClick={() => setPlayerChoice(choice.id)}
										data-testid={`choice-${choice.id.toLowerCase()}`}
										className={`flex flex-col items-center p-2 rounded-xl border transition ${
											isDisabled
												? isSelected
													? "bg-blue-600/10 border-blue-500/30 text-blue-400/50 cursor-not-allowed"
													: "bg-slate-900/30 border-slate-800/40 opacity-40 cursor-not-allowed"
												: isSelected
													? "bg-blue-600/20 border-blue-500 text-blue-400"
													: "bg-slate-800/50 border-slate-800 hover:bg-slate-800 hover:border-slate-700 text-slate-300"
										}`}
									>
										<span className="text-xl mb-1">{choice.icon}</span>
										<span className="text-[10px] font-medium">
											{choice.label}
										</span>
									</button>
								);
							})}
						</div>
					</div>
				</div>
			</div>
		</div>
	);
}
