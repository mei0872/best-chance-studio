# Best Chance Studio — Product Requirements Document

*Version 1.1 · March 19, 2026*

---

## 1. Purpose

Best Chance Studio (BCS) is an open-source coaching framework that helps rescue dogs get adopted faster through better photos, descriptions, videos, and presentation coaching.

Every component in BCS exists to answer one question: **"What does this dog need — right now — to get adopted?"**

The answer is always a **coaching packet** — a concrete set of actions a foster, presenter, or rescue coordinator can take to improve that dog's chances.

---

## 2. Problem Statement

Rescue dogs with weak listings stay longer. The difference between a dog that gets adopted in a week and one that waits six months is rarely the dog — it's the listing. Bad photos, generic descriptions, no video, no personality. Fosters don't know what "better" looks like, and rescues don't have time to coach every listing individually.

BCS closes that gap with structured scoring, targeted coaching, and tools that work for a solo foster at midnight with one phone — all the way up to a full rescue team with dedicated presenters and videographers.

---

## 3. Users

| Persona | Context | Needs |
|---------|---------|-------|
| **Solo foster** | One phone, late night, spotty signal, dog won't sit still | Offline tools. Minimal input → useful output. Clear next steps. |
| **Rescue coordinator** | Managing 20-500 dogs/year across multiple fosters | Score visibility across all dogs. Priority gaps at a glance. Session history. |
| **Presenter** | Showing dogs at adoption events, live meets | Coaching brief. Shot list. One-liner pitch. Knows the dog's story cold. |
| **Videographer** | Capturing content for listings and social | Shot agenda. Real-time direction. Music/pacing guidance. |
| **Platform implementor** | Building a product on top of BCS | Clean APIs. Clear contracts. `platform_hints` integration. Cost transparency. |

**Design principle:** Build for the person with the least, not the most. One photo + one sentence must still produce something useful.

---

## 4. Scoring Rubric

All of BCS runs on a single rubric: **9 dimensions, max score 18**.

| # | Dimension | What a 2 looks like |
|---|-----------|---------------------|
| 1 | **Personality Hook** | Specific, memorable, only-this-dog moment |
| 2 | **Visual Impact** | Eye contact, natural light, multiple angles |
| 3 | **Video Presence** | Emotionally engaging, hooks within 10 seconds |
| 4 | **Compatibility Clarity** | Clear on kids, dogs, cats, energy, home type |
| 5 | **Foster Voice** | Warm, personal, relationship visible |
| 6 | **No Surprises** | Challenges communicated honestly and positively |
| 7 | **Story-First Gate** | Coached intro video exists and is ready |
| 8 | **Presenter Readiness** | Presenter knows the dog and the coaching packet |
| 9 | **Family Vision** | Adopter can picture this dog in their life |

**Grades:** A+ (16–18) · A (12–15) · B (8–11) · C (5–7) · D (0–4)

Source of truth: [`rubric-config.json`](rubric-config.json)

---

## 5. North Star Output — The Coaching Packet

Every tool in BCS points toward one artifact: the **coaching packet**. This is what the foster or presenter walks away with.

A coaching packet contains:

- **Score** — before and after, with grade
- **Coached description** — rewritten story ready for the listing
- **Photo selection** — which photos to use, in what order, with reasons
- **Shot list** — what to capture next, prioritized by score impact
- **Video coaching** — status, prompts, estimated impact
- **Next steps** — ranked actions with expected score improvement
- **Presenter brief** — one-liner guidance for live events

Full contract: [`stubs/coaching-packet.json`](stubs/coaching-packet.json)

---

## 6. System Architecture

### 6.1 Pipeline Overview

The BCS pipeline transforms raw foster input into a coaching packet through a series of independent, composable steps:

```
Foster Input → Score → Coach → Build Story → Curate Photos → [Video] → Coaching Packet
     ↓            ↓        ↓          ↓              ↓            ↓
  voice notes   rubric   gap-driven  refine loop   select/order  direct/produce/export
  photos        9 dims   actions     human gate    reject+coach  shot agenda
  video         grade    priorities  accept/tweak  lead shot     music/pacing
  text          gaps     summary     format/card   reasons       platform export
```

