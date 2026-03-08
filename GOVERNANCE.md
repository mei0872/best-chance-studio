# Governance — Best Chance Studio

*Last updated: March 8, 2026*

> We're being transparent about how this project is governed — including the parts that are still being figured out. We'd rather be clear about where we are than overstate a governance structure we haven't built yet.

---

## Where We Are

Best Chance Studio is early. The project is open source. The community is forming.

Right now, governance is simple: the founding team maintains the project, reviews contributions, and sets direction. As the community grows, that will evolve — and this document will evolve with it.

We're not hiding that. We're being explicit about it so you know what you're getting into before you contribute.

---

## License

**MIT.** Full stop.

The code is yours. Fork it, use it, build on it, ship it. If the founding team disappears tomorrow, the code and methodology belong to the community. That's not a marketing promise — it's what the license says.

→ [LICENSE](LICENSE)

---

## How This Project Works

Best Chance Studio is an open source spec and coaching methodology. Anyone can implement it, build on it, or ship proprietary products on top of it — that's what MIT allows and what we encourage.

**What the spec commits to:**
- BCS stays free. Forever. For every rescue. No matter what platform they post on.
- The coaching methodology belongs to the community, not to any one implementor
- No feature of the BCS spec will ever be pulled behind a paywall

**What implementors keep proprietary:**
Implementors may build proprietary platforms on top of BCS — including the founding team. That's the model. Implementors own their platforms, their data, and their integrations. BCS owns the spec.

**The clean line:**
BCS is the open source coaching and scoring layer. Platforms built on top of it are governed by their own teams. They work together. They're governed separately.

---

## How Contributions Work

### Code contributions (APIs, tools, bug fixes)

Standard open source process:

1. Pick a task from [TASKS.md](TASKS.md) or open an issue
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
Any platform or researcher with real adoption outcome data. The founding team will be an early contributor as real data is generated — but this is explicitly designed for others to contribute as they build platforms with real outcome data.

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

`platform_hints` is the open schema through which any platform can pass intelligence into BCS tools. The schema is community-owned. Any platform can propose new fields.

Rules:
- New fields are always additive — nothing removed, nothing renamed
- All tools must ignore fields they don't recognize (the ignore-unknown-fields rule)
- No field is ever required — `platform_hints` absent = standalone mode, always works
- Proposals follow the same PR process as code

→ Full schema: [platform-hints-schema.md](docs/platform-hints-schema.md)

---

## Who Makes Decisions

**Right now:** The founding team. We're transparent about this. The project is new, the community is forming, and having a clear decision-maker is better than fake consensus at this stage.

**As the community grows:** We expect to move toward a model with a technical steering committee — contributors with significant track records who share decision-making. We'll document that transition when it happens.

**The one thing that won't change:** The MIT license. The code and methodology belong to the community regardless of what any maintainer does.

---

## What Happens If the Founding Team Changes Direction

The MIT license is the answer. The community owns the code. Fork it, continue it, build on it — no permission required.

We're not planning for that scenario. The license protects you regardless.

---

## Feedback Loop — How BCS Improves

The spec is a living document. It improves through use.

**The principle:** Implementors are responsible for collecting feedback from their users and contributing findings back to the open source community. BCS belongs to the community — and so does the knowledge gained from running it in the real world.

**How implementors contribute feedback:**
- Aggregate findings from real usage (never raw personal data)
- Rubric proposals backed by outcome data
- API and spec improvements surfaced through real implementation experience

**How the community contributes:**
- [RFC Discussion](https://github.com/mei0872/best-chance-studio/discussions/17) — open thread for API design and spec review
- Rubric proposals via issues (process above)
- Implementation notes, edge cases, and usage patterns via Discussions

No one is required to share everything. But if you find something that would help other implementors — or that would make the spec better — contribute it. That's how this gets better for every dog on every platform.

---

## Open Questions (Being Figured Out)

These are open. We'd rather name them plainly than pretend they're resolved:

- [ ] **Formal steering committee** — when does the community get a formal governance role? What does that look like?
- [ ] **Rubric proposal process** — the model above is v1. It'll be refined as real proposals come in.
- [ ] **Data sharing** — what does responsible aggregate outcome data sharing look like? Working through privacy considerations.
- [ ] **Foundation model** — at some point, does BCS benefit from being under a neutral foundation (like Apache, Linux Foundation)? TBD when the community is large enough to warrant it.
- [ ] **Other platforms contributing outcome data** — as adoption platforms build on BCS, can they also propose rubric updates? Yes — that's the intent. Process TBD.

---

## Contact

Questions about governance or contribution process:

→ KipMeierhofer@gmail.com
→ [GitHub Issues](https://github.com/mei0872/best-chance-studio/issues)
