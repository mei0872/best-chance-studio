# Best Chance Studio — Pull List
*Last updated: March 6, 2026*

> Not a job. Not a commitment. Grab something interesting, ship something real.
> Every item here moves dogs home faster. That's the only metric that matters.

---

## The One-Liner

We're building Best Chance Studio — open source coaching tools that give every rescue dog their best chance at adoption. Real problem. Real dogs. Pull list is open.

---

## How This Works

- Pick a task that looks interesting
- Build it
- Real dogs benefit
- If you can't stop thinking about what comes next — let's talk

No coordination overhead. No standups. No pressure.

---

## The Aligned Incentive

Your equity grows when dogs go home. Not as a side effect — as the mechanism. The platform generates revenue by getting dogs adopted. The better the platform works, the more dogs go home, the more revenue flows, the more your equity is worth.

Long term, that revenue doesn't just build equity — it funds the rescues that earned it. Automatically. No humans in the loop. You're not building a company that does good on the side. You're building infrastructure that redistributes value back to the mission indefinitely.

> *"A platform that runs itself, guided by and for the needs of rescues, and connects every dog to the family that's already looking for them."*

---

## 🟢 CORE — Grab & Go
*Self-contained. 2–4 hours. No dependencies. Start here.*

---

### [G-01] BCS Scoring Tool
**What:** A simple tool — rescuer inputs a dog's profile across key dimensions, tool outputs a score, grade, and top gaps to improve.
**Why it matters:** This is the heart of Best Chance Studio. Every rescue uses this before every presentation. The score tells them exactly where to focus.
**Stack:** Plain HTML + vanilla JS. No framework. Works offline.
**Deliverable:** `bcs-scorer.html` — self-contained, no build step.

---

