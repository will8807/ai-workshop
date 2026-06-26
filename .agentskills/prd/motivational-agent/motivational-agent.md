# Product Requirements Document (PRD)

## Title: PRD-0001: Humorous Motivational Pick-Me-Up Agent
**Date**: 2026-06-26  

---

## 1. Executive Summary & Objective
The objective of this feature is to introduce a dedicated, humorous, and highly interactive motivational subagent (`motivational-coach`) within Opencode. This agent will provide a playful "pick-me-up" to users feeling down, anxious, or unmotivated. By offering a lightweight, CLI-based interactive menu with exaggerated hype, absurd reframing of minor worries, and a comical "vent and shredder" option, this agent aims to break negative thought loops and bring a smile back to the user's face.

## 2. Problem Statement & User Story
* **Problem**: Software development, engineering, and daily tasks can be highly stressful and overwhelming. When engineers or users experience failures, compiler errors, or general "blue" moods, they lack a quick, localized, and lighthearted emotional release mechanism inside their workspace.
* **User Story**: As an Opencode user, I want to easily run a motivational subagent that presents a playful CLI menu so that I can laugh at my worries, receive exaggerated and witty compliments, and return to my tasks with a refreshed perspective.

## 3. High-Level Requirements (CAP_SYS)
* **CAP_SYS_MOT_001**: The agent shall provide a structured, humorous, and interactive CLI experience when invoked.
* **CAP_SYS_MOT_002**: The system shall support multiple humor-focused modules: Hype-Me-Up, Absurdist Reframer, and Vent & Shred.

## 4. Detailed Functional Requirements (EARS)
* **REQ_MOT_001 (Interactive Menu)**: WHEN the `motivational-coach` agent is launched, the system shall present a clear text-based interactive terminal menu allowing the user to select among the three core modules or exit.
* **REQ_MOT_002 (Hype-Me-Up)**: WHEN the user selects the "Hype-Me-Up" menu option, the system shall randomly generate and display a witty, highly exaggerated, and comically descriptive positive affirmation (e.g., "majestic space-sloth riding a unicorn").
* **REQ_MOT_003 (Absurdist Reframer)**: WHEN the user selects the "Absurdist Reframer" menu option, the system shall prompt the user to input a specific worry and shall return an absurdly dramatic or comical reframing of that worry.
* **REQ_MOT_004 (Vent & Shred)**: WHEN the user selects the "Vent & Shred" menu option, the system shall allow the user to type an open-ended rant and shall simulate shredding the text, accompanied by a humorous shredder sound effect (represented via text-art/animations) and a funny concluding remark.
* **REQ_MOT_005 (Exit)**: WHEN the user selects the "Exit" menu option, the system shall display a final warm, witty sign-off message and terminate.

## 5. MBSE Baseline & Integration Analysis
* **Added Parts/Systems**:
  - Adds a new subagent configuration: `.opencode/agents/motivational-coach.md`.
  - Adds a new command file: `.opencode/commands/motivate.md` to enable calling the agent easily via the `/motivate` command.
  - Adds a runnable python script/module under `.opencode/scripts/motivational_coach.py` that implements the actual interactive terminal loop and humor algorithms.
* **Modified Models**:
  - This subagent integrates with our agentic system as a specialized task runner. It doesn't modify the core backend database schemas but introduces a new helper script.
* **Blast Radius & Impact**:
  - None on existing services or APIs. This is a completely isolated sandboxed CLI utility.

## 6. Non-Functional & Security Requirements
* **Zero-Visibility Secret Guardrails**: The input buffers of the agent must never log any user-provided inputs to disk or external services, ensuring full privacy of personal vents.
* **Platform Agnosticism**: The script must run natively via standard Python 3.x with zero external third-party dependencies (using standard library only like `sys`, `random`, `time`, etc.).
* **Frictionless and Fast**: Responses must be generated instantly without API calls, using pre-defined local prompt/template catalogs and randomizers to remain offline-capable and extremely fast.

## 7. Verification & Acceptance Criteria (Test Cases)
* **verifyInteractiveMenu**: Run the command line script and verify that the 4-choice menu is printed and responds correctly to inputs `1`, `2`, `3`, and `4`.
* **verifyHypeMeUp**: Verify that selecting `1` generates a unique funny compliment each time from a pool of at least 10 creative combinations.
* **verifyAbsurdistReframer**: Verify that selecting `2` accepts an arbitrary worry string and wraps it in a comically grand scenario.
* **verifyVentAndShred**: Verify that selecting `3` processes user text, renders a text-based ASCII shredder animation, and returns a humorous closing comment.

## 8. Detailed Implementation Plan & Proposed Issues
* **Proposed Issue 1**:
  - **Title**: Create the Motivational Coach agent definition file
  - **Type**: AFK
  - **What to build**: Create `.opencode/agents/motivational-coach.md` using the subagent template, establishing clear steps, guidelines, and negative constraints.
  - **Acceptance criteria**: File exists, conforms to the standard subagent template structure, and passes lints.
* **Proposed Issue 2**:
  - **Title**: Implement the core interactive python script
  - **Type**: AFK
  - **What to build**: Implement `.opencode/scripts/motivational_coach.py` containing the CLI loop, ASCII animations, a rich pool of hype phrases, absurdist reframer logic, and the shredder text animation.
  - **Acceptance criteria**: Script executes without errors, is dependency-free, and handles all menu interactions smoothly.
* **Proposed Issue 3**:
  - **Title**: Create the /motivate trigger command file
  - **Type**: AFK
  - **What to build**: Implement `.opencode/commands/motivate.md` that registers the `/motivate` command, triggering the `motivational-coach` agent.
  - **Acceptance criteria**: Command file exists, has correct frontmatter, and describes the trigger mechanism.

## 9. Workflow State & Checklist of Activities
* **Current Workflow State**: **Phase 4: User Approval Gate**

### Checklist of Activities:
- [x] Phase 1: Problem & Domain Refinement (Compile PRD, checkout branch, open Draft PR)
- [x] Phase 2: Architectural Modeling & UX/UI Definition (Model updates in /mbse, validate MBSE)
- [x] Phase 3: Planning & Backlog Refinement (Develop backlog, map blocking dependencies)
- [ ] Phase 4: User Approval Gate (Awaiting written sign-off, record approval in Log below)
- [ ] Phase 5: Multi-Subagent Feature Implementation (Develop, verify, document each ticket)
- [ ] Phase 6: QA & Verification (Audit test reports, ensure zero regressions)
- [ ] Phase 7: Release Preparation & Versioning (Update version.txt, stage/package release)
- [ ] Phase 8: Human Peer Review (Await human peer sign-off, run /pr-done closeout)

### Approval Sign-off Log:
| Phase Name | Approved By (Git / OS Username) | Date | Status / Notes |
|---|---|---|---|
| **Phase 4: Package Approval** | *Pending* | *Pending* | *Pending* |
| **Phase 6: Quality Verification** | *Pending* | *Pending* | *Pending* |
