# DEC-005: AI Cost Model

**Status:** Open
**Date:** 2026-03-07
**Decider:** Stakeholder
**Model(s):** Technical, Software

---

## Context

BCS uses AI for multiple APIs: story building, scoring, photo curation, video coaching, video direction, re-presentation. Each call to an LLM or vision model costs money. For a rescue running 40 dogs through BCS, the per-dog cost matters.

The current stubs don't specify which AI provider or model to use. This is intentional — BCS is open source and shouldn't be locked to one provider. But the architecture needs to account for cost targets and provider abstraction.

Key question: what's an acceptable cost to produce one complete coaching packet for one dog?

---

## Options

### Option A: Single provider, no abstraction

**How it works:**
- Pick one LLM provider (e.g., Anthropic, OpenAI). Build all AI calls against their API.
- No abstraction layer. Direct API calls with provider-specific SDKs.
- Cost is whatever that provider charges.

**Pros:**
- Simplest to build. No abstraction overhead.
- Can optimize prompts for one model's strengths.
- Fewer dependencies.

**Cons:**
- Vendor lock-in. Provider price changes affect every rescue.
- Different rescues may have accounts with different providers.
- Can't take advantage of cheaper models for simpler tasks.
- Open source contributors may not have access to the chosen provider.

### Option B: Provider abstraction layer

**How it works:**
- Define an internal interface for AI capabilities: `generateText()`, `analyzeImage()`, `transcribeAudio()`.
- Implement adapters for multiple providers (Anthropic, OpenAI, Ollama for local, etc.).
- Config selects provider per capability. Could use a cheap model for word-check and an expensive model for story-build.

**Pros:**
- No vendor lock-in. Rescues choose their provider.
- Task-appropriate model selection (cheap for simple, capable for complex).
- Local model support (Ollama) enables fully offline AI (overlaps with DEC-001).
- Contributors can use whatever provider they have access to.

**Cons:**
- Abstraction layer adds complexity.
- Prompt engineering may need per-provider tuning.
- Testing matrix expands (N providers x M capabilities).
- Maintenance burden — new providers, deprecated models.

### Option C: Tiered model strategy (within one abstraction)

**How it works:**
- Provider abstraction (Option B) with explicit cost tiers:
  - **Tier 1 (free/cheap):** Rule-based or tiny model. Word-check, basic scoring, format conversion.
  - **Tier 2 (moderate):** Standard model. Story building, photo curation.
  - **Tier 3 (premium):** Best available model. Re-presentation with complex history reasoning, AI Director real-time coaching.
- Config maps each API to a cost tier. Tier overrides allow rescues to upgrade/downgrade per API.

**Pros:**
- Explicit cost management per API call.
- Rescues can run budget-constrained (all Tier 1-2) or full-quality (Tier 3 everything).
- Makes cost-per-dog calculable and transparent.
- Natural alignment with offline tiers (Tier 1 = offline capable).

**Cons:**
- Most complex to configure.
- Quality varies by tier — need to set expectations.
- Tier definitions may not map cleanly to all providers' pricing.

---

## Cost Estimation

Rough per-dog cost estimates (based on 2026 LLM pricing, full pipeline):

| API Call | Tokens (est.) | Cost at $3/M input, $15/M output | Notes |
|----------|--------------|-----------------------------------|-------|
| `/bcs/score` (AI) | ~2K in, ~1K out | ~$0.02 | Gap analysis across 9 dimensions |
| `/word/check` | 0 (rule-based v1) | $0.00 | Lookup table |
| `/story/build` | ~3K in, ~1K out | ~$0.02 | Narrative generation |
| `/story/refine` (x2 avg) | ~2K in, ~500 out x2 | ~$0.03 | Iterative refinement |
| `/photos/curate` | Vision model call | ~$0.05-0.15 | Per-image analysis |
| `/story/represent` | ~5K in, ~1K out | ~$0.03 | History reasoning |
| `/video/coach` | Vision model call | ~$0.10-0.30 | Video analysis |
| **Total estimate** | | **~$0.25-0.55 per dog** | Excludes video production/direction |

Video direction (H-01) is a special case — real-time, potentially many calls per session. Could be $1-5+ per video session depending on frame analysis frequency.

---

## Tradeoffs

| Factor | A: Single provider | B: Abstraction | C: Tiered |
|--------|-------------------|----------------|-----------|
| Build complexity | Low | Medium | High |
| Vendor lock-in | Yes | No | No |
| Cost control | Limited | Provider-level | Per-API |
| Local model support | No | Yes | Yes |
| Contributor access | Restrictive | Flexible | Flexible |
| Maintenance | Low | Medium | High |

---

## Recommendation

**Option B: Provider abstraction layer** — with cost awareness built into the interface, not a separate tier system.

Each AI call specifies a `capability` (text-generation, image-analysis, speech-to-text) and a `complexity` hint (simple, standard, complex). The adapter picks the appropriate model from the configured provider. This gives cost control without the rigidity of explicit tiers.

Start with two adapters: one cloud provider (Anthropic or OpenAI) and Ollama (local). Contributors can develop against Ollama with zero API costs. Production rescues use cloud.

Target: **< $0.50 per dog** for a full pipeline run (excluding video direction). Video direction budget TBD based on H-01 prototype results.

---

## Decision

[Awaiting stakeholder input]

---

## Consequences

If Option B:
- Define `AICapability` interface: `generateText(prompt, complexity)`, `analyzeImage(image, prompt)`, `transcribeAudio(audio)`
- Implement at least two adapters: cloud provider + Ollama
- Config file maps provider + model per capability
- Prompts stored as templates (hardprompts/) — adapter injects model-specific formatting
- Cost tracking: each AI call logs estimated cost for monitoring
- Contributors documented: "run Ollama locally for zero-cost development"
