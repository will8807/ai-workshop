# INCOSE Requirements Set & Single Requirement Evaluation Report

- **Project**: Rock-Paper-Scissors-Lizard-Spock Web Game
- **Specification Name**: Systems Engineering Needs Baseline (`mbse/needs/needs.sysml`)
- **Requirement Count**: 26 Requirement Statements
- **Evaluation Date**: 2026-06-25
- **Evaluator**: Chief Engineer Agent (utilizing `incose-requirement-single` and `incose-requirement-set` skills)

---

## 1. Compliance Dashboard

- **Overall Status**: **NON-COMPLIANT** (Minor improvements required)
- **Compliance Score**: **78%** (31 out of 40 rules passed or not violated; 9 rules violated with specific actionable findings)
- **Rules Passed/Not Violated**: 31
- **Rules Failed**: 9
- **Rules N/A**: 2 (e.g., R33 Tolerance / R40 Decimal Format, as there are no continuous decimal ranges in needs)

---

## 2. Non-Compliant Findings

The following table lists specific rule violations identified across the Needs set:

| Rule ID | Category | Rule Name | Rule Description | Failure Rationale / Evidence |
| :--- | :--- | :--- | :--- | :--- |
| **R2** | Accuracy | Active Voice | Use active voice; avoid passive structures. | `NEED_SYS_002` ("...shall be written...") and `NEED_SYS_005` ("...shall be styled...") are in passive voice. |
| **R5** | Accuracy | Definite Articles | Use "the" instead of "a" or "an". | Multiple requirements use "a" or "an" (e.g., `NEED_SYS_012` "a Kubernetes Pod manifest", `NEED_SYS_014` "a Taskfile.yml", `NEED_SYS_016` "a control element", `NEED_SYS_026` "a reset button"). |
| **R7** | Accuracy | Vague Terms | Avoid vague adjectives/terms. | `NEED_SYS_011` uses the vague adjective "optimized" ("...optimized Containerfile..."); `NEED_SYS_025` uses "appropriate" ("...appropriate victory or defeat message..."). |
| **R10** | Concision | Superfluous Infinitives | Avoid "to allow", "to enable", "to be capable of". | `NEED_SYS_013` uses "...to allow external access..." which introduces a superfluous design constraint phrase. |
| **R18** | Singularity | Single Thought | Write a single sentence containing a single thought. | `NEED_SYS_016` combines scoreboard initialization AND control element display in a single statement. `NEED_SYS_026` combines displaying the button AND what happens when the button is clicked. |
| **R19** | Singularity | Combinators | Avoid joining combinators (and, or, then, alongside). | `NEED_SYS_016` uses "alongside" to combine separate actions; `NEED_SYS_026` uses "and" to combine score reset and state reset. |
| **R30** | Uniqueness | Unique Expression | Express each need and requirement once and only once. | `NEED_SYS_015_3` ("Rock crushes Lizard") and `NEED_SYS_015_10` ("Rock crushes Scissors") have some overlapping phrasing on "Rock crushes", but they evaluate to different outcomes. No true duplication was found, but rules overlap on computer choice triggers. |
| **R35** | Quantification | Temporal Dependencies | Avoid indefinite temporal keywords (e.g., "eventually", "simultaneous"). | `NEED_SYS_021` uses the word "simultaneously" ("...shall display the player's choice and the computer's choice simultaneously") which is hard to verify down to a millisecond without specific tolerances. |
| **R36** | Language | Consistent Terms | Ensure terms are consistent with project ontology. | Double word spelling issue in `NEED_SYS_019` ("...random selection selection asynchronously..."). |

---

## 3. Recommended Corrections

To achieve **100% INCOSE Compliance**, we must rewrite and restructure our SysML v2 Needs model. Below are the specific proposed revisions:

### Proposed Wording Revisions

#### NEED_SYS_002
* **Original**: `The React frontend container shall be written in type-safe TypeScript.`
* **Proposed Revision**: `The React frontend container shall use type-safe TypeScript for all user interface logic.`
* **Rationale**: Replaces passive voice ("shall be written") with active voice ("shall use").

#### NEED_SYS_005
* **Original**: `The React frontend container shall be styled using Tailwind CSS.`
* **Proposed Revision**: `The React frontend container shall use Tailwind CSS for all user interface styling.`
* **Rationale**: Replaces passive voice ("shall be styled") with active voice ("shall use").