Full orchestration spec: [`FLOW.md`](FLOW.md)

### 6.2 Two-Tier Implementation

| Tier | When | How | Components |
|------|------|-----|------------|
| **Tier 1 — Rule-based** | Always available, works offline | Deterministic heuristics (photo count, text length, video presence, word flags) | G-01 through G-06, P-01 |
| **Tier 2 — AI-enhanced** | Online, API key configured | LLM analysis of actual content quality | P-03 through P-06, H-01 through H-04 |

Offline path never errors. If connectivity is unavailable, the system falls back to rubric-based coaching actions. Every coaching packet flags which tier produced it: `"scoring_tier": "rule-based"` or `"ai-enhanced"`.

### 6.3 Intelligence Channel — `platform_hints`

Every API accepts an optional `platform_hints` object. This is how learned platform intelligence flows to individual tools — what music tone is converting, how long videos should be, which shot to lead with.

Rules:
- Always optional — tools work without it
- Ignore unrecognized fields gracefully
- Never fail if null or absent
- Treat hints as guidance, not commands

Schema: [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md)

---

## 7. Component Inventory

### 7.1 Core Tools (G-series) — Self-contained HTML, offline, no build step

| ID | Component | Purpose | Status |
|----|-----------|---------|--------|
| **G-01** | BCS Scorer | Score a dog across 9 dimensions, surface top gaps and coaching actions | **Done** — [`bcs-scorer.html`](bcs-scorer.html) |
| **G-02** | Rubric Reference | Mobile-friendly display of all dimensions, score levels, and coaching actions | **Done** — [`bcs-rubric.html`](bcs-rubric.html) |
| **G-03** | Voice Transcription | Voice note → text (pre-transcribed for v1) | Not started |
| **G-04** | Word Check | Flag adoption-hurting language from 70,733-dog study, suggest replacements | Not started |
| **G-05** | Story Card Generator | Shareable image cards for social media (1:1 + 4:5 formats) | Not started |
| **G-06** | Story Formatter | Reformat description for platform character limits (5 platforms) | Not started |

**Constraints:** Single HTML file. Vanilla JS. No frameworks. No build step. Works offline. Mobile-first (375px). Brand colors applied.

### 7.2 Project APIs (P-series) — Working prototypes, 1–2 weekend builds

| ID | Component | Purpose | Status |
|----|-----------|---------|--------|
| **P-01** | Coaching Packet Generator | Rule-based coaching brief from BCS score (no AI) | Not started |
| **P-02** | Story Builder Session | Bring what you have → get coached story back. The atomic unit of BCS work. | Not started |
| **P-03** | Photo Curation API | Select, order, and coach on photos using CV | Not started |
| **P-04** | BCS Score API | Authoritative AI-enhanced scoring (Tier 2, single source of truth) | Not started |
| **P-05** | Story Builder API | AI story generation with gap-driven coaching | Not started |
| **P-06** | Re-Presentation Engine | Fresh coaching when a dog doesn't place (reads full session history) | Not started |

**Constraints:** Independently callable APIs. Test UI or curl examples. Runnable in under 5 minutes. `platform_hints` accepted on all.

### 7.3 High Bar (H-series) — Hard technical problems, proof-of-concept

| ID | Component | Technical Challenge | Status |
|----|-----------|---------------------|--------|
| **H-01** | AI Director — Live | Real-time vision AI coaching during video capture. <3 second latency. | Not started |
| **H-02** | Video Coaching Feedback | Shot-by-shot analysis of recorded video via vision model | Not started |
| **H-03** | Video Production Engine | AI-directed editing: music, cuts, pacing that reflect the dog | Not started |
| **H-04** | Video Export Engine | Platform-ready output (YouTube first, multi-platform stretch) | Not started |

**Constraints:** Working proof of concept that solves the hard technical problem. Polish is secondary.

### 7.4 Component Dependencies

