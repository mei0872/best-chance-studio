# DEC-004: Orchestration Engine Location

**Status:** Decided
**Date:** 2026-03-08
**Decider:** mei0872 (via GitHub Discussion #14)
**Model(s):** Software, Technical

---

## Context

FLOW.md describes BCS as "the orchestration layer" — it reads gaps, decides which APIs to call in which order, carries context between them, and assembles the coaching packet. This orchestration logic is the brain of BCS.

The question is where this brain runs. Client-side (browser), server-side (backend), or isomorphic (either). This decision cascades into deployment model, offline capability, API key management, and contributor experience.

CONTRIBUTING.md says: "self-contained HTML file. No build step. Works offline." — for Core tasks. But the full pipeline (14 APIs, some requiring LLMs) may not fit that constraint.

### Emerging Pattern from Task Specs

The owner's task specs reveal a natural split:

| Task | Stack | Connectivity | Nature |
|------|-------|-------------|--------|
| G-01, G-02 | HTML + vanilla JS | Offline | Stateless, input→output |
| P-01 | HTML + JS (rule-based) | Offline | Stateless, input→output |
| P-02 | HTML + JS, LocalStorage | Offline (v1) | Session-based, accepts `platform_hints` |
| P-03 | Python or Node + CV model | Online (API) | Standalone API + test UI |

The stack naturally splits at P-03: everything up to P-02 is client-side HTML. P-03 and beyond require server-side compute (CV models, LLMs). This suggests the architecture is already converging on **Option C (isomorphic)** — client-side tools for the rule-based foundation, server-side APIs for AI-powered features.

---

## Options

### Option A: Client-side orchestration (browser)

**How it works:**
- Orchestration logic runs in the browser as vanilla JS.
- Browser calls each API directly (LLM providers, media services).
- All context threading happens in-memory or via IndexedDB.
- The HTML file IS the orchestration engine.

**Pros:**
- True standalone — no backend to deploy or maintain.
- Works offline for Tier 1/2 features (DEC-001).
- Aligns with "single HTML file" philosophy.
- Contributors can build and test locally without infrastructure.
- Zero server cost.

**Cons:**
- **API keys exposed in browser.** LLM provider keys, YouTube OAuth tokens — all visible in source/devtools.
- CORS restrictions — not all AI providers allow browser-direct calls.
- No centralized error monitoring or usage tracking.
- Complex orchestration logic in vanilla JS without a module system is hard to maintain at 14 APIs.
- Rate limiting is per-client — hard to manage across rescues.

### Option B: Server-side orchestration (backend)

**How it works:**
- Thin frontend sends intake data to a backend API.
- Backend runs orchestration: calls LLMs, manages API keys, sequences pipeline, assembles packet.
- Frontend receives the completed coaching packet and handles review/approval UX.

**Pros:**
- API keys stay server-side. Secure by default.
- Centralized orchestration — easier to debug, monitor, and iterate.
- Can batch API calls efficiently (parallel, retry, circuit break).
- Rate limiting managed centrally.
- Backend can be shared across multiple rescues.

**Cons:**
- **Requires deployment infrastructure.** No more "open an HTML file."
- Doesn't work offline for anything beyond the frontend shell.
- Contributor barrier: need to run a backend locally.
- Server cost — someone pays for hosting.
- Single point of failure.

### Option C: Isomorphic orchestration (progressive)

**How it works:**
- Orchestration logic is written once, runs in both environments.
- **Offline mode**: browser runs Tier 1/2 orchestration locally (rule-based scoring, coaching actions, photo capture guidance).
- **Online mode**: browser delegates Tier 3 orchestration to a backend (AI scoring, story building, video pipeline).
- The same orchestration module detects connectivity and routes accordingly.

**Pros:**
- Best of both: offline-capable + secure when online.
- Contributors can develop and test the offline path with zero infrastructure.
- Online path handles API keys, rate limiting, and complex AI calls.
- Progressive enhancement — works in a parking lot, works better with Wi-Fi.

**Cons:**
- Most complex to build. Two execution paths for orchestration logic.
- "Isomorphic" in vanilla JS without a module bundler is challenging.
- Testing matrix doubles (offline path + online path + transition between them).
- Risk of feature parity drift between offline and online modes.

---

## Tradeoffs

| Factor | A: Client-side | B: Server-side | C: Isomorphic |
|--------|---------------|----------------|---------------|
| Offline support | Full (Tier 1/2/3 attempt) | Frontend shell only | Full (Tier 1/2) + online (Tier 3) |
| API key security | Exposed | Secure | Secure (online) |
| Deployment complexity | None | Moderate | Moderate (online path) |
| Contributor barrier | Low | Medium | Low (offline) / Medium (online) |
| Server cost | $0 | $$ | $ (online path only) |
| Maintenance | Complex at scale | Centralized | Most complex |
| "Single HTML file" | Yes | No | Partially |

---

## Recommendation

**Option C: Isomorphic orchestration** — but implemented pragmatically, not as a framework.

The offline orchestrator is a small vanilla JS module that handles: intake → rule-based scoring → coaching actions from rubric-config → photo capture guidance → session persistence. This is the "single HTML file" experience.

The online orchestrator is a thin backend that handles: AI scoring → story building → photo curation → video pipeline → platform export. The frontend sends the intake data and gets back a coaching packet.

The transition is simple: if the backend is reachable, use it. If not, run locally. No complex isomorphic framework — just a connectivity check and two code paths.

---

## Decision

**Option C: Isomorphic orchestration, implemented pragmatically.** Confirmed by stakeholder.

Stakeholder notes:
- The task specs already reveal this split naturally. The architecture was converging on Option C before this decision was written.
- Two simple code paths, not a framework. Offline orchestrator is vanilla JS, online orchestrator is a thin backend.
- Routing decision is a single connectivity check.

**Stakeholder requirement — graceful degradation:** The offline path should always produce *something* even for Tier 3 features. If `/story/build` can't reach the backend, the offline path should return rule-based coaching actions from rubric-config.json for each gap dimension — **not an error**. Degraded ≠ broken.

**Stakeholder note on P-02:** The "single HTML file" philosophy still holds for G-series and P-01. P-02 (Story Builder Session) is where the split first appears — that's the right place to implement the connectivity check for the first time.

---

## Consequences

- Two orchestration modules: `orchestrate-offline.js` (browser) and `orchestrate-online.js` (backend)
- Shared: session state format, coaching packet schema, rubric config loader
- Frontend needs a connectivity check + routing decision at pipeline start
- Backend is optional — BCS works (degraded) without it
- **Offline path must never return an error for Tier 3 features** — always fall back to rubric-based coaching actions (stakeholder requirement)
- P-02 is where the connectivity check is first implemented
- Contributor workflow: develop offline path first, online path when ready
- Deployment: static files for offline, single container for backend
