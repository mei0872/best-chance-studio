# Best Chance Studio — Pull List Issues

*Last updated: March 6, 2026*

> These are ready to copy-paste into GitHub issues, or create via `gh` CLI.
> Each one has a real dog on the other side of it.

```bash
# Create via gh CLI (example):
gh issue create --title "[G-01] BCS Scoring Tool" --body-file .github/issues/G-01.md --label "good first issue"
```

---

## 🟢 CORE — Grab & Go

*Self-contained. 2–4 hours. No dependencies. Good first issues.*

---

### G-01: BCS Scoring Tool

**Title:** `[G-01] BCS Scoring Tool — enter a dog's profile, get a gap analysis and grade`

**Labels:** `good first issue`

**Body:**

---

A rescuer inputs a dog's profile across key BCS dimensions. The tool outputs a score (0–12), a grade, and the top gaps to fix before the next presentation.

**Why it matters:**
This is the heart of Best Chance Studio. Every rescue uses this before every presentation. The score tells a coordinator like Beth exactly where to focus for each of her 40 dogs — without carrying it all in her head.

**Stack:**
Plain HTML + vanilla JS. No framework. Must work offline. No build step.

**Deliverable:**
`bcs-scorer.html` — self-contained, single file. Open in browser, it runs.

**What "done" looks like:**
- Input fields for each BCS dimension
- Scoring logic outputs total score (0–12), label (Strong / Good / Needs Work / Minimal), and top gaps
- Mobile-friendly at 375px
- Brand colors: `#F4622A`, `#F9A826`, `#F9F7F4`, `#1E1E2E`

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

### G-02: BCS Rubric Reference

**Title:** `[G-02] BCS Rubric Reference — mobile-friendly coaching guide to the scoring dimensions`

**Labels:** `good first issue`

**Body:**

---

A clean, mobile-friendly reference that explains each BCS dimension — what it means, what a strong score looks like, and what a gap looks like.

**Why it matters:**
Rescuers and presenters need to understand the rubric before they can score. Savannah reads this Saturday morning before she goes live with a dog. Beth references it while writing listings on her phone. This is the coaching guide they keep open.

**Stack:**
Plain HTML + CSS. Mobile-first (375px base). No JS required.

**Deliverable:**
`bcs-rubric.html` — self-contained, single file.

**What "done" looks like:**
- All BCS dimensions clearly explained with examples
- "What strong looks like" vs. "What a gap looks like" for each dimension
- Readable on a phone in one hand
- Brand colors: `#F4622A`, `#F9A826`, `#F9F7F4`, `#1E1E2E`

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

## 🟡 PROJECT — Bigger Scope

*1–2 weekends. A quick spec call if helpful.*

---

### P-01: Coaching Packet Generator

**Title:** `[P-01] Coaching Packet Generator — dog profile in, presenter brief out`

**Labels:** `help wanted`

**Body:**

---

Given a dog's BCS score and profile, generate a one-page coaching brief for the presenter — what to improve, a shot list, a description draft, and what to watch for in the live meet.

**Why it matters:**
Presenters like Savannah shouldn't have to figure out improvements from scratch every Saturday. The platform tells them exactly what to do. This is what she reads before every live session.

**Inputs:**
- Dog name, breed, age
- BCS score by dimension
- Existing description (optional)

**Outputs:**
- Top gaps with specific actions
- Shot list (what photos to get before next listing update)
- Description draft (rule-based for v1 — no AI required)
- Live meet tips

**Stack:**
HTML + JS. Rule-based logic for v1. Printable / shareable output.

**Deliverable:**
`coaching-packet-generator.html` — working prototype.

**What "done" looks like:**
- Inputs → one-page coaching brief output
- Printable or shareable (print-friendly CSS or a share link)
- No backend required

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

### P-02: Story Builder Session UI

**Title:** `[P-02] Story Builder Session UI — bring whatever you have, get the best story back`

**Labels:** `help wanted`

**Body:**

---

A UI for a rescue team member to open a Story Builder session for a dog — bring in photos, video, notes, and observations — and receive a coached story plus coaching packet.

**Why it matters:**
The Story Builder session is the atomic unit of BCS work. It takes whatever you bring — from one photo and a sentence to a full production team — and produces the best story possible right now. This is the interface to that session.

**The foster reality:**
This tool serves everyone from a solo introvert foster at midnight with one phone to a team with a videographer. It cannot assume capability. It must assume heart.

**Inputs:**
- Dog info (text, any length)
- Photos (upload or URL)
- Video (YouTube link or upload)
- Voice notes (pre-transcribed text)
- History from last session (optional — last story, last coaching tips)

**Outputs:**
- Coached story (portable + enriched layers)
- BCS score + gaps
- Coaching tips for next update
- Presentation tips for the upcoming live meet

**Stack:**
HTML + JS. LocalStorage for prototype. No backend required.

**Deliverable:**
`story-builder-session.html` — working prototype.

**Full spec:** [`docs/story-builder.md`](docs/story-builder.md)

**platform_hints:** This UI must accept `platform_hints` as an optional input. See [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md).

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

### P-03: Photo Curation API

**Title:** `[P-03] Photo Curation API — pick the strongest photos, coach on the rest`

**Labels:** `help wanted`

**Body:**

---

Given a set of raw photos, select and order the best ones for a dog's listing. Return the curated set with reasons — and flag rejected photos with coaching notes explaining what to reshoot.