```
G-01 (Scorer) ──────────────────────────────┐
G-02 (Rubric Reference)                     │
G-03 (Voice Transcription) ─────┐           │
G-04 (Word Check) ──────────────┤           │
                                ▼           ▼
                        P-02 (Story Builder Session)
                          │         │          │
                          ▼         ▼          ▼
                    P-04 (Score)  P-05 (Story)  P-03 (Photos)
                          │         │          │
                          ▼         ▼          ▼
                    P-01 (Coaching Packet Generator)
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
              H-01 (Director) H-02 (Video) H-03 (Production)
                                           │
                                           ▼
                                     H-04 (Export)
                                           │
                                           ▼
                                  P-06 (Re-Presentation)
                              [if dog doesn't place]
```

G-05 (Story Card) and G-06 (Story Formatter) are standalone — they take approved story text as input and produce formatted output.

### 7.5 Native Mobile Apps

All G-series tools (G-01 through G-06) will ship as native mobile apps in addition to the existing HTML tools. The HTML tools remain canonical — native apps are an additional delivery target, not a replacement.

| Platform | Stack | Minimum Version | Directory | Status |
|----------|-------|-----------------|-----------|--------|
| **iOS** | SwiftUI + SwiftData | iOS 17+ | `ios/BestChanceStudio/` | In progress |
| **Android** | Kotlin + Jetpack Compose + Room | API 26+ (Android 8.0) | `android/BestChanceStudio/` | In progress |

**MVP:** G-01 (Scorer) + G-02 (Rubric Reference)
**Full scope:** G-01 through G-06 on both platforms
**Distribution:** TestFlight → App Store (iOS), internal testing → Play Store (Android)

**Shared contract:** `rubric-config.json` is bundled in both apps as the single source of truth. Native apps decode it at launch and drive all UI rendering from the config — no hardcoded dimensions.

**Architecture decisions:** [DEC-007](architect/decisions/DEC-007-native-mobile-strategy.md) (platform strategy), [DEC-008](architect/decisions/DEC-008-mobile-persistence.md) (persistence)

**Constraints:**
- Offline-first — entire app works without connectivity (matches G-series web constraint)
- Brand colors applied (`#F4622A`, `#F9A826`, `#F9F7F4`, `#1E1E2E`)
- Accessibility: VoiceOver/TalkBack labels, Dynamic Type / font scaling
- Export formats match HTML tool output (JSON, CSV, PDF via native Share sheet)

---

## 8. Data Model

### 8.1 Core Entities

| Entity | Description | Key Fields |
|--------|-------------|------------|
| **Dog** | Central entity. Rescue-scoped identity. | `dog_id` (`{rescue_id}-{name_slug}-{seq}`), name, breed, age |
| **Rescue** | Organization running BCS | `rescue_id`, name |
| **Session** | One pass through the BCS pipeline | `session_id`, dog_id, status, version, scoring_tier |
| **Score** | Rubric evaluation at a point in time | 9 dimension scores, total, grade, rubric_version |
| **CoachingPacket** | The output artifact | See Section 5 |
| **StoryVersion** | Versioned coached description | text, refine_count, what_changed |
| **Media** | Photos, videos, voice notes | url, type, source, metadata |
| **ShotAgenda** | Prioritized capture list | shots[], priority, status |

### 8.2 Session Lifecycle

```
intake → scored → coached → pending_review → approved → published
                                                    ↘ re-presented (via P-06)
```

### 8.3 Dog Identity

- **Default:** `{rescue_id}-{dog_name_slug}-{sequence}` (works offline)
- **Optional:** Microchip linking for transport corridor dogs (merges session history across rescues)
- **Transfer UX:** "Import session from prior rescue" prompt when linking

### 8.4 Persistence Strategy

| What | v1 (Prototype) | Production |
|------|-----------------|------------|
| Session state | LocalStorage (5MB cap) | IndexedDB (100MB+) |
| Config/rubric | Embedded in HTML | IndexedDB or fetched |
| Media | URLs (not stored locally) | URLs (BCS is source of record) |
| History/export | JSON file download | IndexedDB + auto-export prompt |
| Published inventory | File export | IndexedDB + periodic export |

