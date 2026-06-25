# Physical Architecture Comparative Pros/Cons Matrix

This document provides a quantitative and qualitative trade-off analysis of the candidate physical architectures developed for the Rock-Paper-Scissors-Lizard-Spock game.

---

## 1. Candidate Overview

- **Candidate A: dual-container-pod** (Multi-Container Kubernetes Pod)
  - **Structure**: Front-end (`BunFrontendContainer`) and Back-end (`UvBackendContainer`) run inside a single Kubernetes Pod (`K8sGamePod`). They communicate over `localhost:8000` via physical HTTP/JSON.
  - **UX Design**: Interactive Dashboard (9/10 usability score).
- **Candidate B: unified-monolith** (Single-Container Unified Web Bundle)
  - **Structure**: Front-end is compiled into static assets and mounted/served directly by the FastAPI backend within a single, unified container.
  - **UX Design**: Multi-Step Game Wizard (6/10 usability score).

---

## 2. SWaP-C Constraints & Trade-off Analysis

| Evaluation Metric | Candidate A: dual-container-pod | Candidate B: unified-monolith |
| :--- | :--- | :--- |
| **Size (Image Footprint)** | **Moderate** (Requires building two separate container images: Bun-based frontend ~150MB, Python-based backend ~120MB). | **Low** (Single unified container image enclosing both python and static asset build artifacts ~130MB). |
| **Latency (Network & UI)** | **Very Low Latency (UI)**. High-density interactive dashboard renders instantly. Slightly higher container-to-container latency (~1-2ms localhost HTTP loop). | **Zero local network latency** (Served on-device/in-process). However, **UI Latency is higher** because the Multi-Step Wizard transitions break flow and introduce page load transitions. |
| **Developer Velocity** | **Very High**. Frontend and backend are completely decoupled. Enables parallel frontend and backend engineering. Direct monorepo workspace boundaries. | **Moderate**. Frontend must be continuously compiled to static folders to test the Python server. High coupling of dependencies. |
| **Deployment Complexity** | **High**. Requires writing a Pod manifest, configuring container port mapping (`pod.yaml`), and managing multi-container lifecycle in Podman. | **Low**. Single container, single port mapping. Minimal devops configuration. |
| **Usability Score (1-10)** | **9 / 10** (Interactive Dashboard: low cognitive load, unified state view, minimal clicks, high visual momentum). | **6 / 10** (Multi-Step Wizard: higher cognitive friction, multiple clicks to complete a single round, navigation overhead). |

---

## 3. Detailed Pros & Cons

### Candidate A: dual-container-pod

#### Pros
1. **Decoupled Architecture**: High separation of concerns. Frontend uses specialized Bun tooling, backend uses Python UV.
2. **Superior UX Experience**: The interactive dashboard presents everything on a single screen, making the game fluid, fast, and easy to play.
3. **Scalability**: Containers can be scaled independently if migrated to external services.
4. **Clean Allocation**: One-to-one logical component mapping to physical containers.

#### Cons
1. **DevOps Overhead**: Requires Kubernetes manifests, local pod configurations, and managing dual containers.
2. **Localhost Network Dependency**: Frontend depends on local networking interface to talk to the backend.

---

### Candidate B: unified-monolith

#### Pros
1. **Simplified Deployment**: Zero Kubernetes pod orchestration required. Run a single container or single python process.
2. **Zero Internal Latency**: No local network hop for asset serving.
3. **Single Asset Bundle**: Easier to distribute as a single docker image.

#### Cons
1. **Poor Usability**: The multi-step wizard requires 4 screen transitions and multiple extra clicks per round, leading to cognitive fatigue.
2. **Build Coupling**: Frontend changes require rebuild and remount within Python context, slowing down UI engineering cycles.
3. **Muddled Component Allocation**: A single physical container aggregates multiple logical units.

---

## 4. Architectural Recommendation & Promotion Selection

### Scoring Summary
- **Candidate A (dual-container-pod)**: **8.5 / 10** (Weighted heavily towards developer velocity and exceptional user experience, accepting slightly higher deployment complexity).
- **Candidate B (unified-monolith)**: **6.5 / 10** (Weighted towards simple infrastructure, but penalized by slow development feedback loops and poor usability).

### Decision
We formally recommend **Candidate A: dual-container-pod** for official baseline promotion. 

While the unified monolith is simpler to deploy, the **dual-container architecture** directly aligns with the stakeholder needs (e.g., `NEED_SYS_001` containerized client-server, `NEED_SYS_011` separate Containerfiles, `NEED_SYS_012` pod.yaml). Furthermore, Candidate A's Interactive Dashboard delivers a significantly superior user experience with minimal cognitive load, which directly satisfies visual-token and molecule-level HMI standards.
