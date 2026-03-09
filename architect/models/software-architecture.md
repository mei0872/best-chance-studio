# Software Architecture — Best Chance Studio

*Last updated: March 8, 2026*
*Status: Foundation established. Component map updated with all task specs (including G-04/G-05/G-06/P-05/P-06). All 6 decisions decided.*

---

## 1. Component Map

### Components by Pull List Category

**Core (G-series) — Self-contained, offline-capable, stateless**

Per owner task specs: all G-series tools are single HTML files, vanilla JS, no framework, no build step, work offline. They are input→output tools — no session persistence, no storage.

| Component | Pull List | Input | Output | platform_hints |
|-----------|-----------|-------|--------|----------------|
| BCS Scorer | G-01 | Dog profile across dimensions | Score, grade, top gaps | — |
| Rubric Reference | G-02 | `rubric-config.json` | Read-only dimension display | — |
| Voice Transcription | G-03 | Audio file (m4a) | Text transcript | — |
| Word Check | G-04 | Raw description text | Flagged words + replacements + clean version. Hardcoded word list from 70,733-dog study. | Future: `learned` |
| Story Card Generator | G-05 | Dog name, hook line, photo URL, rescue name | Shareable image card (1:1 Instagram + 4:5 portrait). Canvas API. | `photos.lead_shot` |
| Platform Formatter | G-06 | Approved description + target platform (petfinder/adoptapet/instagram/facebook/rescuegroups) | Formatted text within platform char limits + count + status | `dog_context.urgency` |

**Project (P-series) — Working prototypes**

Per owner task specs: P-01 is rule-based v1, no AI, single HTML file. P-02 is HTML + JS with LocalStorage. P-03/P-04/P-05/P-06 are **standalone APIs** (Python or Node). Full Story Builder spec: `strategy/feature-specs/story-builder.md`.

| Component | Pull List | Stack | Input | Output | platform_hints |
|-----------|-----------|-------|-------|--------|----------------|
| Coaching Packet Generator | P-01 | HTML + JS (rule-based) | BCS score + dog profile | One-page coaching brief (shot list, description draft, presenter guidance) | — (v1 rule-based) |
| Story Builder Session | P-02 | HTML + JS, LocalStorage | Photos, videos, notes, dog profile. Full spec: `strategy/feature-specs/story-builder.md` | Coached story (portable + enriched layers) + coaching packet. Two-layer output: portable (char-limit-aware) and enriched (full). | Optional |
| Photo Curation API | P-03 | Python or Node + CV model | photos[], dog_info | selected[] (url, order, reason) + rejected[] (url, reason) | Optional |
| BCS Score API | P-04 | Python or Node | dog_info, story?, photos?[], video? — receives full listing package, does its own analysis | score (0–18), grade (A+/A/B/C/D), by_dimension[] (name, score 0–2, gap), summary | — |
| Story Builder API | P-05 | Python or Node + LLM (GPT-4o recommended) | dog_name, raw_text, foster_notes, priority_gaps[], score_context{} | coached_description, coaching_packet {what_changed, dimensions_improved[], estimated_score_delta}, review_required: true | `story`, `learned` |
| Re-Presentation Engine | P-06 | Python or Node + LLM | dog_info, session_history[], platform_hints (optional) | new_angle, what_was_tried[], what_was_missing[], try_this_next[], new_shot_agenda[] | `learned` (near_miss_signals, top_performer_pattern), `dog_context` (days_in_care, escalation_risk) |

**High Bar (H-series) — Technical proof of concepts**

| Component | Pull List | Input | Output | platform_hints |
|-----------|-----------|-------|--------|----------------|
| AI Director | H-01 | Contributor's choice (mobile camera API + real-time vision) | Live camera feed + shot_agenda → real-time coaching prompts | `director`, `campaign` |
| Video Coach | H-02 | HTML + JS + GPT-4o vision | Upload/link video → shot-by-shot coaching card | `platform_hints` (required) |
| Video Producer | H-03 | Contributor's choice (ffmpeg + music library + AI editing) | Raw footage → produced highlight reel | `video` (length_seconds, music_tone, pacing, open_with) |
| Video Exporter | H-04 | Contributor's choice (ffmpeg + vision + LLM) | video_url, dog_info?, target (youtube\|instagram\|web) → exported_url, thumbnail, title, tags | `platform_hints` (optional) |

---

## 2. Orchestration Design

*Decided: Isomorphic orchestration (DEC-004 confirmed by stakeholder). Server-side orchestrator for full pipeline, client-side tools standalone. Offline path must never return errors for Tier 3 features — always fall back to rubric-based coaching.*

### Two Layers of Orchestration

The P-01 spec reveals that orchestration happens at two levels:

**Layer 1: Rule-based coaching packet (P-01, v1)**
- Input: BCS score (from G-01) + dog profile
- Output: One-page coaching brief — shot list, description draft, presenter guidance, top gaps
- Stack: HTML + JS, rule-based, no AI, single file (`coaching-packet-generator.html`)
- This is **deterministic assembly** — reads the score, applies rubric coaching actions, generates a brief
- No API calls, no connectivity, no orchestration of external services

