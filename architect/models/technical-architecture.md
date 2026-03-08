# Technical Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Foundation established. Key assumptions resolved — see questions-architect.md.*

---

## 1. Dependency Graph

### API Call Order (from FLOW.md)

```
Foster submits intake
       │
       ▼
/voice/transcribe (if voice notes)
       │
       ▼
/bcs/score ──────────────────────── always first
       │
       ├──→ /word/check ──→ clean text
       │                        │
       ▼                        ▼
/story/build ◄── score_context + clean_version
       │
       ├──→ /photos/curate ◄── score_context
       │
       ├──→ video pipeline (if video absent: coaching prompt + shot_agenda)
       │         │
       │         ├──→ /video/direct (live coaching)
       │         ├──→ /video/coach (post-capture review)
       │         ├──→ /video/produce (reel production)
       │         └──→ /video/export (platform delivery)
       │
       ▼
coaching packet assembly
       │
       ▼
/story/refine ◄── foster review loop
       │
       ├──→ /story/card (shareable image)
       ├──→ /story/format (platform-specific text)
       │
       ▼
published dog inventory
       │
       ▼ (if dog doesn't place)
/story/represent ◄── session history + near-miss signals
```

### Context Propagation
Key data that flows between APIs:
- `score_context` (dimensions + gaps) → `/story/build`, `/photos/curate`
- `priority_gaps` → determines which API to call next
- `foster_notes` + voice transcripts → merged before scoring
- `platform_hints` → every API (optional)
- `shot_agenda` → `/video/direct`, `/video/coach`
- `session_history` → `/story/represent`

---

## 2. Offline Tier Definitions

*DEC-001 decided (two-tier scoring). DEC-006 recommendation confirmed by task specs.*

### Proposed Classification

| Tier | Definition | Examples |
|------|-----------|----------|
| **Tier 1: Fully offline** | Works with zero connectivity | Rubric display, config loading, intake form, photo capture, basic rule-based word check |
| **Tier 2: Offline degraded** | Core function works offline with reduced quality | Scoring (rule-based subset), story templates (non-AI), photo selection (basic heuristics) |
| **Tier 3: Online required** | Requires API/LLM connectivity | AI story building, AI photo analysis, video production, platform export, YouTube upload |

### The Solo Foster Test
From CONTRIBUTING.md: "One photo + one sentence → still produces something useful."

Tier 1 + Tier 2 must satisfy this test. The foster should get:
- A score (even if rule-based approximation)
- Coaching actions from rubric-config.json (deterministic — no LLM needed)
- A basic word check (rule-based flagging)
- Photo capture guidance (shot list from templates)

---

## 3. AI Service Catalog

| API | AI Required? | AI Task | Estimated Complexity |
|-----|-------------|---------|---------------------|
| `/voice/transcribe` | Yes | Speech-to-text | Low (Whisper or equivalent) |
| `/bcs/score` | Depends (DEC-001) | Gap analysis across 9 dimensions | Medium — could be partially rule-based |
| `/word/check` | No (v1) | Rule-based word flagging | Low — lookup table |
| `/story/build` | Yes | Narrative generation from gaps + foster notes | High — core LLM task |
| `/story/refine` | Yes | Iterative story revision | Medium — constrained generation |
| `/story/represent` | Yes | Fresh angle from history + signals | High — reasoning over session history |
| `/photos/curate` | Yes | Image analysis, ranking, shot list generation | Medium — vision model |
| `/video/direct` | Yes | Real-time coaching during capture | High — low-latency vision + speech |
| `/video/coach` | Yes | Post-capture analysis vs shot agenda | Medium — vision model |
| `/video/produce` | Partial | Editing/music/pacing (may be deterministic pipeline with AI decisions) | High — compute heavy |
| `/video/export` | No | Format conversion + metadata | Low — deterministic |
| `/story/card` | Partial | Image generation/layout | Low-Medium |
| `/story/format` | No | Text reformatting to platform limits | Low — deterministic |