### [G-02] BCS Rubric Reference
**What:** A clean, mobile-friendly reference that explains each BCS dimension — what it means, what good looks like, what a gap looks like.
**Why it matters:** Rescuers and presenters need to understand the rubric before they can score. This is the coaching reference they keep open on their phone.
**Stack:** Plain HTML + CSS. Mobile-first (375px base). Brand colors (#F4622A, #F9A826, #F9F7F4, #1E1E2E).
**Deliverable:** `bcs-rubric.html` — self-contained.

---

## 🟡 PROJECT — Bigger Scope
*1–2 weekends. A quick spec call if needed.*

---

### [P-04] BCS Score API — `/bcs/score`
**What:** The authoritative scoring API. Input a dog's profile and available media — get back a structured BCS score (0–20), grade (A+ through D), per-dimension breakdown, and a one-line summary.
**Why it matters:** Right now BCS scoring logic would live in two places (G-01 frontend + /story/build). One API is the single source of truth. Every tool calls it. The score is always consistent.
**API contract:**
```
POST /bcs/score
{
  dog_info:  { name, breed, age, size }
  story?:    { portable?, enriched? }    // full story text — API reads and scores
  photos?:   [ { url, caption? } ]       // actual photos — API assesses quality + count
  video?:    { url }                     // actual video — API analyzes quality + engagement
}

→ Returns:
{
  score:         number    // 0–20
  grade:         string    // "A+" | "A" | "B" | "C" | "D"
  by_dimension:  [ { name, score: 0|1|2, gap: string } ]
  summary:       string    // one plain-language line
}
```
The API receives the full listing package as published (or about to be). It does the analysis. No pre-computation before calling.
**Relationship to other tasks:**
- G-01 should call this rather than implement scoring logic directly
- P-01 calls this to know what to coach
- /story/build calls this internally and returns the score in its response
**Deliverable:** Working API endpoint + unit tests against all 10 dimensions.

---

### [P-01] Coaching Packet Generator
**What:** Given a dog's BCS score and profile, generate a one-page coaching brief for the presenter — what to improve, shot list, description draft, what to watch for in the live meet.
**Why it matters:** Presenters shouldn't have to figure out improvements from scratch. The platform tells them exactly what to do. This is what Savannah reads Saturday morning.
**Spec:**
- Input: dog name, breed, age, BCS score by dimension, existing description (optional)
- Output: top gaps with specific actions, shot list, description draft, live meet tips
- Printable / shareable
**Stack:** HTML + JS. Rule-based for v1 — no AI required.
**Deliverable:** `coaching-packet-generator.html`

---

### [P-02] Story Builder Session UI
**What:** A UI for a rescue team member to open a Story Builder session for a dog — bring in whatever they have (videos, photos, notes, observations) and receive a coached story + coaching packet back.
**Why it matters:** The Story Builder session is the atomic unit of BCS work. It takes whatever you bring — from one photo and a sentence to a full production team — and produces the best story possible right now.
**The foster reality:** This tool serves everyone from a solo introvert foster at midnight with one phone to a team with a videographer and a storyline. It cannot assume capability. It must assume heart.
**Spec:**
- Input: dog info (text, any length), photos (upload or URL), video (YouTube link or upload), voice notes (pre-transcribed to text)
- Optional: history from last session (last story, last coaching tips)
- Output: coached story (portable + enriched layers), BCS score, gaps, coaching tips, presentation tips
- Session status: open / in-progress / complete
**Stack:** HTML + JS. LocalStorage for prototype. No backend required.
**Full spec:** `strategy/feature-specs/story-builder.md`
**Deliverable:** `story-builder-session.html`

---

### [P-03] Photo Curation API
**What:** Given a set of raw photos, select and order the best ones for a dog's listing. Return the curated set with reasons — and flag rejected photos with coaching notes.
**Why it matters:** Most rescue photos are raw and unfiltered. This tool picks the strongest ones and tells the foster what to reshoot. The `rejected` list with reasons IS coaching.
**API shape:**
```
POST /photos/curate
Input:  photos[], dog_info, platform_hints (optional)
Output: selected[ { url, order, reason } ]
        rejected[ { url, reason } ]
```
**Stack:** Python or Node. Computer vision model of your choice.
**Deliverable:** Standalone API + simple test UI.

---

## 🔴 HIGH BAR — For the Right Engineer
*Genuinely hard problems. Real technical depth. This is where serious engineers play.*

---

### [H-01] AI Director — Live
**What:** Real-time AI guidance during video capture. The camera feed is live — the AI watches and directs in the moment.

> *"Biscuit's looking relaxed — if he goes in for a lick, that's your Lick Week shot. Don't force it."*
> *"Hold that — this is the moment."*
> *"Step back, you're losing the light."*

**Why it matters:** Better raw footage means better coaching output, better production result, better story. This is the top of the pipeline. Everything downstream improves when capture improves.
**The campaign layer:** Platform-wide themed campaigns (e.g. "Lick Week") pass content prompts to the AI Director. The Director surfaces them naturally — never forces them. Safe moments only.
**Technical challenge:** Real-time vision AI with low latency. If feedback is 3 seconds late it's useless. Has to feel like a director in your ear.
**Stack:** Your call. Mobile camera API + real-time vision model. Low latency is the hard problem.
**Deliverable:** Working prototype — live camera feed → real-time coaching prompts.

---

### [H-02] Video Coaching Feedback
**What:** Upload or link a video of a dog. AI analyzes it and returns coaching feedback — what worked, what to improve, shot list for next time, how to make it platform-ready.
**Why it matters:** Most rescue video is shot on a phone with no direction. This tool is the coaching layer that gets presenters to broadcast quality without requiring production experience.
**Spec:**
- Input: YouTube link or video file + dog context
- Output: what landed (keep doing this), what to improve (specific + actionable), shot list, suggested title + description
- v1: GPT-4o vision on extracted frames — full video processing is post-MVP
**Stack:** HTML + JS + OpenAI API (GPT-4o vision). Frame extraction via ffmpeg or client-side canvas.
**Deliverable:** `video-coaching.html` — upload/link → coaching card.

---

### [H-03] Video Production Engine
**What:** Takes raw footage and produces a highlight reel — edited, scored with music, paced to hold attention and make the viewer feel something.
**Why it matters:** A produced highlight reel is the max capable output of Story Builder. It's what turns a phone video into something a foster wants to share and a pet parent wants to watch.
**The challenge:** Music selection that matches the dog's personality. Pacing that leads with the emotional hook. Cuts that tell a story. A shy border collie feels different than a goofy lab — the reel should reflect that.
**Technical inputs:** `platform_hints` carries learned parameters — video length, music tone, pacing, lead asset. When hints aren't present, infer from the footage itself.
**Stack:** Your call. ffmpeg + music library + AI-directed editing.
**Deliverable:** Raw footage in → produced reel out.

---

### [H-04] Video Export Engine — YouTube-Ready Output
**What:** Takes any produced video and outputs a YouTube-ready file — correct format, resolution, audio, thumbnail, and suggested title/tags.
**Why it matters:** /video/produce creates the best possible story. /video/export makes sure it lands correctly everywhere it's shared. Callable independently on any existing video — not just BCS pipeline output.
**API shape:**
```
POST /video/export
Input:  video_url, dog_info (optional), platform_hints (optional), target (youtube/instagram/web)
Output: exported_url, thumbnail_url, suggested_title, suggested_tags, duration_seconds
```
**Stack:** ffmpeg + vision model (thumbnail) + LLM (title/tags).
**Deliverable:** Standalone API + simple test UI.

---

## Background

**Best Chance Studio** is the open source coaching layer of Wag On Home — a platform that gets rescue dogs adopted faster by giving every dog their best possible story, and every presenter the coaching they need to tell it.

The full pipeline:
```
AI Director improves the capture
  → Photo Curation selects the best stills
    → Video Coaching analyzes what was captured
      → Story Builder produces the coached story + coaching packet
        → Video Production makes the highlight reel
          → Dog goes home
```

Every tool in this list is a discrete, independently callable API. Each one makes the next one better. Each one stands on its own.

→ Full Story Builder spec: `strategy/feature-specs/story-builder.md`

---

## Two Ways In

### Grab something from the list
Pick a task. Build it. No application. No commitment. If it ships, real dogs benefit.

### Go deeper
If you can't stop thinking about what comes next after shipping something — let's talk. One lead engineer role. Own the architecture. Equity. The real conversation.

→ KipMeierhofer@gmail.com