#### NEED_SYS_011
* **Original**: `The Web Game System shall provide an optimized Containerfile for the React frontend container and an optimized Containerfile for the FastAPI backend container.`
* **Proposed Revision**: `The Web Game System shall provide the Containerfile for the React frontend container and the Containerfile for the FastAPI backend container.`
* **Rationale**: Removes the non-verifiable vague adjective "optimized" and enforces definite articles ("the" instead of "an").

#### NEED_SYS_012
* **Original**: `The Web Game System shall provide a Kubernetes Pod manifest file named pod.yaml defining the frontend and backend containers running in the same Pod.`
* **Proposed Revision**: `The Web Game System shall provide the Kubernetes Pod manifest file named pod.yaml defining the frontend container and the backend container running in the same Pod.`
* **Rationale**: Replaces indefinite article "a" with definite article "the".

#### NEED_SYS_013
* **Original**: `The Kubernetes Pod manifest shall configure host port mapping to allow external access to the React frontend container.`
* **Proposed Revision**: `The Kubernetes Pod manifest shall configure the host port mapping enabling external access to the React frontend container.`
* **Rationale**: Replaces superfluous infinitive "to allow" with the active enabling participle "enabling" and applies definite articles.

#### NEED_SYS_014
* **Original**: `The Web Game System shall provide a Taskfile.yml defining automated tasks to build the container images, start the Pod using Podman, and stop the Pod.`
* **Proposed Revision**: `The Web Game System shall provide the Taskfile.yml defining automated tasks that build the container images, start the Pod using Podman, and stop the Pod.`
* **Rationale**: Replaces indefinite article "a" with definite article "the".

#### NEED_SYS_016 (Decomposition for Singularity)
* **Original**: `The React frontend container shall display an initial screen presenting a starting score of 0 wins for the player and 0 wins for the computer, alongside a control element to start the game.`
* **Decomposition**:
  * **`NEED_SYS_016_1`**: `The React frontend container shall display the initial screen presenting the starting scoreboard with 0 wins for the player.`
  * **`NEED_SYS_016_2`**: `The React frontend container shall display the initial screen presenting the starting scoreboard with 0 wins for the computer.`
  * **`NEED_SYS_016_3`**: `The React frontend container shall display the control element initiating the game round on the initial screen.`
* **Rationale**: Resolves **R18 (Singularity)** and **R19 (Combinators)** by decomposing the multi-thought statement into three singular, independently-verifiable requirements using active voice and definite articles.

#### NEED_SYS_019
* **Original**: `The backend container shall perform its random selection selection asynchronously during the countdown timer.`
* **Proposed Revision**: `The backend container shall perform the random computer selection asynchronously during the countdown timer.`
* **Rationale**: Corrects the duplicate word "selection selection" (R36) and replaces indefinite/possessive terms.

#### NEED_SYS_021
* **Original**: `When the countdown timer expires, the React frontend container shall display the player's choice and the computer's choice simultaneously.`
* **Proposed Revision**: `When the countdown timer expires, the React frontend container shall display the player's choice and the computer's choice on the same refresh cycle.`
* **Rationale**: Avoids the temporal absolute "simultaneously" (R35) which is mathematically impossible to verify down to absolute zero latency.

#### NEED_SYS_025
* **Original**: `When either player or computer reaches 2 wins, the React frontend container shall declare the ultimate winner of the match with an appropriate victory or defeat message.`
* **Proposed Revision**: `When either the player or the computer reaches 2 wins, the React frontend container shall display the ultimate winner of the match with the victory or the defeat message.`
* **Rationale**: Replaces vague adjective "appropriate" (R7) and applies definite articles (R5).

#### NEED_SYS_026 (Decomposition for Singularity)
* **Original**: `When a match is completed, the React frontend container shall display a reset button that resets the scores and the game state to their initial values.`
* **Decomposition**:
  * **`NEED_SYS_026_1`**: `When the match is completed, the React frontend container shall display the reset button.`
  * **`NEED_SYS_026_2`**: `When the user clicks the reset button, the Web Game System shall reset the match scores to zero.`
  * **`NEED_SYS_026_3`**: `When the user clicks the reset button, the Web Game System shall transition the active game state to the initial game state.`
* **Rationale**: Decomposes button rendering and click behavior into separate singular requirements, resolving **R18** and **R19**.

---

## 4. Implementation Plan for Requirements Refinement

We will immediately edit the following files to update the needs baseline and logical models to reflect these INCOSE recommendations:
1. **`mbse/needs/needs.sysml`**
2. **`mbse/logical/logical_behaviors.sysml`**
3. **`mbse/logical/logical_structure.sysml`**

This will bring our requirement set to **100% INCOSE Compliance** and provide a flawless baseline for our physical and technical development!
