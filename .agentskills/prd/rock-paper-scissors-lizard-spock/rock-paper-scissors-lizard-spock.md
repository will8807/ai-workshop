# Product Requirements Document (PRD)

## Title: PRD-RPSLS: Rock-Paper-Scissors-Lizard-Spock Web Game
**Date**: 2026-06-25

---

## 1. Executive Summary & Objective
The objective of this project is to build a containerized, web-based "Rock-Paper-Scissors-Lizard-Spock" (RPSLS) game. The system comprises a modern FastAPI backend in Python and a strictly-typed React frontend in TypeScript styled with Tailwind CSS. It is configured to run locally via Podman Kube using a Kubernetes Pod manifest (`pod.yaml`) and automated via Go-Task (`Taskfile.yml`). The game logic (win/loss evaluation and random choice generation) is strictly executed on the backend to prevent frontend client cheating.

## 2. Problem Statement & User Story
* **Problem**: Playing classic Rock-Paper-Scissors is too simple, and users want a more complex game variant like Rock-Paper-Scissors-Lizard-Spock (as popularized by The Big Bang Theory). Additionally, they need a fair, robust, containerized, and easy-to-run client-server web app where win/loss evaluation is secure and cheat-proof.
* **User Story**: As a player, I want to play Rock-Paper-Scissors-Lizard-Spock against a cheat-proof computer opponent with real-time countdown feedback, visual selection highlighting, simultaneous choice reveal, score tallies, and match victory declaration, so that I can enjoy a fair, modern, and engaging web gameplay experience.

## 3. High-Level Requirements (CAP_SYS)
* **CAP_SYS_001**: A containerized FastAPI backend using UV for dependency and environment management.
* **CAP_SYS_002**: A type-safe TypeScript React frontend styled with Tailwind CSS, built and packaged using Bun.
* **CAP_SYS_003**: Fully containerized system components with separate, optimized Containerfiles for the frontend and backend.
* **CAP_SYS_004**: High-fidelity Kubernetes orchestration using a multi-container Pod manifest (`pod.yaml`) run locally via `podman play kube`.
* **CAP_SYS_005**: A Go-Task automation interface (`Taskfile.yml`) to orchestrate container building, Pod execution, and teardown.
* **CAP_SYS_006**: State-driven game loop execution including initial screen, countdown phase, background action phase, simultaneous reveal, score tallying, best of 3 match resolution, and match reset.

## 4. Detailed Functional Requirements (EARS)
These requirements map directly to the MBSE needs specification defined in `mbse/needs/needs.sysml`:
* **NEED_SYS_001**: The Web Game System shall implement a containerized client-server architecture comprising a React frontend container and a FastAPI backend container.
* **NEED_SYS_002**: The React frontend container shall be written in type-safe TypeScript.
* **NEED_SYS_003**: The React frontend container shall define all game states and API payloads using strict TypeScript interfaces.
* **NEED_SYS_004**: The React frontend container shall use Bun as the package manager, test runner, and build tool.
* **NEED_SYS_005**: The React frontend container shall be styled using Tailwind CSS.
* **NEED_SYS_006**: The backend container shall use Python with the FastAPI framework.
* **NEED_SYS_007**: The backend container shall use UV as the Python environment and package manager.
* **NEED_SYS_008**: The backend container shall define all dependencies and project metadata within a pyproject.toml file.
* **NEED_SYS_009**: The backend container shall randomly generate the computer's selection from the five game choices.
* **NEED_SYS_010**: The backend container shall evaluate the outcome of each game round to prevent client-side manipulation.
* **NEED_SYS_011**: The Web Game System shall provide an optimized Containerfile for the React frontend container and an optimized Containerfile for the FastAPI backend container.
* **NEED_SYS_012**: The Web Game System shall provide a Kubernetes Pod manifest file named pod.yaml defining the frontend and backend containers running in the same Pod.
* **NEED_SYS_013**: The Kubernetes Pod manifest shall configure host port mapping to allow external access to the React frontend container.
* **NEED_SYS_014**: The Web Game System shall provide a Taskfile.yml defining automated tasks to build the container images, start the Pod using Podman, and stop the Pod.
* **NEED_SYS_015**: The backend container shall evaluate round outcomes according to the classic Rock-Paper-Scissors-Lizard-Spock game rules:
  - Scissors cuts Paper
  - Paper covers Rock
  - Rock crushes Lizard
  - Lizard poisons Spock
  - Spock smashes Scissors
  - Scissors decapitates Lizard
  - Lizard eats Paper
  - Paper disproves Spock
  - Spock vaporizes Rock
  - Rock crushes Scissors
