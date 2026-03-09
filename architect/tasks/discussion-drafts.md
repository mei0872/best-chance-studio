# Discussion Drafts — Pending Approval

*Draft discussions for GitHub Discussions. Do not post until approved.*

---

## Discussion 1: Q-P4 — Re-Presentation Trigger

**Category:** General
**Title:** `Open Question: Who triggers /story/represent when a dog doesn't place?`

**Body:**

```markdown
# Q-P4: Re-Presentation Trigger

**Status:** Open
**Date:** 2026-03-08
**Source:** `architect/tasks/questions-stakeholder.md`
**Affects:** P-06 (Re-Presentation Engine), P-02 (Story Builder Session UI), FLOW.md Step 9

---

## Context

When a dog goes through the full BCS pipeline, gets presented, and doesn't place — `/story/represent` generates a fresh coaching brief for the next attempt. The architecture supports this (session history compounds, near-miss signals feed forward).

But **who or what triggers that call?**

FLOW.md Step 9 describes two paths:
- **Path A (platform-connected):** The platform detects a stall automatically and calls `/story/represent` with outcome data. No human needed.
- **Path B (standalone):** Someone has to decide "this dog needs a new approach" and manually kick off the next session.

Path A is clear — the platform handles it. Path B is the open question. In standalone mode:

- Does the **foster** decide? ("Moose has been listed for 2 weeks with no interest — I want to try a new angle.")
- Does a **coordinator** decide? ("Beth reviews the board every Monday and flags dogs that need re-presentation.")
- Does **BCS itself** suggest it? ("Moose has been at score 11 for 14 days with no activity. Consider re-presenting.")
- Is it **time-based**? ("Any dog not adopted within 7 days of publish automatically gets a re-presentation prompt.")

The architecture already supports all of these — the question is which ones BCS should implement and in what order.

---

## Options

### Option A: Manual only (foster or coordinator initiates)

A button in the session UI: "Try a new angle." The foster or coordinator clicks it when they feel it's time. No automation.

**Pros:**
- Simplest to build. No timers, no rules engine.
- Respects the foster's judgment — they know when something isn't working.
- No false triggers (a dog that's getting interest but hasn't been adopted yet won't get unnecessarily re-presented).

**Cons:**
- Depends on the foster/coordinator remembering and acting. Dogs can go invisible if nobody checks.
- Solo fosters (the midnight-with-one-phone person) may not know when to re-present.
- No coaching prompt = no nudge. The system is passive.

### Option B: Time-based suggestion with manual trigger

BCS tracks days since publish. After a configurable threshold (default: 7 days), it surfaces a suggestion: "Moose has been published for 7 days — consider re-presenting with a new angle." The foster still has to act on it.

**Pros:**
- Nudge without automation. Fosters get a coaching prompt without losing control.
- Configurable per rescue (some rescues move faster than others).
- Low implementation cost — just a date comparison and a UI prompt.

**Cons:**
- Calendar-based heuristic may not match reality (7 days at a high-volume rescue ≠ 7 days at a small rural rescue).
- Still requires the foster to open BCS and see the suggestion.

### Option C: Multi-trigger (manual + time-based + coordinator dashboard)

All of the above:
- Manual "Try a new angle" button (always available)
- Time-based suggestion after configurable threshold
- Coordinator dashboard showing dogs approaching or past threshold, sorted by urgency

**Pros:**
- Covers all user types: solo foster (time-based nudge), coordinator (dashboard), engaged foster (manual).
- Dashboard gives coordinators a "Monday morning board review" workflow.
- Matches the foster reality described in CONTRIBUTING.md.

**Cons:**
- More to build. Dashboard is a new surface.
- Notification/reminder mechanism needed for the time-based suggestion to reach fosters who aren't actively in BCS.

---

## Tradeoffs

| Factor | A: Manual | B: Time-based suggestion | C: Multi-trigger |
|--------|-----------|--------------------------|------------------|
| Implementation effort | Low | Low | Medium |
| Solo foster support | Weak | Good | Strong |
| Coordinator support | None | None | Strong (dashboard) |
| False trigger risk | None | Low | Low |
| Dog visibility risk | High (passive) | Medium (nudge) | Low |
| Offline support | Full | Full | Full (dashboard needs data) |

---

## Recommendation

**Option B for v1, Option C for production.** The time-based suggestion is low-cost and solves the biggest risk (dogs going invisible). The coordinator dashboard is high-value but can come later — it's additive, not architectural.

The configurable threshold should live in rescue settings (not hardcoded). Default: 7 days. Architecture note: the `session` entity already tracks `publish_date`, so the date comparison is trivial.

---

## Decision

[Awaiting stakeholder input]
```

---

## Planned Discussions (same format)

### Discussion 2: Q-O1 — Rubric Update Cadence
**Title:** `Open Question: How often will rubric-config.json be updated?`
**Key tension:** The architecture supports version-pinned scores and a config loader that can pull updates — but the operational cadence (weekly? quarterly? only when outcome data justifies it?) affects how we build the update notification and migration path. Does a rubric update automatically re-score existing published dogs? Or are published scores frozen at their rubric version?

### Discussion 3: Q-O2 — Platform Hints Governance
**Title:** `Open Question: Who reviews and approves rubric updates proposed by platforms?`
**Key tension:** FLOW.md describes platforms proposing rubric weight changes based on outcome data. The community reviews. But there's no defined process — who has merge authority on rubric-config.json? Is it a single maintainer? A vote? A threshold of supporting outcome data? This is governance, not architecture — but it needs to exist before the first platform proposes a change.

### Discussion 4: Phase 3 Contract Audit Findings
**Title:** `Architecture: Phase 3 Contract Audit — 15 findings across stubs`
**Summary:** Phase 3A (models vs stubs) and 3B (FLOW.md vs stubs) found 15 inconsistencies, gaps, and clarifications. Three block G-01/G-02 build (missing `grade` field, `total` vs `total_score` naming, inconsistent `grade` across examples). Seven affect P-02/P-05 build (two-layer description mismatch, photos-curate shape, field naming). Full findings in `architect/tasks/architecture-tasks.md`.

### Discussion 5: Q-L3 — YouTube OAuth Scope (if ready)
**Title:** `Deferred: YouTube credential scope for H-04`
**Note:** This was marked DEFERRED, not OPEN. Only post if H-04 work is being picked up.