**Critical requirement:** Export prompt must be unavoidable before any storage-clearing action (especially Safari private browsing).

### 8.5 Native Mobile Persistence

On native platforms, web storage APIs (IndexedDB, LocalStorage) are replaced by platform-native equivalents:

| Platform | Storage | Equivalent of |
|----------|---------|---------------|
| **iOS** | SwiftData | IndexedDB (structured, queryable, 100MB+) |
| **Android** | Room | IndexedDB (structured, queryable, 100MB+) |

Entity model: `Dog` → `ScoringSession` → `DimensionScore`. Dogs persist across app launches. Multiple scoring sessions per dog are supported (score → improve → re-score). Export via native Share sheet (iOS) / share intent (Android).

Full decision: [DEC-008](architect/decisions/DEC-008-mobile-persistence.md)

Full data architecture: [`architect/models/data-architecture.md`](architect/models/data-architecture.md)

---

## 9. Architecture Decisions

All 8 structural decisions have been made and confirmed by stakeholders.

| ID | Decision | Ruling | Impact |
|----|----------|--------|--------|
| [DEC-001](architect/decisions/DEC-001-offline-scoring.md) | Offline Scoring | Two-tier: rule-based offline + AI-enhanced online | G-01 is Tier 1, P-04 is Tier 2. Rubric = 9 dims / max 18. |
| [DEC-002](architect/decisions/DEC-002-standalone-persistence.md) | Persistence | IndexedDB + file export. LocalStorage for v1. | Export prompt unavoidable. Safari edge case handled. |
| [DEC-003](architect/decisions/DEC-003-dog-identity.md) | Dog Identity | Rescue-scoped + optional microchip linking | Transfer UX required. Works offline by default. |
| [DEC-004](architect/decisions/DEC-004-orchestration-location.md) | Orchestration | Isomorphic (offline JS + online backend) | Offline never errors. Falls back to rubric coaching. |
| [DEC-005](architect/decisions/DEC-005-ai-cost-model.md) | AI Cost | Provider abstraction. <$0.50/dog. BYOK. | Two adapters minimum (cloud + Ollama). Implementor pays. |
| [DEC-006](architect/decisions/DEC-006-offline-media-boundary.md) | Offline Media | Capture + guidance offline. AI processing online. | Client-side photo checks in v1. No service worker v1. |
| [DEC-007](architect/decisions/DEC-007-native-mobile-strategy.md) | Native Mobile | Native SwiftUI (iOS) + Jetpack Compose (Android). iOS first. | G-01–G-06 on both platforms. MVP = G-01 + G-02. TestFlight → App Store. |
| [DEC-008](architect/decisions/DEC-008-mobile-persistence.md) | Mobile Persistence | SwiftData (iOS) / Room (Android). Dog → Session → Score. | Replaces IndexedDB on native. Export via Share sheet. |

---

## 10. API Contracts

All API input/output contracts are defined as stub files with example request/response pairs.

| Contract | File | Used By |
|----------|------|---------|
| Scoring | [`stubs/bcs-score.json`](stubs/bcs-score.json) | G-01, P-04 |
| Coaching Packet | [`stubs/coaching-packet.json`](stubs/coaching-packet.json) | P-01, P-02 |
| Story Build | [`stubs/story-build.json`](stubs/story-build.json) | P-05 |
| Photo Curation | [`stubs/photos-curate.json`](stubs/photos-curate.json) | P-03 |
| Video Coaching | [`stubs/video-coach.json`](stubs/video-coach.json) | H-02 |
| Video Export | [`stubs/video-export.json`](stubs/video-export.json) | H-04 |
| Voice Transcription | [`stubs/voice-transcribe.json`](stubs/voice-transcribe.json) | G-03 |

Test data: [`stubs/example-low-all.json`](stubs/example-low-all.json), [`stubs/example-low-description.json`](stubs/example-low-description.json), [`stubs/example-low-video.json`](stubs/example-low-video.json)

---

## 11. Implementation Phases

### Phase 1 — Foundation (Core Tools)

