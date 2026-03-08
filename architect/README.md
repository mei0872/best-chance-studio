# Architecture — Best Chance Studio

*Last updated: March 7, 2026*

This directory contains the architecture models, decision records, and task tracking for BCS. It exists to answer the structural questions that block implementation — before code gets written.

---

## Directory Structure

```
architect/
  README.md                            # You are here

  models/
    data-architecture.md               # Entities, relationships, storage, versioning
    technical-architecture.md          # Infrastructure, offline, AI services, deployment
    software-architecture.md           # Components, API contracts, orchestration, config
    security-architecture.md           # Threats, auth, PII, media, boundaries

  decisions/
    TEMPLATE.md                        # Decision document template
    DEC-001-offline-scoring.md         # Two-tier scoring strategy
    DEC-002-standalone-persistence.md  # Session storage without platform
    DEC-003-dog-identity.md            # Cross-rescue dog ID scheme
    DEC-004-orchestration-location.md  # Client vs server orchestration
    DEC-005-ai-cost-model.md           # LLM cost targets and abstraction
    DEC-006-offline-media-boundary.md  # What works offline vs deferred

  tasks/
    architecture-tasks.md              # Living task breakdown (main deliverable)
    questions-architect.md             # Blocking questions (architect-owned)
    questions-stakeholder.md           # Product/ops/legal questions (non-blocking)
```

---

## How to Use This

**If you're building an API:** Check `models/software-architecture.md` for the component map and API contracts. Check `models/data-architecture.md` for the entity model your API touches.

**If you're making a structural decision:** Check `decisions/` for existing ADRs. If your decision isn't covered, copy `decisions/TEMPLATE.md` and file a new one.

**If you're looking for what to work on:** `tasks/architecture-tasks.md` is the living task list across all 4 models.

**If something is blocking you:** Check `tasks/questions-architect.md` for known blockers. Add yours if it's new.

---

## Key Reference Files

These existing files are the source material the architecture models are built from:

| File | What It Tells You |
|------|-------------------|
| [`FLOW.md`](../FLOW.md) | Full orchestration spec — API call ordering, context propagation, every endpoint's input/output |
| [`rubric-config.json`](../rubric-config.json) | Scoring source of truth — 9 dimensions, weights, coaching actions |
| [`docs/platform-hints-schema.md`](../docs/platform-hints-schema.md) | Platform intelligence interface — the shared schema every API signs |
| [`stubs/coaching-packet.json`](../stubs/coaching-packet.json) | Output contract — what the entire system produces |
| [`stubs/bcs-score.json`](../stubs/bcs-score.json) | Diagnostic engine input/output contract |
| [`CONTRIBUTING.md`](../CONTRIBUTING.md) | Constraints: offline, no frameworks, mobile-first, single-file |

---

## Principles

1. **Offline first.** A solo foster at midnight with one phone and spotty signal must be able to use core features.
2. **No frameworks.** Vanilla JS. Single HTML files. No build steps for core tasks.
3. **Build for the person with the least, not the most.** One photo + one sentence still produces something useful.
4. **The coaching packet is the north star.** Every component points toward assembling it.
5. **platform_hints is the intelligence channel.** Tools work without it. They work better with it.
