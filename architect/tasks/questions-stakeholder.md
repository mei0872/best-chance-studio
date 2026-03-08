# Stakeholder Questions — Non-Blocking

*Product, operations, and legal questions that inform architecture but don't block initial modeling. Updated March 7, 2026.*

*Status key: RESOLVED (assumption made, can pivot) | OPEN (needs stakeholder answer) | DEFERRED (needs research)*

---

## Product

### Q-P1: Multi-language support — RESOLVED
Will BCS need to support non-English descriptions or coaching?

**Assumption:** Yes. Text processing, word-check rules, LLM prompts, and coaching actions must be designed for multi-language support.

### Q-P2: Rescue onboarding flow — RESOLVED
What does a rescue's first interaction with BCS look like?

**Assumption:** Self-serve registration flow. Rescues may be invited, but all register through the same self-serve process. BCS needs a registration flow with identity creation and sensible zero-config defaults for new rescues.

### Q-P3: Foster vs coordinator roles — RESOLVED
Are fosters and coordinators distinct user roles?

**Assumption:** Yes, distinct user roles with different permissions. The auth model needs role-based access control.

### Q-P4: Re-presentation trigger — OPEN
Who/what triggers `/story/represent` in standalone mode? The foster manually? A time-based rule ("7 days without placement → re-present")? A coordinator?

**Needs stakeholder input.** Architecture should support multiple trigger mechanisms so this can be decided later without rework.

### Q-P5: Coaching packet export format — RESOLVED
What export formats do fosters/coordinators need?

**Assumption:** PDF is the minimum viable export (printable). Email and other formats (Word, etc.) are later features. Architecture should support a pluggable export format system so adding formats is straightforward.

---

## Operations

### Q-O1: Rubric update cadence — OPEN
How often will rubric-config.json be updated?

**Needs stakeholder input.** Architecture will design for flexibility — version-pinned scores and a config loader that can pull updates when available. Whether that's weekly or quarterly doesn't block the design.

### Q-O2: Platform hints governance — OPEN
When a platform proposes a rubric update based on outcome data, who reviews and approves?

**Needs stakeholder input.** Governance process TBD as the community grows (noted in FLOW.md as well).

### Q-O3: Monitoring in standalone mode — RESOLVED
How do we know if standalone BCS instances are working?

**Assumption:** Systems will need some form of internet connectivity for updates. Not fully dark/offline-only. This opens the door for opt-in error reporting or usage telemetry as a later feature.

---

## Legal / Compliance

### Q-L1: Dog photo rights — RESOLVED
Who owns the photos and videos processed through BCS?

**Assumption:** The individual taking the photo retains rights. Use of BCS constitutes a license for BCS to use the photos and videos. Legal language (terms of service / usage agreement) will need to be drafted. Aligns with Q-D3 — BCS is the source of record for media under this license.

### Q-L2: AI-generated content disclosure — RESOLVED
Do AI-coached descriptions need to be labeled as AI-assisted?

**Assumption:** Yes. All AI-coached content must be disclosed as AI-assisted. The coaching packet and exported descriptions should carry an AI-assisted label.

### Q-L3: YouTube credential scope — DEFERRED
What's the minimum OAuth scope needed for YouTube upload? Who manages token refresh?

**Needs research** when video export (H-04) work begins. Requires investigation of YouTube Data API v3 scopes and the minimum permissions for upload, thumbnail, and metadata operations.
