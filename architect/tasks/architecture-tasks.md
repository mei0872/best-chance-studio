# Architecture Tasks — Best Chance Studio

*Living document. Last updated: March 8, 2026.*

This tracks every architecture task across all 4 models. Tasks are organized by phase — foundation first, then decisions, then validation.

Legend: `[ ]` not started | `[~]` in progress | `[x]` done

---

## Phase 1: Foundation

### 1.1 Data Architecture

- [~] **Entity model** — Define all entities (Dog, Session, Rescue, Foster, CoachingPacket, Score, Media, ShotAgenda) with attributes and relationships. *Entities and relationships defined. Foster elevated to first-class entity (Q-P3). Dog identity resolved as rescue-scoped (DEC-003).*
- [~] **State machine** — Map session lifecycle: intake → scored → coached → reviewed → approved → published → re-presented. *States defined. Terminal gate clarified: only approved+published dogs enter inventory (Q-D2).*
- [~] **Versioning strategy** — How coaching packets, scores, and stories version across sessions (v1 → v2 → v3). *Strategy outlined. All session history retained with no truncation (Q-D1).*
- [~] **Storage strategy** — What lives where: client-side (LocalStorage/IndexedDB), file export, server DB, published dog inventory. *Categories defined. LocalStorage for v1 prototype (P-02 spec). IndexedDB + file export for production (DEC-002 decided). BCS is source of record for media (Q-D3).*
- [~] **Published dog inventory schema** — Schema for the persistent record of every dog that completes BCS (profile, story, score, publish date). *Minimum schema defined. Scope clarified: approved+published only (Q-D2). Foster PII stripped by default (Q-X2).*
- [~] **Session history model** — How `/story/represent` accesses prior sessions, what signals compound across versions. *History contract defined. All sessions retained (Q-D1).*

### 1.2 Technical Architecture

- [x] **Dependency graph** — Map all 14 APIs and their call dependencies (what calls what, what context propagates). *Fully mapped including H-03→H-04 internal dependency and P-04 as unifying scorer.*
- [~] **Offline tier definitions** — Classify every feature: works offline / works offline degraded / requires connectivity. *Three tiers proposed. DEC-001 decided (two-tier scoring). DEC-006 recommendation confirmed by task specs.*
- [~] **AI service catalog** — Which APIs need LLM calls, which are rule-based, estimated token costs per call. *Catalog complete. Provider abstraction required day 1 (Q-T2). Target < $0.50/dog.*
- [x] **Infrastructure options** — Standalone (static files) vs hosted (API server) vs hybrid deployment models. *Resolved: all deployment modes supported (Q-T1). Isomorphic architecture (DEC-004). Server-side orchestrator (Q-S1).*
- [~] **Mobile-first constraints** — Document 375px viewport, touch targets, camera/mic access patterns. *Technical requirements documented. Multi-language support required (Q-P1).*
- [~] **Performance budget** — Target load times, scoring latency, media processing benchmarks. *Proposed numbers exist. Need validation against real hardware.*

### 1.3 Software Architecture

- [x] **Component map** — All components, their boundaries, input/output contracts, and which `platform_hints` fields they consume. *Complete — updated with all task specs (G-01 through H-04). Stack, inputs, outputs, and hints documented per component.*
- [~] **Orchestration design** — How BCS sequences API calls, carries context, handles partial failures. *Two-layer model defined: Layer 1 (rule-based, client-side), Layer 2 (AI pipeline, server-side orchestrator per Q-S1). Data flow questions identified.*
- [x] **Config loading strategy** — How `rubric-config.json` and `platform_hints` are loaded, cached, and versioned. *Defined. platform_hints delivered as optional request body object (Q-S3).*
- [~] **API contract inventory** — Validate all stubs against FLOW.md; flag inconsistencies. *Cross-reference table built. 7 missing stubs flagged. Rubric discrepancy resolved (9 dimensions confirmed).*
- [~] **Error handling strategy** — What happens when one API in the pipeline fails mid-sequence. *Failure modes and graceful degradation documented.*
- [~] **Output assembly** — How the coaching packet is assembled from individual API responses. *Assembly map complete. PDF as v1 export format (Q-P5). AI disclosure field added (Q-L2).*

### 1.4 Security Architecture

