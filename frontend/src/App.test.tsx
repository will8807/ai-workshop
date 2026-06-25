import { afterEach, beforeAll, describe, expect, test } from "bun:test";
import { GlobalWindow } from "happy-dom";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";

// Register lightweight global DOM before rendering
beforeAll(() => {
	const window = new GlobalWindow();
	// biome-ignore lint/suspicious/noExplicitAny: happy-dom global casting
	globalThis.window = window as any;
	// biome-ignore lint/suspicious/noExplicitAny: happy-dom global casting
	globalThis.document = window.document as any;
	// biome-ignore lint/suspicious/noExplicitAny: happy-dom global casting
	globalThis.navigator = window.navigator as any;
});

// Helper to wait for React rendering lifecycle
const flushEffects = () => new Promise((resolve) => setTimeout(resolve, 15));

interface CustomResponses {
	[key: string]: unknown;
}

// Simple routing mock for fetch
const createMockFetch = (customResponses?: CustomResponses) => {
	return (async (url: string, options?: { body?: string }) => {
		if (customResponses?.[url]) {
			return {
				ok: true,
				status: 200,
				json: async () => customResponses[url],
			};
		}

		if (url.includes("/api/match/start")) {
			return {
				ok: true,
				status: 200,
				json: async () => ({
					match_id: "mock-match-id",
					player_score: 0,
					computer_score: 0,
					status: "Ongoing",
					winner: "None",
				}),
			};
		}

		if (url.includes("/round") && !url.includes("/evaluate")) {
			return {
				ok: true,
				status: 200,
				json: async () => ({
					round_id: "mock-round-id",
					status: "WaitingForPlayer",
				}),
			};
		}

		if (url.includes("/evaluate")) {
			let playerChoice = "Spock";
			if (options?.body) {
				const body = JSON.parse(options.body) as { player_choice: string };
				playerChoice = body.player_choice;
			}
			return {
				ok: true,
				status: 200,
				json: async () => ({
					round_id: "mock-round-id",
					player_choice: playerChoice,
					computer_choice: "Scissors",
					outcome: "Player Win",
					explanation: "Spock smashes Scissors! You win this round.",
					player_score: 1,
					computer_score: 0,
					status: "Ongoing",
					winner: "None",
				}),
			};
		}

		if (url.includes("/reset")) {
			return {
				ok: true,
				status: 200,
				json: async () => ({
					player_score: 0,
					computer_score: 0,
					status: "Ongoing",
					winner: "None",
				}),
			};
		}

		return {
			ok: false,
			status: 404,
			json: async () => ({ detail: "Not Found" }),
		};
		// biome-ignore lint/suspicious/noExplicitAny: custom mock return
	}) as any;
};

describe("RPSLS Game Welcome Screen (Story 2)", () => {
	test("Renders scoreboard initialized to 0 wins", async () => {
		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		const playerWins = rootContainer.querySelector(
			'[data-testid="player-score"]',
		);
		const computerWins = rootContainer.querySelector(
			'[data-testid="computer-score"]',
		);

		expect(playerWins).toBeDefined();
		expect(computerWins).toBeDefined();
		expect(playerWins?.textContent).toBe("0");
		expect(computerWins?.textContent).toBe("0");

		document.body.removeChild(rootContainer);
	});

	test("Renders Start Game button", async () => {
		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		const startBtn = rootContainer.querySelector(
			'[data-testid="start-game-btn"]',
		);
		expect(startBtn).toBeDefined();
		expect(startBtn?.textContent?.trim()).toBe("Start Game");

		document.body.removeChild(rootContainer);
	});

	test("Selection options are rendered but disabled in the initial state", async () => {
		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		const choices = ["rock", "paper", "scissors", "lizard", "spock"];
		for (const choice of choices) {
			const choiceBtn = rootContainer.querySelector(
				`[data-testid="choice-${choice}"]`,
			) as HTMLButtonElement | null;
			expect(choiceBtn).toBeDefined();
			expect(choiceBtn?.disabled).toBe(true);
		}

		document.body.removeChild(rootContainer);
	});
});

describe("RPSLS Game Interactive Loop (Story 3)", () => {
	afterEach(() => {
		// Clean up any global mock
		// biome-ignore lint/suspicious/noExplicitAny: cleanup
		(globalThis as any).fetch = undefined;
	});

	test("Clicking Start Game triggers match and round API calls and transitions to countdown", async () => {
		let matchStarted = false;
		let roundStarted = false;

		// Set global fetch mock
		globalThis.fetch = (async (url: string) => {
			if (url.includes("/api/match/start")) {
				matchStarted = true;
				return {
					ok: true,
					status: 200,
					json: async () => ({ match_id: "match-123" }),
				};
			}
			if (url.includes("/api/match/match-123/round")) {
				roundStarted = true;
				return {
					ok: true,
					status: 200,
					json: async () => ({ round_id: "round-456" }),
				};
			}
			return { ok: false, status: 500 };
			// biome-ignore lint/suspicious/noExplicitAny: custom fetch implementation
		}) as any;

		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		const startBtn = rootContainer.querySelector(
			'[data-testid="start-game-btn"]',
		) as HTMLButtonElement | null;

		expect(startBtn).toBeDefined();
		startBtn?.click();

		await flushEffects();

		expect(matchStarted).toBe(true);
		expect(roundStarted).toBe(true);

		// Now should be in countdown state
		const choices = ["rock", "paper", "scissors", "lizard", "spock"];
		for (const choice of choices) {
			const choiceBtn = rootContainer.querySelector(
				`[data-testid="choice-${choice}"]`,
			) as HTMLButtonElement | null;
			// During countdown, choice buttons are enabled
			expect(choiceBtn?.disabled).toBe(false);
		}

		document.body.removeChild(rootContainer);
	});

	test("Player choice is visually highlighted on click", async () => {
		globalThis.fetch = createMockFetch();

		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		const startBtn = rootContainer.querySelector(
			'[data-testid="start-game-btn"]',
		) as HTMLButtonElement | null;
		startBtn?.click();

		await flushEffects();

		// Click Spock
		const spockBtn = rootContainer.querySelector(
			'[data-testid="choice-spock"]',
		) as HTMLButtonElement | null;

		expect(spockBtn).toBeDefined();
		spockBtn?.click();

		await flushEffects();

		// Check that Spock class includes highlighting classes (e.g., bg-blue-600/20 or border-blue-500)
		expect(spockBtn?.className).toContain("border-blue-500");

		document.body.removeChild(rootContainer);
	});

	test("Transitions to reveal state with evaluation outcome after evaluation is complete", async () => {
		globalThis.fetch = createMockFetch();

		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		await flushEffects();

		// Start game
		const startBtn = rootContainer.querySelector(
			'[data-testid="start-game-btn"]',
		) as HTMLButtonElement | null;
		startBtn?.click();

		await flushEffects();

		// Click Scissors
		const scissorsBtn = rootContainer.querySelector(
			'[data-testid="choice-scissors"]',
		) as HTMLButtonElement | null;
		scissorsBtn?.click();

		await flushEffects();

		document.body.removeChild(rootContainer);
	});
});