**Layer 2: AI-enhanced pipeline (FLOW.md vision, future)**
The full FLOW.md pipeline (14 APIs, context threading, AI story building) is a later layer that builds on top of the rule-based foundation:
1. Receive intake submission
2. Transcribe voice notes (if present)
3. Call `/bcs/score` — always first
4. Read priority_gaps — decide which APIs to call next
5. Call `/word/check` → pass clean_version to `/story/build`
6. Call `/story/build` with score_context
7. Call `/photos/curate` with score_context
8. Generate video coaching prompt or trigger video pipeline
9. Assemble coaching packet
10. Present for foster review
11. Handle refine loop (tweak → regenerate → re-review)
12. Export on approval (card, format, publish)
13. Log to published dog inventory

### Data Flow Between Tools

The tools are separate HTML files. How does data flow between them?

**G-01 → P-01 (score → coaching packet):**
- **Manual:** Foster copies score values into P-01 (simple, but friction)
- **URL params:** G-01 generates a link to P-01 with score data encoded
- **LocalStorage handoff:** G-01 writes score to localStorage, P-01 reads it (lightweight, same-origin)
- **Combined tool:** G-01 and P-01 merge into one file that scores and generates the brief in one flow

**P-02 (Story Builder Session):**
P-02 is the first multi-step tool. Full spec: `strategy/feature-specs/story-builder.md`. Per owner spec:
- Takes whatever the foster brings (photos, videos, notes) — the "atomic unit of BCS work"
- Uses **LocalStorage for prototype** persistence
- Accepts **platform_hints** as optional input (first tool to do so)
- **Two-layer output:** Portable layer (char-limit-aware for listing platforms) and Enriched layer (full version with presenter brief)
- Sessions are versioned (v1 text only → v2 after photos → v3 after video). Nothing resets.
- Human gate: `review_required: true` is hardcoded. Three paths: Accept, Tweak, Start Over.
- Quick-tap tweak options: `Shorter · Longer · More playful · Emphasize calm · Less jargon · Different opening`
- `refine_count` tracked per session — 4+ refinements signals thin intake data
- Deliverable: `story-builder-session.html`

P-02 is where the individual tools start converging into a session-based workflow. It orchestrates BCS APIs in sequence per FLOW.md (voice/transcribe → word/check → bcs/score → story/build → photos/curate → story/refine → story/card + story/format).

**P-05 (Story Builder API):**
P-05 is the core AI story generation endpoint. Per owner spec:
- Receives `priority_gaps[]` and `score_context{}` from P-04 — coaching is gap-specific, not generic
- Produces `coached_description` + `coaching_packet` with `what_changed`, `dimensions_improved[]`, `estimated_score_delta`
- Test against Moose example in FLOW.md: input 3/18 profile, verify output hits personality_hook, foster_voice, family_vision

**P-06 (Re-Presentation Engine):**
P-06 reads what was tried and builds the next approach. Per owner spec:
- Degrades gracefully: no `platform_hints` → general coaching from session history. With hints → targeted brief from real adopter signal.
- Output: `new_angle`, `what_was_tried[]`, `what_was_missing[]`, `try_this_next[]`, `new_shot_agenda[]`
- Test against both Path A (platform-connected) and Path B (standalone with manual signals) per FLOW.md

**H-03 → H-04 (video produce → video export):**
Per H-04 spec: `/video/produce` calls `/video/export` internally as its final step. H-04 is also callable standalone on any existing video — not just BCS pipeline output. This makes H-04 a general-purpose utility, not just a pipeline component.

**P-04 (BCS Score API) — the unifying scorer:**
P-04 is the authoritative scoring source. Per owner spec, the relationships are:
- **G-01** should call P-04 rather than implement scoring logic directly
- **P-01** calls P-04 to know what to coach
- **`/story/build`** calls P-04 internally and returns the score in its response

This creates a dependency chain: G-01 → P-04, P-01 → P-04, P-02 → P-04 (via `/story/build`). But G-01 is offline/vanilla JS and P-04 is a server-side API. Resolution: G-01 contains fallback rule-based scoring for offline use, delegates to P-04 when available (see DEC-001 two-tier model).

These data flow questions should be resolved before P-01 and P-02 are built.

### Key Design Decisions (Layer 2)
- **Server-side orchestrator** (Q-S1, DEC-004 decided): A separate backend service owns pipeline sequencing, context threading, and error recovery. Client-side tools don't go through it — they're standalone.
- **Graceful degradation** (stakeholder requirement): Offline path always produces *something* for Tier 3 features. If backend is unreachable, return coaching actions from rubric-config.json — never an error.
- **Context threading**: The orchestrator carries `score_context`, `priority_gaps`, and `platform_hints` through the entire pipeline. No API re-fetches context.
- **platform_hints delivery** (Q-S3): Optional object in the request body. Absent = standalone mode.
- **Partial failure**: If `/photos/curate` fails but `/story/build` succeeds, the coaching packet still assembles with what it has.
- **Idempotency**: Re-running the same session with the same inputs should produce the same coaching packet (modulo LLM non-determinism).
- **AI disclosure** (Q-L2): All AI-coached content labeled as AI-assisted in the coaching packet and exports.
- **Multi-language** (Q-P1): Text processing, prompts, and coaching actions designed for i18n.