**Why it matters:**
Most rescue photos are raw and unfiltered. This tool picks the strongest ones and tells the foster exactly what to reshoot. The `rejected` list with reasons IS the coaching — it's how you improve the next batch.

Research shows that dogs with eye-contact photos, multiple images, and human-with-dog shots adopt measurably faster. This API operationalizes that finding.

**API shape:**
```
POST /photos/curate
Input:  photos[], dog_info, platform_hints (optional)
Output: selected[ { url, order, reason } ]
        rejected[ { url, reason } ]
```

**Stack:**
Python or Node. Computer vision model of your choice.

**Deliverable:**
Standalone API + a simple test UI to upload photos and see results.

**platform_hints:** Accept and consume the `photos` field group. See [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md).

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

## 🔴 HIGH BAR — For the Right Engineer

*Genuinely hard problems. Real technical depth. This is where serious engineers play.*

---

### H-01: AI Director — Live

**Title:** `[H-01] AI Director — real-time coaching during live video capture`

**Labels:** `high-bar`

**Body:**

---

Real-time AI guidance during video capture. The camera feed is live — the AI watches and directs in the moment.

> *"Biscuit's looking relaxed — if he goes in for a lick, that's your shot. Don't force it."*
> *"Hold that — this is the moment."*
> *"Step back, you're losing the light."*

**Why it matters:**
Everything downstream improves when capture improves. Better raw footage → better coaching output → better story → dog goes home. The AI Director is the top of the pipeline.

**The campaign layer:**
Platform-wide themed campaigns (e.g. "Lick Week") can pass content prompts to the AI Director via `platform_hints`. The Director surfaces them naturally — never forces them. Safe moments only.

**The hard problem:**
Real-time vision AI with low latency. If feedback is 3 seconds late, it's useless — the moment is gone. This has to feel like a director in your ear.

**Stack:**
Your call. Mobile camera API + real-time vision model. Latency is the constraint.

**Deliverable:**
Working prototype — live camera feed → real-time coaching prompts.

**platform_hints:** Accept and consume the `director` and `campaign` field groups. See [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md).

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

### H-02: Video Coaching Feedback

**Title:** `[H-02] Video Coaching Feedback — upload a clip, get shot-by-shot improvement notes`

**Labels:** `high-bar`

**Body:**

---

Upload or link a video of a dog. AI analyzes it and returns coaching feedback — what worked, what to improve, a shot list for next time, and how to make it platform-ready.

**Why it matters:**
Most rescue video is shot on a phone with no direction. This tool is the coaching layer that gets presenters to broadcast quality without requiring production experience. It's what turns a good volunteer into someone who can change a dog's outcome with a camera.

**Inputs:**
- YouTube link or video file
- Dog context (optional)

**Outputs:**
- What landed (keep doing this)
- What to improve (specific + actionable)
- Shot list for next session
- Suggested title + description

**Stack:**
HTML + JS + OpenAI API (GPT-4o vision). Frame extraction via ffmpeg or client-side canvas. v1 uses extracted frames — full video processing is post-MVP.

**Deliverable:**
`video-coaching.html` — upload or link a video → receive a coaching card.

**platform_hints:** Accept and consume the `video` field group. See [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md).

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

### H-03: Video Production Engine

**Title:** `[H-03] Video Production Engine — raw footage in, produced highlight reel out`

**Labels:** `high-bar`

**Body:**

---

Takes raw footage and produces a highlight reel — edited, scored with music, paced to hold attention and make the viewer feel something.

**Why it matters:**
A produced highlight reel is the maximum capable output of Story Builder. It's what turns a phone video into something a foster wants to share and a pet parent watches all the way through — and then calls about.

**The challenge:**
Music selection that matches the dog's personality. Pacing that leads with the emotional hook. Cuts that tell a story. A shy border collie feels different than a goofy lab — the reel should reflect that. This is not a template job.

**Technical inputs:**
`platform_hints` carries learned parameters — video length, music tone, pacing, lead asset. When hints aren't present, infer from the footage itself and apply sensible defaults.

**Stack:**
Your call. ffmpeg + music library + AI-directed editing.

**Deliverable:**
Raw footage in → produced reel out. Repeatable. Automatable.

**platform_hints:** Accept and consume the `video` and `campaign` field groups. See [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md).

**Claimed by:** *(leave blank — comment below to claim)*

---

*→ Full pull list: [README.md](README.md) · Questions: KipMeierhofer@gmail.com*

---

## Creating Issues via `gh` CLI

```bash
# Install gh if needed: https://cli.github.com/

# Core
gh issue create --title "[G-01] BCS Scoring Tool" --label "good first issue"
gh issue create --title "[G-02] BCS Rubric Reference" --label "good first issue"

# Project
gh issue create --title "[P-01] Coaching Packet Generator" --label "help wanted"
gh issue create --title "[P-02] Story Builder Session UI" --label "help wanted"
gh issue create --title "[P-03] Photo Curation API" --label "help wanted"

# High Bar
gh issue create --title "[H-01] AI Director — Live" --label "high-bar"
gh issue create --title "[H-02] Video Coaching Feedback" --label "high-bar"
gh issue create --title "[H-03] Video Production Engine" --label "high-bar"
```

Paste each issue body from the sections above when prompted.
