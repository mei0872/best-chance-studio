# Software Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Section headers and key concerns established. Detail to be filled as Phase 1 tasks complete.*

---

## 1. Component Map

### Components by Pull List Category

**Core (G-series) — Self-contained, offline-capable**

| Component | Pull List | Input | Output | platform_hints |
|-----------|-----------|-------|--------|----------------|
| BCS Score UI | G-01 | Dog submission | Score diagnostic + coaching actions | — |
| Rubric Config Loader | G-02 | `rubric-config.json` | Parsed config object | — |
| Voice Transcription | G-03 | Audio file (m4a) | Text transcript | — |
| Word Check | G-04 | Raw description text | Flagged words + clean version | Future: `learned` |
| Story Card Generator | G-05 | Approved story + photo | Shareable image card | `photos.lead_shot` |
| Platform Formatter | G-06 | Approved description + target | Formatted text within char limits | `dog_context.urgency` |

**Project (P-series) — Working prototypes, may need connectivity**

| Component | Pull List | Input | Output | platform_hints |
|-----------|-----------|-------|--------|----------------|
| Coaching Packet Assembler | P-01 | All API responses | Complete coaching packet | `story`, `dog_context`, `learned` |
| Story Review + Refine UI | P-02 | Coached description | Approved/tweaked story | `story`, `campaign` |
| Photo Curation Engine | P-03 | Photos + score_context | Selected photos + shot list | `photos`, `director` |
| Scoring Engine | P-04 | Dog submission | Score response (per `bcs-score.json` stub) | `dog_context` |
| Story Builder | P-05 | Text + foster_notes + gaps | Coached description | `story`, `learned` |
| Re-Presentation Engine | P-06 | Session history + signals | Fresh coaching brief | `learned`, `dog_context`, `director` |

**High Bar (H-series) — Technical proof of concepts**

| Component | Pull List | Input | Output | platform_hints |
|-----------|-----------|-------|--------|----------------|
| AI Director | H-01 | Live camera feed + shot_agenda | Real-time coaching prompts | `director`, `campaign` |
| Video Coach | H-02 | Recorded footage + shot_agenda | Coverage analysis + next steps | `video`, `director` |
| Video Producer | H-03 | Raw footage + dog_info | Produced reel | `video`, `campaign` |
| Video Exporter | H-04 | Produced reel + target platform | Platform-ready file + metadata | `video` |

---

## 2. Orchestration Design

*Blocked by DEC-004 (orchestration location).*

### Orchestration Responsibilities (from FLOW.md)
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

### Key Design Decisions
- **Context threading**: The orchestrator must carry `score_context`, `priority_gaps`, and `platform_hints` through the entire pipeline. No API should have to re-fetch context.
- **Partial failure**: If `/photos/curate` fails but `/story/build` succeeds, the coaching packet should still assemble with what it has.
- **Idempotency**: Re-running the same session with the same inputs should produce the same coaching packet (modulo LLM non-determinism).

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

| Stub File | FLOW.md Step | Contract Verified |
|-----------|-------------|-------------------|
| `stubs/bcs-score.json` | Step 2 | [ ] |
| `stubs/story-build.json` | Step 3 | [ ] |
| `stubs/photos-curate.json` | Step 4 | [ ] |
| `stubs/video-coach.json` | Step 5 | [ ] |
| `stubs/video-export.json` | Step 5 | [ ] |
| `stubs/voice-transcribe.json` | Step 1 | [ ] |
| `stubs/coaching-packet.json` | Step 6 | [ ] |
| `stubs/example-low-*.json` | Scoring edge cases | [ ] |

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
