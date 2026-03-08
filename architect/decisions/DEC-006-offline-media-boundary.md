# DEC-006: Offline Media Boundary

**Status:** Open
**Date:** 2026-03-07
**Decider:** Stakeholder
**Model(s):** Technical, Software, Security

---

## Context

BCS processes media at multiple stages: photo capture, photo curation (AI analysis), video capture, video coaching (AI analysis), video production (editing + music), video export (platform formatting), and story card generation.

Some of these are inherently local (capture happens on the foster's phone). Some are inherently cloud-dependent (AI image analysis, video production). The boundary between "works offline" and "needs connectivity" must be explicit — especially for the solo foster at midnight.

CONTRIBUTING.md: "build for the person with the least." That person has a phone, one bar of signal (maybe), and a dog who won't sit still.

---

## Options

### Option A: Capture-only offline

**How it works:**
- **Offline:** Photo capture, video recording, voice note recording. Raw files stored locally.
- **Online:** Everything else — curation, analysis, production, export, AI coaching.
- Offline mode is an intake tool. Online mode is the coaching tool.

**Pros:**
- Cleanest boundary. No ambiguity about what works offline.
- Simplest to implement — offline is just file capture + storage.
- No quality compromise — all AI/processing happens with full connectivity.

**Cons:**
- The foster at midnight captures media but gets no feedback until they have signal.
- No shot guidance offline — the foster doesn't know what to photograph.
- Misses the CONTRIBUTING.md standard: "one photo + one sentence → something useful."

### Option B: Capture + guidance offline

**How it works:**
- **Offline:** Everything in Option A, plus:
  - Shot list from rubric (deterministic — no AI needed): "Get eye contact, natural light, full body"
  - Basic photo checks (resolution, orientation, count) — no AI analysis
  - Voice note capture with transcript placeholder (transcribe when online)
  - Coaching actions from `rubric-config.json` displayed per dimension
- **Online:** AI curation, AI scoring, story building, video production, export.

**Pros:**
- Foster gets actionable guidance offline — knows what to shoot and why.
- Coaching actions are deterministic (from rubric-config.json) — zero cost, zero connectivity.
- Photo validation catches basic issues immediately (too dark, too small, wrong orientation).
- Meets the "something useful" bar even without signal.

**Cons:**
- Basic photo checks (resolution, brightness) need client-side image processing.
- More offline code to maintain than Option A.
- Foster might think they're "done" when they've only received offline guidance.

### Option C: Capture + guidance + deferred processing queue

**How it works:**
- Everything in Option B, plus:
  - A processing queue that records what needs to happen when connectivity returns.
  - Auto-sync: when signal comes back, queued items (photos for curation, text for scoring, audio for transcription) are processed automatically.
  - Foster sees "pending" status for queued items and "complete" when processed.

**Pros:**
- Seamless transition from offline to online. Foster doesn't have to re-trigger anything.
- Queue provides visibility into what's done vs what's waiting.
- Background sync means the foster can capture everything in one session and process later.

**Cons:**
- Queue management adds significant complexity (retry logic, partial failure, conflict resolution).
- Background sync requires Service Worker — not supported in all mobile contexts.
- "Auto" processing on reconnect may surprise the foster if they've moved on.
- Stale queue items (captured Monday, processed Friday) may produce outdated coaching.

---

## Tradeoffs

| Factor | A: Capture-only | B: Capture + guidance | C: Capture + guidance + queue |
|--------|-----------------|----------------------|------------------------------|
| Offline value | Low (just capture) | Medium (capture + coaching actions) | Medium-High (capture + auto-process) |
| Implementation effort | Low | Medium | High |
| Foster UX offline | "Save for later" | "Here's what to do" | "Do it now, we'll process later" |
| Maintenance | Low | Medium | High (queue, sync, retry) |
| "Something useful" test | Fails | Passes | Passes |
| Complexity risk | Low | Low | High (sync bugs, stale data) |

---

## Media Operation Classification

| Operation | Offline Possible? | Approach |
|-----------|------------------|----------|
| Photo capture | Yes | Native camera API |
| Photo count/resolution check | Yes | Client-side image metadata |
| Photo brightness/orientation check | Yes | Client-side canvas analysis |
| Photo AI curation (ranking, gaps) | No | Requires vision model |
| Video recording | Yes | Native camera API |
| Video duration/format check | Yes | Client-side metadata |
| Video AI coaching (coverage analysis) | No | Requires vision model |
| Video production (editing, music) | No | Requires compute + media library |
| Video export (platform formatting) | No | Requires compute + platform APIs |
| Voice note recording | Yes | Native audio API |
| Voice transcription | No | Requires speech-to-text model |
| Shot list (generic from rubric) | Yes | Deterministic from rubric-config.json |
| Shot list (AI-personalized) | No | Requires story context + AI |
| Coaching actions display | Yes | Deterministic from rubric-config.json |
| Story card generation | No | Requires image composition |

---

## Recommendation

**Option B: Capture + guidance offline.** This hits the "something useful" bar without the complexity of a processing queue. The foster at midnight can:

1. Open BCS offline
2. See the rubric dimensions and what "good" looks like
3. Get a generic shot list (from rubric-config.json)
4. Capture photos and check basic quality (resolution, orientation)
5. Record voice notes
6. See coaching actions per dimension
7. Save everything locally

When connectivity returns, the foster manually triggers processing. No auto-sync, no queue, no background surprises. Simple. Predictable. Reliable.

Option C's queue can be added later if user research shows fosters want auto-processing. Start simple.

---

## Decision

[Awaiting stakeholder input]

---

## Consequences

If Option B:
- Offline UI includes: rubric display, generic shot list, coaching actions, basic photo checks
- Client-side image processing needed for resolution/orientation/brightness checks
- Voice notes stored as raw audio files, transcription deferred
- No Service Worker requirement for v1 (optional enhancement later)
- "Process now" button visible when connectivity detected
- All offline-captured data stored per DEC-002 persistence strategy
