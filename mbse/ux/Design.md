# UX Design Document: Multi-Step Game Wizard (Selected Baseline)

This document details the User Experience (UX) and Human-Machine Interface (HMI) design for the Rock-Paper-Scissors-Lizard-Spock web game, implementing the selected **Unified Monolith** serving a **Multi-Step Game Wizard UI**.

The goal of this design is to maximize linear predictability and reduce visual density by chunking the game loop into a sequence of distinct, step-by-step wizard screens.

---

## 1. Structural Layout (Atomic Design Tiers)

We structure the user interface elements following the Atomic Design methodology to guarantee robust layout consistency.

### Atoms (Visual Primitives)
- **`StepIndicator`**: Bullet/dot styled step nodes indicating progress (Step 1, Step 2, Step 3).
- **`ChoiceCard`**: Large, interactive clickable cards containing choice iconography.
- **`NavButton`**: "Next" or "Back" buttons used for navigating between wizard steps.
- **`TimerBadge`**: Small round countdown indicator.

### Molecules (Cohesive Groupings)
- **`StepProgressTracker`**: Horizontally aligned list of `StepIndicator` elements showing the active, completed, and upcoming steps.
- **`WizardNavigation`**: Side-by-side positioning of "Back" and "Next" buttons with smart disabling rules (e.g., "Next" is disabled until a choice is selected).

### Organisms (Consolidated Components)
- **`GameWizardContainer`**: The primary parent card that dynamically wraps the wizard steps. It swaps child step panels in/out depending on the current wizard state.
  - **Step 1: Welcome Screen**: A welcoming screen displaying the starting scoreboard and the "Start Game" control button.
  - **Step 2: Selection & Countdown**: Initiates a 5-second countdown timer, prompting the user to click one of the 5 options (Rock, Paper, Scissors, Lizard, Spock). Visually highlights the player's choice.
  - **Step 3: Reveal & Display**: Simultaneously displays the player's choice and the computer's choice on the same refresh cycle, presenting the round-evaluation outcome text.
  - **Step 4: Victory/Defeat & Reset**: Declares the match winner (best 2 out of 3) and displays a "Play Again" reset button.

---

## 2. User Journeys & Task Decomposition

Decompose user tasks across critical system states. Map each interactive step directly to its matching Atomic component level:
1. **Trigger**: Click "Start Game".
2. **Action Series (Atomic Decomposed Flow)**:
   - *System State Presented*: The active countdown ticks from 5 seconds down to 0, showing active choice buttons (Atoms).
   - *User Action*: Player clicks one of the buttons (e.g., Spock) to highlight selection.
3. **Completion Gate**: At T=0, transition to Step 3. Display the round outcomes.

---

## 3. Alternative UI Layout Scoring

Using the `research-investigate` methodology, we score the Multi-Step Game Wizard design against the Interactive Dashboard layout.

| Dimension | Option A: Interactive Dashboard (Consolidated) | Option B: Multi-Step Wizard (Linear Steps) |
| :--- | :--- | :--- |
| **Cognitive Load** | Low. Immediate access to all status controls. Uses Miller's Law chunking. | Moderate. Step-by-step reduces options but increases navigation memory overhead. |
| **Interaction Cost** | Very Low. 1-2 clicks per round. | High. Requires separate clicks to proceed through "Steps" (Next). |
| **Real-time responsiveness** | High. Instant rendering of score, timer, and choices on a single screen. | Low. Screen switching breaks visual momentum. |
| **Usability Score** | **9 / 10** | **6 / 10** |

**Design Selection**: The **Multi-Step Wizard (Option B)** has been selected for implementation by the System Architect to optimize local serving of compiled bundles and minimize single-page structural density.