---

## 3. Config Loading Strategy

### rubric-config.json
- **Source of truth**: `rubric-config.json` in repo root
- **Loading**: Read once at session start, cache for session duration
- **Versioning**: `version` field (semver). Scores reference which version produced them.
- **Update path**: Community-reviewed config change → new version → all tools pick it up

### platform_hints
- **Delivery**: Passed as optional object in API request body (per `docs/platform-hints-schema.md`)
- **Fallback chain**: platform_hints → history → session inputs → sensible defaults
- **Unknown fields**: Ignored silently (forward-compatible by design)
- **Trust boundary**: See `security-architecture.md` section 5

---

## 4. API Contract Inventory

### Stub Files vs FLOW.md Cross-Reference

| Stub File | FLOW.md Step | Contract Verified | Findings |
|-----------|-------------|-------------------|----------|
| `stubs/bcs-score.json` | Step 2 | [x] Partial match | F-01 (tier annotation), F-02 (missing grade), F-03 (missing scoring_tier), F-04/F-05 (field naming vs P-04 spec) |
| `stubs/story-build.json` | Step 3 | [x] Partial match | F-12 (missing review_required, platform_hints) |
| `stubs/photos-curate.json` | Step 4 | [x] Partial match | F-13 (flat vs structured selected[], missing rejected[]) |
| `stubs/video-coach.json` | Step 5 | [x] Match | F-14 (scope differs from H-02 spec — documented, not a bug) |
| `stubs/video-export.json` | Step 5 | [x] Match | F-15 (WAH-branded URLs in placeholder data) |
| `stubs/voice-transcribe.json` | Step 1 | [x] Match | Clean. |
| `stubs/coaching-packet.json` | Step 6 | [x] Partial match | F-09 (missing ai_assisted), F-10 (flat vs two-layer description), F-11 (missing key_asset) |
| `stubs/example-low-*.json` | Scoring edge cases | [x] Partial match | F-06 (total vs total_score), F-07 (inconsistent grade), F-08 (coaching_actions_triggered not in main stub) |

### Missing Stubs (Referenced in FLOW.md but no stub file)
- `/word/check` (Step 2b)
- `/story/refine` (Step 7)
- `/story/card` (Step 8)
- `/story/format` (Step 8)
- `/story/represent` (Step 9)
- `/video/direct` (Step 5 — live coaching)
- `/video/produce` (Step 5 — reel production)

---

## 5. Error Handling Strategy

### Pipeline Failure Modes

| Failure | Impact | Proposed Handling |
|---------|--------|-------------------|
| Voice transcription fails | Foster notes only — voice notes lost | Proceed without transcript; flag in coaching packet |
| Scoring fails (AI mode) | No gap diagnostic | Fall back to rule-based scoring (DEC-001) |
| Story build fails | No coached description | Return raw description + coaching actions from rubric |
| Photo curation fails | No curated selection or shot list | Return all photos unranked + generic shot list |
| Video pipeline fails | No produced reel | Return raw footage reference + manual shot agenda |
| Platform hints malformed | Hints ignored | Log warning, proceed with fallback chain |

### Principle
From FLOW.md: BCS "degrades gracefully." Thin input produces solid general coaching. Rich input produces targeted coaching. No API fails because optional data is missing.

---

## 6. Output Assembly — The Coaching Packet

The coaching packet (`stubs/coaching-packet.json`) is the single output contract. Every component contributes fields to it.

### Assembly Map

| Packet Field | Source Component | Required? |
|-------------|-----------------|-----------|
| `session_id` | Orchestrator | Yes |
| `version` | Orchestrator | Yes |
| `score_before` / `score_after` | Scoring Engine | Yes |
| `coached_description` | Story Builder | Yes (raw text fallback) |
| `photo_selection` | Photo Curation | No (empty array fallback) |
| `shot_list` | Photo Curation | No (generic fallback) |
| `video_coaching` | Video Pipeline | No (status: "not_started") |
| `next_steps` | Orchestrator (derived from gaps) | Yes |
| `presenter_brief` | Story Builder | No |
| `review_required` | Always `true` | Yes |
| `review_status` | Review UI | Yes |
| `dimensions_improved` | Score comparison | Yes |
| `ai_assisted` | Always `true` when AI was used (Q-L2) | Yes |

### Export Formats (Q-P5)
- **v1 minimum:** PDF (printable). The coaching packet renders as a one-page brief.
- **Future:** Email, Word, other formats via pluggable export system.
- JSON remains the internal format. PDF is the human-facing export.
