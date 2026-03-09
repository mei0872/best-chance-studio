# AI Credential Management — BCS Spec

*Last updated: March 9, 2026*

---

## The Commitment

BCS is built for rescues. AI-powered features should never be a cost burden on the organizations doing the work.

For rescues using any BCS tool, this means zero setup, zero billing, zero friction — regardless of which platform or implementation they're using. The charity pool is for rescues, not tied to any single platform.

How that commitment is fulfilled depends on the implementation — but the commitment itself is universal.

---

## The Principle

BCS is free. The AI services it runs on are not.

Running BCS with AI-powered features requires valid credentials from an AI provider (OpenAI, Anthropic, or a local model like Ollama). Those credentials — and the costs that come with them — belong to the implementor, not to BCS.

**BCS does not provide, subsidize, or manage AI credentials.** This is intentional. BCS is an open source standard. Who pays for the AI that runs it is the implementor's business decision, not the spec's.

---

## The Requirement

**Every BCS implementation that uses AI-powered APIs must:**

1. Provide a setup flow that collects valid AI provider credentials from the user before any AI-powered feature is invoked
2. Store credentials securely (never in plaintext in localStorage, never committed to source)
3. Fail gracefully when credentials are absent or invalid — with a clear prompt to complete setup, not a raw API error
4. Make the credential requirement transparent to the user before they start — no surprises mid-session

**The UX of setup is the implementor's decision.** The spec requires the *outcome* (valid credentials, secure storage, graceful failure), not the exact flow.

---

## For Standalone Implementations — BYOK

This section is for **developers and implementors building BCS tools** — not for rescues who are end users.

If you're a rescue using a BCS tool, you should never need to set up your own API key. That's the developer/implementor path.

For implementors building standalone BCS tools, the recommended pattern is **Bring Your Own Key (BYOK)**:

### Step 1 — First-run detection
On first launch (or when credentials are absent), intercept before any AI feature runs and show the setup screen.

### Step 2 — Provider selection + key entry
```
Which AI provider do you use?
○ OpenAI  ○ Anthropic  ○ Local (Ollama)

API Key: [________________________]

[Get a free OpenAI key →]   [Save & Continue]
```

The "Get a free key" link goes directly to the provider's API key page. The setup screen explains — in plain language, not developer terms — what the key is for and approximately what it will cost.

### Step 3 — Validation + storage
Test the key with a minimal API call before saving. Store in browser's secure storage (not localStorage). Show a clear success state before proceeding.

**Target:** A developer or implementor should complete setup in under 3 minutes.

---

## Cost Transparency

The setup flow should include clear cost expectations. Suggested language:

> *"Running BCS with AI costs approximately $0.25–$0.50 per dog coaching session. A rescue running 40 dogs per week would spend roughly $10–$20/week on AI. Your API key connects directly to your provider account — BCS never sees your payment details."*

Actual cost varies by provider, model selection, and pipeline depth. Use the estimate from [DEC-005](https://github.com/mei0872/best-chance-studio/discussions/15) as the baseline.

---

## Platform Implementations

A platform may choose to manage AI credentials server-side, making them invisible to the end user. In that case:

- The rescue or adopter never sees an API key or a per-session bill
- The platform absorbs AI costs as part of its service model
- The BCS spec requirement is still satisfied — credentials exist, are secure, and failures are handled gracefully — just managed at the platform layer instead of the user layer

Our commitment is that any rescue using BCS — on any platform or tool — should never pay for AI out of pocket. The charity pool is the mechanism. Platform implementations that draw from it satisfy this commitment automatically.

This is the implementor's business decision. The spec is silent on pricing models.

---

## The Charity Funding Model

BCS maintains a charity AI pool funded through platform partnerships and contributions. When live, this pool will cover AI costs for rescues using BCS tools — on any platform, through any implementation. Free for rescues means free everywhere.

This pool is not a platform feature. It's a commitment to the rescue community that exists independent of any specific implementation or partner. Implementors who draw from the pool on behalf of their rescue users are fulfilling the BCS mission.

Details on pool access and eligibility will be published separately.

---

## Local Model Support (Ollama)

For technically capable rescues or development environments, [Ollama](https://ollama.com) provides a free, local model option with zero API costs.

Setup: install Ollama, pull a compatible model, point BCS at `http://localhost:11434`. No key required.

This is a valid way to satisfy the credential requirement. Recommended for:
- Contributors developing BCS locally (zero-cost dev environment)
- Technically capable rescues who prefer on-premises AI
- Offline deployments where cloud connectivity isn't reliable

Quality will vary from cloud models. Test against the Moose example in FLOW.md to establish a baseline.

---

## What the Spec Does Not Prescribe

- Which AI provider to use
- How much to charge users (or whether to charge at all)
- Whether to offer free tiers, credits, or subsidies
- How to handle billing disputes or usage overages

These are business decisions for the implementor. BCS provides the interface. What runs through it is up to you.
