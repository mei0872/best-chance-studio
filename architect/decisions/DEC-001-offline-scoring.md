# DEC-001: Offline Scoring Strategy

**Status:** Decided
**Date:** 2026-03-07
**Decider:** App owner (via G-01 task spec)
**Model(s):** Technical, Software

---

## Context

`/bcs/score` is the first API call in every pipeline run. It produces the gap diagnostic that drives every subsequent decision. If scoring requires an LLM, the solo foster at midnight with no signal can't even start.

CONTRIBUTING.md says: "One photo + one sentence → still produces something useful." The scoring engine is the gateway to "something useful."

The rubric (`rubric-config.json`) defines 9 dimensions with clear scoring criteria (0/1/2 per dimension) and deterministic coaching actions per score level. This means a rule-based scorer could produce a reasonable diagnostic without any AI — but an AI scorer could catch nuance a rule-based system misses.

### G-01 Task Spec (Owner-Defined)

The app owner has already spec'd the core scorer as task G-01:

- **Tier:** Core — Grab & Go (2-4 hours)
- **Stack:** Plain HTML + vanilla JS. No framework. Works offline.
- **Deliverable:** `bcs-scorer.html` — self-contained, no build step.
- **What it does:** Rescuer inputs a dog's profile across key dimensions, tool outputs a score, grade, and top gaps to improve.
- **Why it matters:** "This is the heart of Best Chance Studio. Every rescue uses this before every presentation."

This spec confirms the rule-based offline scorer is not a theoretical option — it is the defined first deliverable. The scorer must work as a single HTML file with no connectivity, no API calls, and no build step. AI-enhanced scoring is a separate, additive capability.

---

## Options

### Option A: Two-tier scoring (rule-based offline + AI-enhanced online)

**How it works:**
- **Tier 1 (offline):** A deterministic scorer applies heuristic rules to produce scores. Examples: `photo_count < 2 → visual_impact = 0`, `text.length < 50 → personality_hook = 0`, `video_present === false → video_presence = 0`. Coaching actions come directly from `rubric-config.json`.
- **Tier 2 (online):** An AI scorer analyzes the actual content — reads the description for personality depth, evaluates photo quality, assesses foster voice warmth. Overrides or refines Tier 1 scores.
- The coaching packet flags which tier produced the score: `"scoring_tier": "rule-based"` or `"scoring_tier": "ai-enhanced"`.

**Pros:**
- Works offline. Solo foster gets useful coaching immediately.
- Progressive enhancement — online makes it better, not required.
- Rule-based tier is deterministic, testable, zero-cost.
- Aligns with CONTRIBUTING.md's "build for the person with the least."

**Cons:**
- Two scoring paths to maintain.
- Rule-based scores will be less accurate — may misjudge dimensions like `foster_voice` or `family_vision` that require reading comprehension.
- UX complexity: explaining why scores change when connectivity returns.

### Option B: Single-tier AI scoring (online only)

**How it works:**
- `/bcs/score` always calls an LLM. No connectivity = no score.
- Offline mode shows the rubric and coaching actions (from `rubric-config.json`) but no diagnostic scores.

**Pros:**
- One scoring path. Simpler to build and maintain.
- Every score is high quality — no "partial" diagnostics.
- No confusion about score accuracy tiers.

**Cons:**
- Offline is severely degraded — the foster gets a rubric checklist but no diagnostic.
- Fails the "one photo + one sentence → something useful" test unless "useful" excludes scoring.
- Every score costs money (LLM call).

### Option C: AI scoring with client-side model

**How it works:**
- Ship a small model (e.g., quantized classifier) that runs in the browser via WASM/WebGPU.
- Produces dimension scores locally. No API call needed.

**Pros:**
- True offline AI scoring.
- Single scoring path.
- No per-score API cost.

**Cons:**
- Significant engineering complexity (model training, WASM packaging, mobile performance).
- Model quality likely lower than cloud LLM for nuanced dimensions.
- Large initial download for the model weights.
- Maintenance burden — model must be retrained when rubric updates.

---

## Tradeoffs

| Factor | A: Two-tier | B: AI only | C: Client-side model |
|--------|------------|------------|---------------------|
| Offline support | Full | Degraded | Full |
| Scoring quality | Good (offline) / High (online) | High | Medium |
| Build complexity | Medium (two paths) | Low | High |
| Per-score cost | $0 offline / ~$0.01-0.05 online | ~$0.01-0.05 | $0 |
| Maintenance | Two code paths | One code path | Model retraining |
| Foster UX | Immediate feedback always | Blocked without signal | Immediate feedback always |

---

## Recommendation

**Option A: Two-tier scoring.** The offline requirement is non-negotiable for the solo foster use case. A rule-based Tier 1 scorer that checks photo count, text length, video presence, and keyword patterns can accurately score at least 5 of 9 dimensions (visual_impact, video_presence, compatibility_clarity, no_surprises, story_first_gate). The subjective dimensions (personality_hook, foster_voice, family_vision) get conservative scores offline and refined scores online.

The coaching actions from `rubric-config.json` are deterministic regardless of tier — the foster always knows what to do next. The score is the diagnostic; the coaching actions are the value.

---

## Decision

**Option A: Two-tier scoring.** Confirmed by G-01 + P-04 task specs together.

- **Tier 1 (G-01):** `bcs-scorer.html` — self-contained, offline, vanilla JS. Rule-based scoring for offline use.
- **Tier 2 (P-04):** `/bcs/score` API — the authoritative scorer. Receives the full listing package (story text, actual photos, actual video) and does AI-powered analysis across all dimensions.

Per P-04 spec: "G-01 should call this API rather than implement scoring logic directly." This means G-01 has two modes:
1. **Offline:** Rule-based fallback scoring (deterministic, zero-cost)
2. **Online:** Delegates to P-04 API for authoritative AI-enhanced scoring

The two tiers share the same rubric dimensions and output the same score format. P-04 is the single source of truth when available.

### Rubric Contract (Resolved)

P-04 spec referenced "10 dimensions, max score 20" — confirmed as a typo. The canonical source is `rubric-config.json`: **9 dimensions, max score 18**. Grade thresholds per rubric-config.json:
- 16-18 → A+ | 12-15 → A | 8-11 → B | 5-7 → C | 0-4 → D

---

## Consequences

- **G-01 (`bcs-scorer.html`) is the Tier 1 (offline fallback) implementation.** Rule-based, deterministic, single HTML file. Delegates to P-04 when available.
- **P-04 (`/bcs/score` API) is the Tier 2 (authoritative) implementation.** AI-powered, receives full listing package (text + photos + video), returns structured score.
- `rubric-config.json` (9 dimensions, max 18) is the single source of truth for all scoring tools.
- P-01 (Coaching Packet Generator) calls P-04 for scoring — or falls back to G-01's rule-based logic if offline.
- `/story/build` calls P-04 internally — scoring is always consistent across the pipeline.
- Coaching packet includes `scoring_tier` field (`"rule-based"` or `"ai-enhanced"`) so downstream tools know what produced the score.
- The "two paths to maintain" con is mitigated: G-01 contains lightweight fallback logic, P-04 is the real scorer. Not two parallel implementations.
