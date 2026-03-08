# Technical Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Section headers and key concerns established. Detail to be filled as Phase 1 tasks complete.*

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

*Blocked by DEC-001 (offline scoring) and DEC-006 (offline media boundary).*

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

### Cost Concerns
See `DEC-005-ai-cost-model.md`. Key question: what's the target cost-per-dog for a full pipeline run?

---

## 4. Infrastructure Options

*Blocked by DEC-004 (orchestration location).*

### Option A: Static Site (Standalone)
- Single HTML files served from any web server or opened locally
- AI calls go directly from browser to provider APIs (CORS, API key exposure concerns)
- Storage: LocalStorage / IndexedDB / file export
- Deployment: GitHub Pages, Netlify, or local file://

### Option B: Thin Backend
- Static frontend + lightweight API proxy (handles auth, rate limiting, key management)
- AI calls proxied through backend (keys stay server-side)
- Storage: Server-side DB + client cache
- Deployment: Single container or serverless functions

### Option C: Hybrid
- Core features (Tier 1, Tier 2) work as static files
- AI-powered features (Tier 3) route through a backend when available
- Progressive enhancement: offline-first with online superpowers

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

*Depends on DEC-004 outcome.*

### Environments
| Environment | Purpose | Who uses it |
|-------------|---------|-------------|
| **Local/file** | Solo foster, zero setup | Foster opens HTML file |
| **Hosted demo** | Evaluation, contributor testing | Contributors, potential rescues |
| **Rescue instance** | Single rescue deployment | Rescue coordinator |
| **Platform-connected** | Full pipeline with outcome data | Rescues on a smart platform |

### Build Constraints
- Core tasks: No build step. HTML file works as-is.
- Project tasks: Minimal build acceptable if documented.
- High bar tasks: Build tooling expected (video processing, real-time AI).
