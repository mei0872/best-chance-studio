# Building on BCS

*Last updated: March 9, 2026*

---

BCS is MIT licensed. Build on it, wrap it, extend it, integrate it — the spec is yours to use.

This document covers the rules and expectations for implementations that use BCS APIs.

---

## Must (hard requirements)

**Human-in-the-loop approval**
Nothing publishes without rescue user approval. `review_required: true` is returned by every story-generation API for a reason — it must be honored. No implementation may auto-publish a coached story. A rescue coordinator, foster, shelter lead, or volunteer must review and approve before any coached content goes live.

**Secure credential handling**
AI credentials must be collected before AI features run and stored securely. Never in plaintext, never committed to source. See `docs/ai-credentials.md` for the full spec.

**Graceful failure**
BCS failures must be handled gracefully. No raw API errors shown to rescue users. If a session fails, the user gets a clear, human message — not a stack trace.

**Community-funded acknowledgment**
Any implementation drawing from the BCS community AI pool must display a visible "Community-funded" acknowledgment linking to [opencollective.com/best-chance-studio](https://opencollective.com/best-chance-studio). One line or badge is sufficient.

---

## Should (strong recommendations)

**Contribute findings back**
Aggregate insights from real usage — patterns worth acting on, rubric proposals, AI cost findings — should be contributed back to the community. See `CONTRIBUTING.md`.

**Surface boilerplate detection**
When `/bcs/score` returns `detected_boilerplate[]`, surface it to the user. Don't discard it silently.

**Log AI usage in standard format**
See `docs/ai-usage-logging.md`. This is how the spec gets cheaper over time.

---

## May (explicitly permitted)

**Build proprietary platforms**
You may build commercial products on top of BCS. The spec is MIT licensed. Your platform, your business model.

**Extend the spec**
You may add fields, endpoints, and features for your platform's needs. Extensions don't need community approval. Changes to the core spec do.

**Use any AI provider**
BCS is provider-agnostic. OpenAI, Anthropic, local models — your choice.

---

## Must Not

**Claim ownership of the spec**
You may not present yourself as the BCS maintainer project or claim ownership of the BCS spec. You may say: *"built on BCS"* · *"powered by Best Chance Studio"* · *"implements the BCS spec"* — always with a link back to this repo.

**Modify the rubric unilaterally**
The rubric is community-owned. Changes follow the governance process in `GOVERNANCE.md`. A platform may extend the rubric locally but may not call it "the BCS rubric" if it diverges from the community-maintained spec.

**Auto-publish coached stories**
See above. `review_required: true` is not optional.

---

## Questions?

→ [GitHub Discussions](https://github.com/mei0872/best-chance-studio/discussions)
→ [GOVERNANCE.md](GOVERNANCE.md)
→ [CONTRIBUTING.md](CONTRIBUTING.md)