**Goal:** Every rescue can score a dog and know what to fix. No backend. No AI. Works offline.

| Priority | Task | What ships |
|----------|------|------------|
| 1 | G-01 Scorer | **Done** |
| 2 | G-02 Rubric Reference | **Done** |
| 3 | G-04 Word Check | Single HTML file, hardcoded word list, flags and suggests |
| 4 | G-05 Story Card Generator | Canvas-based card export (1:1 + 4:5 PNG) |
| 5 | G-06 Story Formatter | Platform-aware text formatter (5 platforms) |
| 6 | G-03 Voice Transcription | Audio → text (pre-transcribed in v1) |

**Exit criteria:** A foster with zero technical knowledge can score a dog, see what's wrong, check their language, format a description, and generate a shareable card — all from their phone, all offline.

### Phase 2 — Coaching Engine (Rule-based)

**Goal:** Automated coaching brief from score data. No AI required.

| Priority | Task | What ships |
|----------|------|------------|
| 1 | P-01 Coaching Packet Generator | Rule-based brief: shot list, description coaching, tips |
| 2 | P-02 Story Builder Session | The atomic BCS workflow — bring content, get coached story |

**Exit criteria:** A rescue coordinator can run any dog through BCS and hand a foster a printable coaching packet with specific, actionable next steps.

### Phase 3 — AI Enhancement

**Goal:** AI-powered scoring, story building, and photo curation.

| Priority | Task | What ships |
|----------|------|------------|
| 1 | P-04 BCS Score API | Authoritative AI-enhanced Tier 2 scoring |
| 2 | P-05 Story Builder API | Gap-driven story generation with coaching |
| 3 | P-03 Photo Curation API | CV-powered photo selection and ordering |
| 4 | P-06 Re-Presentation Engine | Fresh angle when dog doesn't place |

**Exit criteria:** The full text/photo pipeline produces coaching packets that measurably improve scores. Cost stays under $0.50/dog.

### Phase 4 — Video Pipeline

**Goal:** Video capture, coaching, production, and export.

| Priority | Task | What ships |
|----------|------|------------|
| 1 | H-02 Video Coaching Feedback | Shot-by-shot analysis of recorded video |
| 2 | H-01 AI Director — Live | Real-time coaching during capture (<3s latency) |
| 3 | H-03 Video Production Engine | Produced highlight reels with music and pacing |
| 4 | H-04 Video Export Engine | Platform-ready output (YouTube → multi-platform) |

**Exit criteria:** A rescue can capture video with live coaching, get feedback, produce a reel, and export it — with quality that matches or beats what a skilled volunteer would produce manually.

### Native Mobile — Parallel Workstream

Native mobile app development runs alongside the web phases above. iOS ships first, Android follows.

| Priority | Task | What ships |
|----------|------|------------|
| 1 | G-01 iOS (Scorer) | Native SwiftUI scorer with local persistence |
| 2 | G-02 iOS (Rubric Reference) | Native rubric reference with expandable cards |
| 3 | G-04–G-06 iOS | Remaining G-series tools ported to iOS |
| 4 | G-01–G-06 Android | All G-series tools on Android |

**Exit criteria (iOS MVP):** A foster can score a dog on their iPhone, see gaps and coaching actions, save the score, review past dogs, and export results — all offline, all native.

---

## 12. Technical Constraints

| Constraint | Applies to | Rationale |
|------------|------------|-----------|
| Single HTML file, no build step | All G-series | Solo foster at midnight. Open in browser, it works. |
| Vanilla JS, no frameworks | All G-series | Simplicity. Readability. No dependency risk. |
| Mobile-first (375px minimum) | All tools | Fosters use phones. |
| Brand colors | All UI | `#F4622A`, `#F9A826`, `#F9F7F4`, `#1E1E2E` |
| Offline-capable | G-series, P-01, P-02 (partial) | Connectivity is not guaranteed in the field. |
| `platform_hints` accepted | All APIs | Intelligence channel must be consistent across pipeline. |
| <$0.50/dog AI cost | P-03 through P-06 | BCS is free. AI isn't. Must be economically viable. |
| BYOK (Bring Your Own Key) | All AI-dependent APIs | No central API key. Implementor provides their own. |
| Provider abstraction | All AI-dependent APIs | Cloud + Ollama minimum. No vendor lock-in. |
| Export prompt unavoidable | Persistence layer | Data loss prevention, especially Safari. |
| iOS 17+ minimum | iOS app | Enables SwiftData, modern SwiftUI, latest device APIs. |
| `rubric-config.json` bundled | Native mobile apps | Same source of truth on all platforms. No hardcoded dimensions. |
| Native SwiftUI / Jetpack Compose | Native mobile apps | No cross-platform frameworks. Platform-native UX. |

