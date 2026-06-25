import { beforeAll, describe, expect, test } from "bun:test";
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
const flushEffects = () => new Promise((resolve) => setTimeout(resolve, 10));

describe("RPSLS Game Welcome Screen (Story 2)", () => {
	test("Renders scoreboard initialized to 0 wins", async () => {
		// Create container
		const rootContainer = document.createElement("div");
		document.body.appendChild(rootContainer);

		// Render App
		const root = ReactDOM.createRoot(rootContainer);
		root.render(<App />);

		// Wait for React to flush changes
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

		// Cleanup
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