### Provider Strategy (Decided — DEC-005)
Provider abstraction required from day 1. Target providers: OpenAI, Anthropic (Claude), and local models (Ollama). Build `AICapability` interface with adapters per provider.

Spec docs from stakeholder:
- `docs/ai-credentials.md` — BYOK credential flow required for standalone tools. Setup in under 3 minutes for non-technical coordinator. Provider selection (OpenAI/Anthropic/Ollama), key validation before save, secure storage (not localStorage plaintext), graceful failure when missing. Cost transparency in setup UI ($0.25–$0.50/dog estimate).
- `docs/ai-usage-logging.md` — Per-call usage logging (SHOULD, not MUST). Schema: api, model, tokens_in/out, estimated_cost, duration_ms, complexity_hint, rubric_version, timestamp. Data stays with implementor — no telemetry. Community feedback loop: implementors share findings → spec updates with cheaper recommendations. Key cost levers identified: /photos/curate (vision model), /story/refine (prompt tightening), /bcs/score (rule-based for easy dims), /video/coach (frame sampling rate).

### Cost Concerns
DEC-005 decided: < $0.50 per dog for full pipeline (excluding video direction). BCS spec is silent on who pays — that's the implementor's concern. H-01 video direction cost TBD via prototype.

---

## 4. Infrastructure Options

*Resolved: Q-T1 (all deployment modes), Q-S1 (server-side orchestrator), DEC-004 (isomorphic).*

### Deployment Model: All of the Above (Q-T1)
The solution must be something anyone can run. Architecture supports:

| Mode | How It Works | Who Uses It |
|------|-------------|-------------|
| **Static files (local)** | Open HTML files directly. G-series tools work offline. | Solo foster, zero setup |
| **Self-hosted** | Rescue deploys static files + backend on their own infrastructure | Tech-savvy rescue |
| **Hosted service** | BCS runs the backend, rescues register self-serve (Q-P2) | Most rescues |
| **Platform-connected** | Full pipeline with outcome data, platform_hints | Rescues on a smart platform |

### Architecture: Isomorphic (DEC-004 + Q-S1)
- **Client-side:** G-series and P-01/P-02 work as standalone HTML files with no backend
- **Server-side:** Orchestrator service sequences the full AI pipeline (P-03, P-04, P-05, P-06, H-series)
- **Progressive:** If backend is reachable, use it. If not, run offline with rule-based tools.

### Video Processing (Resolved — Q-T3)
Server-side by default. Client-side option for users with sufficient local hardware. BCS offers server-side post-processing for those who need it.

---

## 5. Mobile-First Constraints

From CONTRIBUTING.md: "Mobile-friendly at 375px."

### Technical Requirements
- **Viewport**: 375px minimum width (iPhone SE)
- **Touch targets**: Minimum 44x44px
- **Camera access**: `getUserMedia()` for photo/video capture
- **Microphone access**: `getUserMedia()` for voice notes
- **Offline**: Service Worker for caching static assets + rubric config
- **Storage**: Must work within mobile browser storage limits (~50MB LocalStorage, ~varies IndexedDB)

### Performance Budget (Proposed)
- First meaningful paint: < 2s on 3G
- Scoring response: < 3s (rule-based) / < 8s (AI-enhanced)
- Photo analysis: < 10s per image
- Total coaching packet assembly: < 30s (online)

---

## 6. Deployment Model

*Resolved — see Infrastructure Options above.*

### Connectivity Assumption (Q-O3)
Systems will need some form of internet connectivity for updates. Not fully dark/offline-only. Opt-in error reporting or telemetry is a future possibility.

### Multi-Language (Q-P1)
Multi-language support required. Text processing, word-check rules, LLM prompts, and coaching actions must be designed for i18n from the start.

### Build Constraints
- Core tasks: No build step. HTML file works as-is.
- Project tasks: Minimal build acceptable if documented (Q-S2).
- High bar tasks: Build tooling expected (video processing, real-time AI).
