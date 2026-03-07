# Governance — Best Chance Studio™

*Last updated: March 7, 2026*

> We're being transparent about how this project is governed — including the parts that are still being figured out. We'd rather be clear about where we are than overstate a governance structure we haven't built yet.

---

## Where We Are

Best Chance Studio is early. The project is open source. The community is forming.

Right now, governance is simple: Wag On Home (WAH) maintains the project, reviews contributions, and sets direction. As the community grows, that will evolve — and this document will evolve with it.

We're not hiding that. We're being explicit about it so you know what you're getting into before you contribute.

---

## License

**MIT.** Full stop.

The code is yours. Fork it, use it, build on it, ship it. If Wag On Home disappears tomorrow, the code and methodology belong to the community. That's not a marketing promise — it's what the license says.

→ [LICENSE](LICENSE)

---

## The WAH / BCS Relationship

Wag On Home is building Best Chance Studio — and running a proprietary adoption platform on top of it. Here's what that means in practice:

**What WAH commits to:**
- BCS stays free. Forever. For every rescue. No matter what platform they post on.
- WAH contributes back — engineering time, rubric improvements informed by real outcome data, schema proposals
- The coaching methodology belongs to the community, not to WAH
- No feature of BCS will ever be pulled behind a paywall

**What WAH keeps proprietary:**
- The Wag On Home adoption platform
- Outcome data (days-to-home, near-miss signals, match quality — privacy and competitive reasons)
- The intelligence layer that feeds `platform_hints` — the *data* behind the hints, not the schema
- Rescue relationships and adoption platform integrations

**The clean line:**
BCS is the open source coaching and scoring layer. WAH is the platform that connects dogs to families. They work together. They're governed separately.

---

## How Contributions Work

### Code contributions (APIs, tools, bug fixes)

Standard open source process:

1. Pick a task from [pull-list.md](pull-list.md) or open an issue
2. Fork the repo, build to spec
3. Open a PR with a clear description of what you built and how you tested it
4. A maintainer reviews — feedback within a week for active tasks
5. Merged when it passes the bar

**The bar:** Meets the security requirements. Passes the spec. Real dogs will use this — build it that way.

No coordination required before starting. No application. No standups. Pick something, build it, submit it.

### Rubric updates (dimension weights, new scoring dimensions)

Rubric updates are governed differently from code contributions — because they're data claims, not just code opinions.

The rubric is the scientific core of BCS. A weight change that says "personality_hook matters 40% more than we thought" isn't an engineering decision — it's a research claim. It needs to be backed by data and validated by the community.

**Who can propose a rubric update:**
Any platform or researcher with real adoption outcome data. WAH will be the primary contributor at first — we have the outcome data. But this is explicitly designed for others to contribute as they build platforms with real data.

**How a rubric proposal works:**
1. Open a `Rubric Proposal` issue with:
   - Proposed change (dimension, weight, or new dimension)
   - Supporting methodology — aggregate findings, sample size, what was measured
   - Raw data not required (privacy), but methodology must be reproducible
2. Community review period: **minimum 2 weeks**
3. Counter-proposals welcome — if you have data that says otherwise, publish it
4. Merged by maintainers after review consensus
5. Ships as a semver version bump

**Versioning:**
```
rubric_version: "1.0.0"   ← major.minor.patch
                              major = new/removed dimensions (potentially breaking)
                              minor = weight adjustments (non-breaking)
                              patch = wording/clarity fixes
```

Every `/bcs/score` response includes `rubric_version`. You can pin to any prior version. We don't force upgrades.

### `platform_hints` schema updates

`platform_hints` is the open schema through which any platform can pass intelligence into BCS tools. The schema is community-owned. WAH proposes extensions (because we use it most), but any platform can propose new fields.

Rules:
- New fields are always additive — nothing removed, nothing renamed
- All tools must ignore fields they don't recognize (the ignore-unknown-fields rule)
- No field is ever required — `platform_hints` absent = standalone mode, always works
- Proposals follow the same PR process as code

→ Full schema: [platform-hints-schema.md](https://github.com/mei0872/wag-on-home-workspace)

---

## Who Makes Decisions

**Right now:** WAH maintainers. We're transparent about this. The project is new, the community is forming, and having a clear decision-maker is better than fake consensus at this stage.

**As the community grows:** We expect to move toward a model with a technical steering committee — contributors with significant track records who share decision-making. We'll document that transition when it happens.

**The one thing that won't change:** The MIT license. The code and methodology belong to the community regardless of what WAH does.

---

## What Happens If WAH Changes Direction

The MIT license is the answer. The community owns the code. Fork it, continue it, build on it — no permission required.

We're not planning for that scenario. We're being transparent that the license protects you regardless.

---

## Open Questions (Being Figured Out)

These are open. We'd rather name them plainly than pretend they're resolved:

- [ ] **Formal steering committee** — when does the community get a formal governance role? What does that look like?
- [ ] **Rubric proposal process** — the model above is v1. It'll be refined as real proposals come in.
- [ ] **Data sharing** — can WAH publish anonymized, aggregate outcome data to help the community validate rubric proposals? Working through privacy and competitive considerations.
- [ ] **Foundation model** — at some point, does BCS benefit from being under a neutral foundation (like Apache, Linux Foundation)? TBD when the community is large enough to warrant it.
- [ ] **Other platforms contributing outcome data** — as other adoption platforms build on BCS, can they also propose rubric updates? Yes — that's the intent. Process TBD.

---

## Contact

Questions about governance, contribution process, or the WAH/BCS relationship:

→ KipMeierhofer@gmail.com
→ [GitHub Issues](https://github.com/mei0872/best-chance-studio/issues)
