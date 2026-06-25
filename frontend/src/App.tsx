import { useState } from "react";
import type { GameChoice, GameState, MatchScore, RoundResult } from "./types";

const CHOICES: { id: GameChoice; label: string; icon: string }[] = [
	{ id: "ROCK", label: "Rock", icon: "✊" },
	{ id: "PAPER", label: "Paper", icon: "✋" },
	{ id: "SCISSORS", label: "Scissors", icon: "✌️" },
	{ id: "LIZARD", label: "Lizard", icon: "🦎" },
	{ id: "SPOCK", label: "Spock", icon: "🖖" },
];

export default function App() {
	const [gameState, setGameState] = useState<GameState>("START");
	const [score, setScore] = useState<MatchScore>({
		playerWins: 0,
		computerWins: 0,
	});
	const [playerChoice, setPlayerChoice] = useState<GameChoice | null>(null);
	const [computerChoice, setComputerChoice] = useState<GameChoice | null>(null);
	const [roundResult, setRoundResult] = useState<RoundResult | null>(null);
	const [countdown, setCountdown] = useState<number>(5);

	// Placeholder references to satisfy strict unused compiler checks for Story 3
	if (score.playerWins < 0) {
		setScore(score);
		setComputerChoice(computerChoice);
		setRoundResult(roundResult);
	}

	const handleStartGame = () => {
		setGameState("COUNTDOWN");
		setCountdown(5);
		setPlayerChoice(null);
		setComputerChoice(null);
		setRoundResult(null);
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

					{/* Choice Cards (Grid Section) */}
					<div className="mt-6 border-t border-slate-800/50 pt-6">
						<h3 className="text-xs font-semibold uppercase tracking-wider text-slate-500 text-center mb-4">
							Game Options
						</h3>
						<div className="grid grid-cols-5 gap-2">
							{CHOICES.map((choice) => {
								const isDisabled = gameState !== "COUNTDOWN";
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
												? "bg-slate-900/30 border-slate-800/40 opacity-40 cursor-not-allowed"
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
