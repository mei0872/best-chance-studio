# Stakeholder Questions — Non-Blocking

*Product, operations, and legal questions that inform architecture but don't block initial modeling. These can be answered as the architecture develops.*

*Last updated: March 7, 2026*

---

## Product

### Q-P1: Multi-language support
Will BCS need to support non-English descriptions or coaching? This affects text processing, word-check rules, and LLM prompt design.

### Q-P2: Rescue onboarding flow
What does a rescue's first interaction with BCS look like? Self-serve? Invited? This shapes the auth model and initial data seeding.

### Q-P3: Foster vs coordinator roles
FLOW.md describes both fosters (submit, approve) and coordinators (review, present). Are these distinct user roles with different permissions, or is it fluid?

### Q-P4: Re-presentation trigger
Who/what triggers `/story/represent` in standalone mode? The foster manually? A time-based rule ("7 days without placement → re-present")? A coordinator?

### Q-P5: Coaching packet export format
The packet is JSON in the stubs. Do fosters/coordinators need it as PDF? Printable page? Email? What's the minimum viable export?

---

## Operations

### Q-O1: Rubric update cadence
How often will rubric-config.json be updated? Per-quarter? Per-adoption-cycle? This affects config caching and version pinning strategy.

### Q-O2: Platform hints governance
When a platform proposes a rubric update based on outcome data (described in FLOW.md), who reviews and approves? Is there a formal RFC process?

### Q-O3: Monitoring in standalone mode
How do we know if standalone BCS instances are working? Error reporting? Usage telemetry? Or is it fully offline with no phone-home?

---

## Legal / Compliance

### Q-L1: Dog photo rights
Who owns the photos and videos processed through BCS? The foster? The rescue? Does BCS retain any copies?

### Q-L2: AI-generated content disclosure
Do AI-coached descriptions need to be labeled as AI-assisted? Some platforms may require disclosure.

### Q-L3: YouTube credential scope
FLOW.md mentions OAuth for YouTube upload via rescue registration. What's the minimum OAuth scope needed? Who manages token refresh?