- [~] **Threat model** — STRIDE analysis for BCS (standalone + platform-connected modes). *STRIDE table started. Updated with multi-rescue (Q-X1) and role escalation (Q-P3) threats.*
- [~] **PII inventory** — What personal data exists (foster names, dog locations, rescue contacts) and where it flows. *Inventory complete. Dog names not PII. Foster names are PII with standard protections (Q-X2). AI disclosure required (Q-L2).*
- [~] **Media security** — Photo/video storage, access control, retention policy. *BCS is source of record (Q-D3). Photographer retains rights, BCS license via ToS (Q-L1). Per-rescue access control (Q-X1). Retention policy still open.*
- [~] **Auth boundaries** — What's public (rubric), what's per-rescue (sessions), what's per-platform (hints, outcomes). *Boundaries defined. Auth model resolved: self-serve registration (Q-P2), RBAC with foster/coordinator roles (Q-P3), multi-rescue isolation (Q-X1).*
- [x] **platform_hints trust boundary** — How to validate hints from external platforms without trusting blindly. *Complete — validation rules, attack vectors, and mitigations documented.*
- [~] **Supply chain** — Dependencies, CDN resources, API keys, OAuth credentials scope. *Dependencies and credential management documented. YouTube OAuth scope deferred to H-04 build (Q-L3).*

---

## Phase 2: Decisions (ADRs)

Each decision blocks some part of implementation. Ordered by dependency.

- [x] **DEC-001: Offline scoring** — Two-tier (rule-based offline + AI online). **Decided.** G-01 is Tier 1 (offline), P-04 is Tier 2 (authoritative API). 9 dimensions, max 18 confirmed.
- [x] **DEC-002: Standalone persistence** — IndexedDB + file export for production. LocalStorage for v1 prototype. **Decided.** Export prompt must be unavoidable before storage-clearing actions. File export doubles as transport corridor mechanism.
- [x] **DEC-003: Dog identity** — Rescue-scoped with optional linking via microchip number. **Decided.** Transfer UX must include "Import session from prior rescue" prompt.
- [x] **DEC-004: Orchestration location** — Isomorphic: client-side tools standalone, server-side orchestrator for AI pipeline. **Decided.** Offline path must never return errors — always fall back to rubric-based coaching.
- [x] **DEC-005: AI cost model** — Provider abstraction required day 1. Target < $0.50/dog. BYOK credential flow. **Decided.** Per-call usage logging required. BCS spec silent on who pays.
- [x] **DEC-006: Offline media boundary** — Capture + guidance offline, AI processing online. **Decided.** Client-side brightness/orientation check in v1. Auto-sync queue is "later."

---

## Phase 3: Validation

- [x] **Models vs stubs** — Walk every stub file through the data and software models; confirm entities, contracts, and state transitions are consistent. *Complete — 15 findings documented below.*
- [ ] **Offline scenario walkthrough** — Trace the solo-foster-at-midnight scenario through all 4 models; identify gaps. *Deferred — do after G-01/G-02 exist.*
- [x] **Contract consistency audit** — Cross-reference FLOW.md step-by-step with stubs/, rubric-config.json, and platform-hints-schema.md. *Complete — findings merged into 3A/3B below.*
- [ ] **Contributor onboarding test** — Can a new contributor read the architecture docs and understand where their task fits? *Deferred — do after first deliverables land.*
- [ ] **Security review** — Walk the threat model through the standalone and platform-connected deployment modes. *Deferred — G-01/G-02 are stateless/offline, zero security surface. Do for P-02+.*

---

## Phase 3A Findings: Models vs Stubs

*Completed: March 8, 2026*

Each finding is categorized: **INCONSISTENCY** (must fix before build), **GAP** (missing field/data), **CLARIFICATION** (needs documentation, not a bug).

### F-01: `bcs-score.json` stub represents Tier 1 only — CLARIFICATION
The stub uses `photo_count` (integer) and `video_present` (boolean) — metadata indicators for rule-based scoring. P-04 spec in TASKS.md uses `photos?[ { url, caption? } ]` and `video?{ url }` — actual media for AI analysis. These are two different tiers per DEC-001. The stub should be annotated with `"_tier": "rule-based"` to prevent confusion. P-04 needs its own stub when built.

### F-02: `bcs-score.json` response missing `grade` field — GAP
The stub response has `total_score`, `max_score`, `dimensions[]`, `priority_gaps[]`, `coaching_summary` — but no `grade` field. Yet `rubric-config.json` defines `grade_thresholds` (A+ through D), and the G-01 spec explicitly requires grade output. FLOW.md Step 2 response also omits grade. **Action:** Add `grade` and `grade_label` to the stub response.

### F-03: `bcs-score.json` response missing `scoring_tier` — GAP
The coordination plan specifies G-01 output should include `scoring_tier: "rule-based"`. Not in the stub. **Action:** Add `scoring_tier` to stub response.

