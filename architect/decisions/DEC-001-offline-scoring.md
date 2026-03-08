# DEC-001: Offline Scoring Strategy

**Status:** Open
**Date:** 2026-03-07
**Decider:** Stakeholder
**Model(s):** Technical, Software

---

## Context

`/bcs/score` is the first API call in every pipeline run. It produces the gap diagnostic that drives every subsequent decision. If scoring requires an LLM, the solo foster at midnight with no signal can't even start.

CONTRIBUTING.md says: "One photo + one sentence → still produces something useful." The scoring engine is the gateway to "something useful."

The rubric (`rubric-config.json`) defines 9 dimensions with clear scoring criteria (0/1/2 per dimension) and deterministic coaching actions per score level. This means a rule-based scorer could produce a reasonable diagnostic without any AI — but an AI scorer could catch nuance a rule-based system misses.

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

[Awaiting stakeholder input]

---

## Consequences

If Option A:
- Scoring engine needs a `ScoringStrategy` interface with two implementations
- `rubric-config.json` needs rule definitions added (thresholds, keyword lists)
- Coaching packet includes `scoring_tier` field
- Test suite must validate both tiers produce valid coaching packets
- UX must handle score refinement when connectivity returns