---

## 13. Cost Model

| API Call | Estimated Cost | Notes |
|----------|---------------|-------|
| `/bcs/score` (P-04) | ~$0.02 | Text analysis |
| `/story/build` (P-05) | ~$0.02 | LLM generation |
| `/photos/curate` (P-03) | $0.05–0.15 | Vision model, depends on photo count |
| `/video/coach` (H-02) | $0.10–0.30 | Vision model on video frames |
| **Full pipeline (no video)** | **~$0.10–0.20** | Well under $0.50 target |
| **Full pipeline (with video)** | **~$0.30–0.50** | Within budget |
| H-01 (Live Director) | TBD | Continuous streaming — separate cost analysis needed |

Per-call usage logging required: [`docs/ai-usage-logging.md`](docs/ai-usage-logging.md)

---

## 14. Quality & Governance

### Rubric Evolution
- Current rubric is a starting hypothesis grounded in peer-reviewed research
- Updates require outcome data backing (not opinion)
- Rubric proposals go through governance process (see [`GOVERNANCE.md`](GOVERNANCE.md))
- Every coaching packet records `rubric_version` for traceability

### Contribution Model
- MIT licensed. Fork, deploy, use standalone.
- 14 tasks on the pull list — grab one, build it, ship it.
- No pre-approval needed. First to comment and deliver, ships it.
- Bar: security requirements + spec compliance.
- See [`CONTRIBUTING.md`](CONTRIBUTING.md) for full guidelines.

### Feedback Channels
- API design / spec gaps → [RFC Discussion](https://github.com/mei0872/best-chance-studio/discussions/17)
- Rubric improvements → Rubric Proposal issues
- General ideas → [GitHub Discussions](https://github.com/mei0872/best-chance-studio/discussions)
- Bugs → [GitHub Issues](https://github.com/mei0872/best-chance-studio/issues)

---

## 15. Key Reference Files

| File | What it is |
|------|------------|
| [`FLOW.md`](FLOW.md) | Complete pipeline orchestration — how every API connects |
| [`rubric-config.json`](rubric-config.json) | Scoring source of truth (9 dimensions, grades, coaching actions) |
| [`stubs/coaching-packet.json`](stubs/coaching-packet.json) | North star output contract |
| [`TASKS.md`](TASKS.md) | Full task pull list with specs |
| [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md) | Shared intelligence channel schema |
| [`architect/decisions/`](architect/decisions/) | All 8 architecture decisions (all decided) |
| [`architect/models/`](architect/models/) | Software, data, technical, and security architecture |
| [`bcs-example.md`](bcs-example.md) | Real-world example: Moose, 3→14 score transformation |

---

## 16. What BCS Is Not

- **Not a platform.** BCS is the engine. Platforms are built on top by implementors.
- **Not a database.** Session state is local-first. Published inventory is file-exportable.
- **Not a social network.** Fosters don't interact with each other through BCS.
- **Not a listing service.** BCS coaches the listing. The rescue publishes it wherever they publish.
- **Not prescriptive about infrastructure.** Implementors choose their stack, hosting, and distribution.

---

*This PRD consolidates requirements from FLOW.md, TASKS.md, CONTRIBUTING.md, GOVERNANCE.md, WHY.md, rubric-config.json, all architecture decisions (DEC-001 through DEC-008), all API stub contracts, and the architecture models. It is the single document to read before building or contributing to BCS.*
