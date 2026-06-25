# UX Design Document: Candidate B - Multi-Step Game Wizard

This document details the User Experience (UX) and Human-Machine Interface (HMI) design for the Rock-Paper-Scissors-Lizard-Spock web game Candidate B (Unified Monolith serving a Multi-Step Game Wizard UI).

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
  - **Step 1 Panel (Start & Pre-load)**: Displays current match scoreboard and a "Begin Round" command.
  - **Step 2 Panel (Selection)**: Displays choice cards and active countdown timer.
  - **Step 3 Panel (Resolution)**: Displays player choice vs. computer choice and round outcome, alongside round-end rules.
  - **Step 4 Panel (Match Over)**: Displays ultimate victory/defeat message and reset button.

---

## 2. Cognitive Load Management (HMI Excellence)

This design addresses cognitive engineering through a step-by-step linear narrative:

- **Visual Token Level**: Highly legible progress indicators with clear contrasting active/inactive colors. Large typography on wizard headers.
- **Atom Level**: Focus rings on cards, and disabled states for navigation buttons when criteria are not met.
- **Molecule Level (Miller's Law)**: Chunks options into individual temporal phases. Instead of seeing the score, selection options, and results simultaneously, the user is focused on exactly one task at a time.
- **Organism Level**: High organism density, as swapping views causes minor layout transitions. Layout shifts are mitigated using CSS transitions.

---

## 3. User Journey & Task Decomposition

The user task flow is decomposed across critical system states, tagged to trace back to logical and physical elements.

### Step 1: Start (Step 1 of 4)
- **System State**: Scoreboard displays `0 - 0` in a clean introduction card (`sysml:part:UnifiedGameContainer`).
- **User Action**: User clicks "Begin Round" (`sysml:usecase:StartCountdownAction`). The wizard slides to Step 2.

### Step 2: Make Selection (Step 2 of 4)
- **System State**: The 5-second countdown timer initiates (`sysml:usecase:StartCountdownAction`) and is rendered in the badge (`sysml:usecase:RenderGameScreenAction`).
- **User Action**: Player clicks a `ChoiceCard` (`sysml:usecase:CapturePlayerChoiceAction`).
- **Feedback**: Card border turns solid active blue. The "Next" button is enabled. User clicks "Next" to trigger evaluation.

### Step 3: Resolve Selection (Step 3 of 4)
- **System State**: Choice sent to FastAPI server. Backend generates choice asynchronously (`sysml:usecase:GenerateComputerChoiceAction`) and evaluates rules (`sysml:usecase:EvaluateRoundAction`).
- **Feedback**: Choices and text results are revealed on Step 3 (`sysml:usecase:RenderGameScreenAction`). A tie round display shows the tie disclaimer. Player clicks "Next" to continue.

### Step 4: End Match (Step 4 of 4)
- **System State**: If a participant has reached 2 wins (`sysml:usecase:UpdateScoreAndCheckMatchAction`), the wizard advances to Step 4.
- **Feedback**: Score status is evaluated and final Victory/Defeat screen is shown with Reset button (`sysml:usecase:RenderGameScreenAction`).

---

## 4. Alternative UI Layout Scoring

Using the `research-investigate` methodology, we score the Multi-Step Game Wizard design against the Interactive Dashboard layout.

| Dimension | Option A: Interactive Dashboard (Consolidated) | Option B: Multi-Step Wizard (Linear Steps) |
| :--- | :--- | :--- |
| **Cognitive Load** | Low. Immediate access to all status controls. Uses Miller's Law chunking. | Moderate. Step-by-step reduces options but increases navigation memory overhead. |
| **Interaction Cost** | Very Low. 1-2 clicks per round. | High. Requires separate clicks to proceed through "Steps" (Next). |
| **Real-time responsiveness** | High. Instant rendering of score, timer, and choices on a single screen. | Low. Screen switching breaks visual momentum. |
| **Usability Score** | **9 / 10** | **6 / 10** |

**Design Selection**: The Multi-Step Wizard (Option B) is scored lower (6/10) compared to the Interactive Dashboard (9/10). This is due to the high interaction cost (additional clicks required to advance screens) and the loss of real-time visual momentum.
