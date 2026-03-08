# AI Usage Logging — BCS Spec

*Last updated: March 8, 2026*

---

## The Principle

BCS costs money to run. Over time, the spec should get cheaper — not through arbitrary cuts, but through real data on what things actually cost in production.

The mechanism is the same one used for rubric improvement: implementors log usage in a standard format, aggregate findings flow back to the community, the spec updates.

**BCS defines the logging interface. Implementors do the logging. The community uses the data to optimize the spec.**

---

## The Requirement

Every BCS implementation that makes AI API calls SHOULD log usage per call in the following format:

```json
{
  "api":              "string",    // e.g. "/bcs/score", "/story/build"
  "model":            "string",    // provider + model name used
  "tokens_in":        "number",
  "tokens_out":       "number",
  "estimated_cost":   "number",    // USD, based on provider's published pricing
  "duration_ms":      "number",    // wall time for the call
  "complexity_hint":  "string",    // "simple" | "standard" | "complex"
  "rubric_version":   "string",    // from rubric-config.json
  "timestamp":        "string"     // ISO 8601
}
```

**SHOULD, not MUST.** Logging is not required for BCS to function. But implementations that log and contribute findings back to the community make every future implementation cheaper.

---

## What Happens With the Data

Usage logs stay with the implementor. BCS does not collect telemetry.

When an implementor notices a meaningful pattern — a call that costs more than the spec estimated, a cheaper model that performs equivalently, a prompt that's burning unnecessary tokens — they contribute a finding back via the [RFC Discussion](https://github.com/mei0872/best-chance-studio/discussions/17) or a spec proposal.

The community reviews. If the data holds up, the spec updates:
- Revised cost estimates in [`docs/ai-credentials.md`](ai-credentials.md)
- Updated `complexity_hint` recommendations per API
- Model recommendations added to the provider abstraction guidance

**The spec gets cheaper every time a real-world implementation contributes a finding.**

---

## Cost Optimization Over Time

The current per-dog cost estimate ($0.25–$0.55) is a starting hypothesis based on 2026 model pricing. It will change. The optimization loop:

```
Spec ships with baseline cost estimates
  ↓
Implementations run in production, log usage
  ↓
Patterns emerge: actual costs, model performance, token efficiency
  ↓
Community proposes optimizations (cheaper model, tighter prompt, fewer refinement rounds)
  ↓
Spec updates with new estimates + recommendations
  ↓
Every future implementation benefits
```

Areas most likely to yield savings over time:
- **`/photos/curate`** — vision model calls are the highest per-call cost; cheaper vision models are improving fast
- **`/story/refine`** — if average refinement rounds > 2, the prompt needs tightening, not the model
- **`/bcs/score`** — rule-based scoring for obvious dimensions could replace AI calls for lower-scoring dogs
- **`/video/coach`** — frame sampling rate is the key cost lever; finding the minimum effective rate is worth measuring

---

## What This Is Not

This is not a telemetry system. BCS does not phone home. There is no central usage database.

This is a community feedback loop — the same one used for rubric improvements. Implementors observe, document, and share. The spec improves. That's it.