### F-04: P-04 spec uses `by_dimension` with `name`; stub uses `dimensions` with `id` — INCONSISTENCY
TASKS.md P-04 spec: `by_dimension: [ { name, score: 0|1|2, gap: string } ]`. Stub: `dimensions: [ { id, score, max, gap } ]`. Two naming differences: array key (`by_dimension` vs `dimensions`) and identifier field (`name` vs `id`). **Action:** Standardize on `dimensions` with `id` (matches rubric-config.json). Note for P-04 spec update.

### F-05: P-04 spec output uses `summary`; stub uses `coaching_summary` — INCONSISTENCY
Same concept, different field names. **Action:** Standardize on `coaching_summary` (more descriptive). Note for P-04 spec update.

### F-06: Example stubs use `total` instead of `total_score` — INCONSISTENCY
`example-low-all.json`, `example-low-description.json`, `example-low-video.json` all use `"total": N`. Main stub uses `"total_score": N`. **Action:** Update example stubs to use `total_score` for consistency.

### F-07: Example stubs inconsistent on `grade` field — INCONSISTENCY
`example-low-all.json` includes `"grade": "D"`. `example-low-description.json` and `example-low-video.json` omit it. All three should include `grade` once F-02 is resolved.

### F-08: Example stubs have `coaching_actions_triggered[]` not in main stub — GAP
All three example stubs include `coaching_actions_triggered` — an array of specific coaching prompts pulled from rubric-config.json. This field bridges scoring to coaching and is useful for G-01. Not present in `bcs-score.json` stub. **Action:** Add to main stub or document as example-only enrichment.

### F-09: `coaching-packet.json` stub missing `ai_assisted` field — GAP
software-architecture.md assembly map (section 6) specifies `ai_assisted: true` when AI was used (Q-L2 requirement). Not in the stub. **Action:** Add `ai_assisted: boolean` to stub.

### F-10: `coaching-packet.json` has flat `coached_description`; story-builder.md spec has two-layer — INCONSISTENCY
Stub: `"coached_description": "string"` (flat). Story-builder.md output contract: `"coached_description": { "portable": "string", "enriched": "string" }`. This is a structural mismatch. **Action:** The coaching packet stub should use the two-layer format to match the story-builder spec. Flat string is acceptable for G-01/P-01 (rule-based, no enriched layer yet), but the canonical packet contract should use the structured format.

### F-11: `coaching-packet.json` missing `key_asset` — GAP
Story-builder.md output contract includes `coaching_packet.key_asset` (string). Not in stub. **Action:** Add to stub.

### F-12: `story-build.json` stub missing `review_required` and `platform_hints` — GAP
P-05 spec output includes `review_required: true` (hardcoded). Stub response omits it. Stub request omits `platform_hints` (optional). **Action:** Add `review_required: true` to response. Add `platform_hints: {}` as optional field in request with comment.

### F-13: `photos-curate.json` stub shape doesn't match P-03 spec — INCONSISTENCY
Stub response: `selected: ["photo_001.jpg"]` (flat array) + separate `ordering: [1]`. P-03 spec: `selected: [ { url, order, reason } ]` (structured objects). Stub also missing `rejected[]` array (present in P-03 spec). **Action:** Update stub to match P-03 structured format, add `rejected[]`.

### F-14: `video-coach.json` stub has fields not in H-02 spec and vice versa — CLARIFICATION
Stub includes `agenda_coverage[]` and `next_session_priority` (from FLOW.md Step 5). H-02 spec mentions "suggested title + description" not in stub. The stub follows the FLOW.md pipeline contract; H-02 spec describes a broader standalone tool. Both are valid — document that the stub represents the pipeline-integrated contract, H-02 may extend it.

### F-15: `video-export.json` stub has WAH-branded URLs — INCONSISTENCY
Stub response includes `"exported_url": "https://storage.bcs.wagonhome.com/..."` and `"thumbnail_url": "https://storage.bcs.wagonhome.com/..."`. BCS is community-owned — no single implementor's domain should appear in reference stubs. **Action:** Replace with placeholder URLs (`https://storage.example.com/...` or similar).

---

## Phase 3B Findings: Contract Consistency Audit (FLOW.md vs Stubs)

*Completed: March 8, 2026*

### FLOW.md Step-by-Step Walkthrough

