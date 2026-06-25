# UX Design Document: Candidate A - Interactive Dashboard

This document details the User Experience (UX) and Human-Machine Interface (HMI) design for the Rock-Paper-Scissors-Lizard-Spock web game Candidate A (Dual-Container Pod with Interactive Dashboard). 

The goal of this design is to minimize visual and cognitive load through a high-density, real-time, consolidated control center (Interactive Dashboard) where all feedback and state transitions are displayed in a single unified view.

---

## 1. Structural Layout (Atomic Design Tiers)

We structure the user interface elements following the Atomic Design methodology to ensure consistency, reusability, and clean state separation.

### Atoms (Visual Primitives)
- **`FeatherIcon`**: Small SVG icon representations for choices (Rock, Paper, Scissors, Lizard, Spock).
- **`RoundTimerText`**: High-contrast, monospace countdown timer text (e.g., `05s`).
- **`ActionButton`**: Minimalist, flat, responsive primary/secondary control buttons with uniform padding and focus ring styles.
- **`ScoreIndicator`**: Numeric counters displaying wins for both Player and Computer.

### Molecules (Cohesive Groupings)
- **`ChoiceSelector`**: A group of five clickable buttons containing the `FeatherIcon` choices, mapping directly to physical actions for selection.
- **`Scoreboard`**: Side-by-side player and computer score counters with clean labeling.
- **`ControlPanel`**: Grouped start/reset action buttons that transition the active game state.

### Organisms (Consolidated Components)
- **`InteractiveDashboard`**: The primary dashboard container that organizes the Scoreboard, Countdown Timer, ChoiceSelector, and Round Results into a card-based grid layout. It minimizes page layout shifts and guarantees that all key metrics are simultaneously visible.

---

## 2. Cognitive Load Management (HMI Excellence)

This design applies strict principles of cognitive engineering to minimize mental friction:

- **Visual Token Level**: The dashboard uses a dark color palette with absolute contrast compliance (WCAG 2.1 AA). Consistent typography (Inter for body text, JetBrains Mono for the timer) avoids reading fatigue.
- **Atom Level**: Action buttons have precise hover and focus states, but avoid distracting transitions.
- **Molecule Level (Miller's Law)**: Information is grouped into three distinct chunks: Scoreboard (Past), Choice Selector (Present), and Timer/Results (Immediate action).
- **Organism Level**: All content fits onto a single screen with no vertical scrolling required. Active feedback occurs on the same refresh cycle (`sysml:usecase:RenderGameScreenAction`).

---

## 3. User Journey & Task Decomposition

The user task flow is decomposed below across critical system states, tagged to trace back to logical and physical elements.

### Step 1: Trigger
- **System State**: The game is in the initialized state. Scoreboard displays `0 - 0` (`sysml:part:BunFrontendContainer`).
- **User Action**: User clicks the "Start Match" button (`sysml:usecase:StartCountdownAction`).

### Step 2: Selection Loop (Active Countdown)
- **System State**: The 5-second countdown timer initiates (`sysml:usecase:StartCountdownAction`), counting down dynamically (`sysml:usecase:RenderGameScreenAction`).
- **User Action**: The player selects one of the 5 game options inside the `ChoiceSelector` (`sysml:usecase:CapturePlayerChoiceAction`).
- **Feedback**: The selected choice is visually highlighted with a high-contrast border. The outcome is *not* displayed yet to prevent client-side manipulation.

### Step 3: Round Evaluation
- **System State**: Countdown expires. The front-end transmits the selection to the FastAPI backend (`sysml:part:UvBackendContainer`). The backend resolves the computer choice asynchronously (`sysml:usecase:GenerateComputerChoiceAction`) and evaluates rules (`sysml:usecase:EvaluateRoundAction`).
- **Feedback**: Both the player and computer choices are revealed on the same refresh cycle (`sysml:usecase:RenderGameScreenAction`). A clear text outcome (e.g., "Spock smashes Scissors! Player wins.") is rendered with updated score metrics.

### Step 4: Completion Gate
- **System State**: If a participant reaches 2 wins, the coordinator triggers a final match outcome.
- **Feedback**: A high-visibility modal or screen overlay displays "Victory!" or "Defeat" along with a Reset button (`sysml:usecase:RenderGameScreenAction`).

---

## 4. Alternative UI Layout Scoring

Using the `research-investigate` methodology, we score the Interactive Dashboard design against a multi-step game wizard layout.

| Dimension | Option A: Interactive Dashboard (Consolidated) | Option B: Multi-Step Wizard (Linear Steps) |
| :--- | :--- | :--- |
| **Cognitive Load** | Low. Immediate access to all status controls. Uses Miller's Law chunking. | Moderate. Step-by-step reduces options but increases navigation memory overhead. |
| **Interaction Cost** | Very Low. 1-2 clicks per round. | High. Requires separate clicks to proceed through "Steps" (Next). |
| **Real-time responsiveness** | High. Instant rendering of score, timer, and choices on a single screen. | Low. Screen switching breaks visual momentum. |
| **Usability Score** | **9 / 10** | **6 / 10** |

**Design Selection**: Option A (Interactive Dashboard) is highly recommended for Candidate A, as it provides seamless real-time interaction, reduces clicks, and maps cleanly to the physical dual-container architecture.