* **NEED_SYS_016**: The React frontend container shall display an initial screen presenting a starting score of 0 wins for the player and 0 wins for the computer, alongside a control element to start the game.
* **NEED_SYS_017**: When the user initiates a game round, the React frontend container shall initiate a 5-second countdown timer.
* **NEED_SYS_018**: The React frontend container shall accept the player's choice from the five game options during the countdown timer.
* **NEED_SYS_019**: The backend container shall perform its random selection asynchronously during the countdown timer.
* **NEED_SYS_020**: The React frontend container shall visually highlight the player's selection without displaying the evaluation outcome during the countdown timer.
* **NEED_SYS_021**: When the countdown timer expires, the React frontend container shall display the player's choice and the computer's choice simultaneously.
* **NEED_SYS_022**: The React frontend container shall display the text outcome of the evaluated round.
* **NEED_SYS_023**: The React frontend container shall explicitly display a statement that a tie round does not increment the win count.
* **NEED_SYS_024**: The Web Game System shall repeat game rounds until either the player or the computer reaches 2 wins.
* **NEED_SYS_025**: When either player or computer reaches 2 wins, the React frontend container shall declare the ultimate winner of the match with an appropriate victory or defeat message.
* **NEED_SYS_026**: When a match is completed, the React frontend container shall display a reset button that resets the scores and the game state to their initial values.

## 5. MBSE Baseline & Integration Analysis
* **Added Parts/Systems**:
  - SysML v2 Needs model created under `mbse/needs/needs.sysml`.
* **Modified Models**:
  - Logical and Physical architectures will be derived from this needs model in subsequent phases.
* **Blast Radius & Impact**:
  - Greenfield project with no pre-existing code, so there is zero risk of regressing existing features.

## 6. Non-Functional & Security Requirements
* **Cheat Prevention**: No evaluation logic or random generation is allowed on the frontend.
* **Type Safety**: Strictly enforced static type checking in both Python (using Pyright) and React (TypeScript).
* **Test Coverage**: Complete unit and integration test suites using Bun (frontend) and Pytest (backend) with a target of 100% code coverage.
* **Platform Independence**: Taskfile automation for executing `podman play kube` to run containerized pods seamlessly across Linux, macOS, and Windows with Podman.

## 7. Verification & Acceptance Criteria (Test Cases)
* **verify_game_rules**: Backend unit tests evaluating all 10 standard win/loss outcomes and tie cases.
* **verify_countdown_flow**: Frontend unit/integration tests confirming the 5-second timer transitions through Initial -> Countdown -> Reveal -> Resolution.
* **verify_cheat_proofing**: E2E or backend tests verifying that the client receives the result only after transmitting the player's choice.
* **verify_pod_deployment**: Kubernetes integration test confirming both containers run inside the single pod and that host port forwarding is correct.

## 8. Detailed Implementation Plan & Proposed Issues
*(To be compiled and expanded in Phase 4 after Logical and Physical architectures are approved)*

## 9. Workflow State & Checklist of Activities
* **Current Workflow State**: **Phase 3: Physical Architecture Candidates & UX**

### Checklist of Activities:
- [x] Phase 1: Feature Initialization & Refinement (Compile PRD, checkout branch, model needs, validate MBSE)
- [x] Phase 2: Logical Architecture Development (Derive requirements, model logical components, functional behaviors, halt for User Control Gate)
- [x] Phase 3: Physical Architecture Candidates & UX (Develop candidates, pros-cons matrix, UI wireframes, halt for User Selection Gate)
- [ ] Phase 4: Backlog Refinement & Plan Development (Decompose plan, sequence stories, finalize backlog)
- [ ] Phase 5: Package Approval Gate (Awaiting written plan approval, record sign-off)
- [ ] Phase 6: Multi-Subagent Feature Implementation (Develop, verify, document each ticket)
- [ ] Phase 7: QA & Verification (Audit test reports, ensure zero regressions)
- [ ] Phase 8: Release Preparation & Versioning (Update version.txt, stage/package release)
- [ ] Phase 9: Human Peer Review (Await human peer sign-off, run /pr-done closeout)

### Approval Sign-off Log:
| Phase Name | Approved By (Git / OS Username) | Date | Status / Notes |
|---|---|---|---|
| **Phase 2: Logical Architecture** | *Pending* | *Pending* | *Pending* |
| **Phase 3: Physical Candidate** | *Pending* | *Pending* | *Pending* |
| **Phase 5: Package Approval** | *Pending* | *Pending* | *Pending* |
| **Phase 9: Peer Review** | *Pending* | *Pending* | *Pending* |