| Step | FLOW.md | Stub | Status | Notes |
|------|---------|------|--------|-------|
| 1 | `/voice/transcribe` | `voice-transcribe.json` | **Match** | Request/response identical. |
| 2 | `/bcs/score` | `bcs-score.json` | **Partial** | Request matches. Response missing `grade`, `grade_label`, `scoring_tier` (F-02, F-03). |
| 2b | `/word/check` | *missing* | **No stub** | Already flagged in software-architecture.md. |
| 3 | `/story/build` | `story-build.json` | **Partial** | Request matches minus `platform_hints`. Response missing `review_required` (F-12). |
| 4 | `/photos/curate` | `photos-curate.json` | **Partial** | Request matches. Response shape differs from P-03 spec (F-13). |
| 5a | video coaching prompt (no video) | *missing* | **No stub** | The "no video" path generates a coaching prompt + shot_agenda. No stub for this output. |
| 5b | `/video/coach` | `video-coach.json` | **Match** | Request/response consistent with FLOW.md. |
| 5c | `/video/produce` | *missing* | **No stub** | Already flagged. |
| 5d | `/video/export` | `video-export.json` | **Match** | Response matches FLOW.md + adds `destination{}`. |
| 6 | coaching packet assembly | `coaching-packet.json` | **Partial** | Missing `ai_assisted` (F-09), flat description vs two-layer (F-10). |
| 7 | `/story/refine` | *missing* | **No stub** | Already flagged. |
| 8a | `/story/card` | *missing* | **No stub** | Already flagged. |
| 8b | `/story/format` | *missing* | **No stub** | Already flagged. |
| 9 | `/story/represent` | *missing* | **No stub** | Already flagged. |

### Key Cross-Cutting Findings

**Tier 1 vs Tier 2 contract split (bcs-score):**
The `bcs-score.json` stub represents Tier 1 (rule-based, offline). The P-04 spec in TASKS.md represents Tier 2 (AI-enhanced, online). This is correct per DEC-001 but needs explicit documentation in the stub. When P-04 is built, it needs its own stub file (`stubs/bcs-score-ai.json` or annotated variant).

**Two-layer description output (story-builder):**
`story-builder.md` spec introduces `coached_description: { portable, enriched }`. Both `coaching-packet.json` and `story-build.json` stubs use a flat string. This must be resolved before P-02 and P-05 are built. Recommendation: update stubs to two-layer format now.

**7 missing stubs (already flagged):**
`/word/check`, `/story/refine`, `/story/card`, `/story/format`, `/story/represent`, `/video/direct`, `/video/produce`. These should be created as their respective pull list items are picked up — not blocking G-01/G-02.

**Video absent path (no stub):**
FLOW.md Step 5 describes a specific output when no video exists: `prompt_type: "video_absent"` with coaching prompt + `shot_agenda[]`. No stub captures this. Low priority — can be added when the video pipeline is built.

---

## Priority Resolution Order

For G-01/G-02 build (immediate, blocks UI/UX agent):
1. **F-02** — Add `grade` + `grade_label` to bcs-score.json stub
2. **F-06** — Fix `total` → `total_score` in example stubs
3. **F-07** — Add `grade` to all example stubs

For next stub update pass (before P-02/P-05):
4. **F-10** — Two-layer `coached_description` in coaching-packet.json
5. **F-13** — Structured `selected[]` + `rejected[]` in photos-curate.json
6. **F-04/F-05** — Standardize field names (P-04 spec alignment)
7. **F-12** — Add `review_required` + `platform_hints` to story-build.json
8. **F-09** — Add `ai_assisted` to coaching-packet.json
9. **F-11** — Add `key_asset` to coaching-packet.json
10. **F-15** — Remove WAH-branded URLs from video-export.json

For documentation only (no code change):
11. **F-01** — Annotate bcs-score.json as Tier 1
12. **F-03** — Add `scoring_tier` to stub
13. **F-08** — Document `coaching_actions_triggered` field
14. **F-14** — Document video-coach stub vs H-02 scope difference

---

## Dependencies Between Phases

```
Phase 1 Foundation ──→ Phase 2 Decisions ──→ Phase 3 Validation
        │                      │
        │  DEC-001 ←── DECIDED (G-01 + P-04)
        │  DEC-002 ←── DECIDED (IndexedDB + file export)
        │  DEC-003 ←── DECIDED (rescue-scoped + optional linking)
        │  DEC-004 ←── DECIDED (isomorphic)
        │  DEC-005 ←── DECIDED (provider abstraction + BYOK)
        │  DEC-006 ←── DECIDED (capture + guidance offline)
        │                      │
        └──────────────────────└──→ Implementation (pull list tasks)
```

**All 6 decisions are now decided.** Phase 1 is substantially complete — most tasks are in progress with key sections filled. Phase 2 is complete. Phase 3 validation can begin immediately — no remaining blockers.
