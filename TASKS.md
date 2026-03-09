# Best Chance Studio — Pull List
*Last updated: March 9, 2026*

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

### [G-04] Word Check Tool — `/word/check`
**What:** A simple tool — paste a dog description, get back flagged words with adoption-proven replacements and a cleaned version.
**Why it matters:** Language measurably affects adoption speed. This tool surfaces the specific words that hurt and shows exactly what to replace them with. Backed by a 70,733-dog study.
**Stack:** Plain HTML + vanilla JS. Hardcode the word list from the study. Two modes: (1) standalone paste tool — user pastes a description for spot-checking; (2) callable as `POST /word/check` in the BCS pipeline, where it runs automatically on the extracted story text — no manual paste needed inside a session.
**Deliverable:** `word-check.html` — self-contained, no build step. Input field, flagged word list with replacements, cleaned output version.

---

### [G-05] Story Card Generator — `/story/card`
**What:** Takes an approved dog description and a photo and produces a shareable image card for social — the kind a foster posts to Facebook or texts to a friend.
**Why it matters:** Most adopters see a dog first on social, not on a listing site. A story card gives the coached story a format that travels — no link required.
**Stack:** Plain HTML + canvas API. Two formats: 1:1 (Instagram) and 4:5 (portrait/stories).
**Inputs:** Dog name, hook line (one sentence), photo URL, rescue name.
**Deliverable:** `story-card-generator.html` — upload photo + enter hook → download card. Both formats in one tool.

---

### [G-06] Story Formatter — `/story/format`
**What:** Takes an approved coached description and reformats it for a specific platform — character limits handled, no manual trimming. Supports the Rescue Template Library (see below) — selected templates append after the coached story before formatting.
**Why it matters:** Petfinder, AdoptAPet, Instagram, and Facebook all have different character limits and conventions. This tool does the reformatting so the foster just copies and pastes.
**Platforms:** `petfinder` · `adoptapet` · `instagram` · `facebook` · `rescuegroups`
**API shape:**
```
POST /story/format
Input:
  description: string        // the coached story text
  target: string             // "petfinder" | "adoptapet" | "instagram" | "facebook" | "rescuegroups"
  templates?: [ { id, text } ]  // optional — rescue-defined boilerplate to append

Output:
  formatted: string          // the final assembled text, within platform limits
  char_count: number
  limit: number
  status: string             // "within_limit" | "at_limit" | "over_limit"
  templates_included?: []    // which template ids were appended
  template_warning?: string  // present if any template pushed output over char limit — names offending template
```
**Template handling:** When `templates[]` are provided (by a platform passing rescue-defined boilerplate), they are appended after the coached story before character limits are enforced. Standalone BCS omits `templates[]` — coached story only. Same API, both use cases.
**Character limit logic:** When `templates[]` are provided, BCS uses reserve-and-allocate: `story_budget = platform_limit - template_length`. The coached story is formatted to fit `story_budget`; templates append after. If templates leave fewer than ~300 chars for the dog story, `template_warning` fires. The dog story always gets priority — templates are logistics, not the reason anyone adopts.
**Stack:** Plain HTML + vanilla JS. Rule-based character limits per platform.
**Deliverable:** `story-formatter.html` — paste description, pick platform, select templates to append, get formatted output with character count and status.

---

### [G-07] Rescue Template Library *(Platform implementation — not a standalone grab-and-go task)*

**What:** Persistent storage and management of rescue-defined boilerplate templates (UW rules, transport logistics, adoption process info, links). Rescues define their standard paragraphs once and select them per dog at export. The coached story stays focused on the dog; logistics append cleanly afterward.

**Why it matters:** Rescues using Petfinder, AdoptAPet, or RescueGroups manually paste the same boilerplate into every listing. The full library experience defines it once and appends automatically — real time saved at scale.

**Scope note:** This is a platform-layer feature. Standalone BCS does not register rescues, store templates, or persist data between sessions.

**What standalone BCS provides:** `/bcs/score` detects non-story content and returns `detected_boilerplate[]`. `/story/build` reformats it and returns `reformatted_boilerplate[]` — a clean, copy-ready logistics paragraph. The P-02 session UI displays `reformatted_boilerplate[]` with a copy button. No storage, no library, no accounts.

**Platform implementation:** A platform builds on this foundation — store the reformatted output as a template, let rescues manage a library, auto-append at export via `templates[]` in `/story/format`. The `templates[]` parameter in `/story/format` is the integration point between the platform's library and the BCS formatting step.

> **This task is not in the open source pull list.** Platform builders: use `reformatted_boilerplate[]` as your template seed and build the library layer from there.

---

### [G-08] Voice Transcription — `/voice/transcribe`
**What:** Record a voice note in-app — Whisper transcription returns text into the session. A foster who records 15 seconds of observations on their phone gets the same quality input as someone who types it out.
**Why it matters:** The best observations about a dog come in the moment — while playing in the yard, during a walk, when the foster notices something specific. This tool captures that signal before it's lost. No typing required.
**Stack:** Python or Node + OpenAI Whisper API (or local Whisper for offline-capable builds).
**API shape:**
```
POST /voice/transcribe
Input:  { audio: "path/to/note.m4a" }
Output: { transcript: "string" }
```
**Deliverable:** Standalone API endpoint. Test with a 15-second voice note describing a dog. Output should be clean text ready to pass into a Story Builder session.

> Grab this task: comment below to claim it. Questions? Start a Discussion.

---

## 🟡 PROJECT — Bigger Scope
*1–2 weekends. A quick spec call if needed.*

---

### [P-04] BCS Score API — `/bcs/score`
**What:** The authoritative scoring API. Input a dog's profile and available media — get back a structured BCS score (0–18), grade (A+ through D), per-dimension breakdown, and a one-line summary.
**Why it matters:** Right now BCS scoring logic would live in two places (G-01 frontend + /story/build). One API is the single source of truth. Every tool calls it. The score is always consistent.
**API contract:**
```
POST /bcs/score

Input:
  story {                        // the dog's current published presentation
    description?:  string        // text description as published (paste from Petfinder etc.)
    photos?:       [ { url } ]   // actual photos — API assesses quality, composition, count
    video?:        { url }       // actual video URL — API analyzes engagement quality
    screen_recording?: { url }   // video of profile screen — API extracts all elements
    source?:       string        // "petfinder" | "shelterluv" | "adoptapet" | "other"
  }
  new_content? {                 // optional — new raw material for building next version
    photos?:       [ { url } ]
    videos?:       [ { url } ]
    voice_notes?:  [ { url } ]   // pre-transcribed via /voice/transcribe
    foster_notes?: string
  }
  dog_info? {                    // optional supplementary info
    name?:   string
    breed?:  string
    age?:    string
  }

Output:
  total_score:    number          // 0–18
  max_score:      18
  grade:          string          // "A+" | "A" | "B" | "C" | "D"
  grade_label:    string          // e.g. "Good"
  rubric_version: string
  dimensions: [
    { id: string, score: 0|1|2, max: 2, gap: string }
  ]
  priority_gaps:  [ string ]      // top gaps, ordered by impact; consumed directly by /story/build and /photos/curate
  coaching_summary: string        // one plain-language line
  detected_boilerplate: [         // present when non-story content found
    { type: string, excerpt: string }
    // type: "transport_info" | "uw_rules" | "apply_link" | "org_blurb" | "fta_offer"
  ]
```
The API receives the full listing package as published (or about to be). It does the analysis. No pre-computation before calling.

**Three call patterns:** (1) story{} only → score + gaps, no new story built. (2) story{} + new_content{} → score existing, build improved version. (3) new_content{} only → build from scratch, no baseline score.

**Related:** Discussion [#27](https://github.com/mei0872/best-chance-studio/discussions/27) — non-story content detection design

**Relationship to other tasks:**
- G-01 should call this rather than implement scoring logic directly
- P-01 calls this to know what to coach
- /story/build calls this internally and returns the score in its response
**Deliverable:** Working API endpoint + unit tests against all 9 dimensions.

---

### [P-01] Coaching Packet Generator
**What:** Given a dog's BCS score and profile, generate a one-page coaching brief for the presenter — what to improve, shot list, description draft, what to watch for in the live meet.
**Why it matters:** Presenters shouldn't have to figure out improvements from scratch. The platform tells them exactly what to do. This is what Savannah reads Saturday morning.
**Spec:**
```
POST /coaching/packet
Input:
  score_context{}              // from /bcs/score — gaps, dimension scores
  behavior_notes[]             // foster observations — structured, timestamped
  adopter_feedback[]           // questions/hesitations from meet & greet sessions
  failed_adoption_notes[]      // post-failed discussion notes — why it didn't work, what was said
  concern_flags[]              // coordinator notes, vet flags, known challenges
  platform_hints {             // optional — platform passes accumulated learning here
    similar_dog_patterns {}    // what worked for dogs with similar profile/gaps
    adopter_signals {}         // what questions adopters typically ask for this type
    failed_adoption_learnings []  // concerns from failed adoptions for similar dogs
    top_performer_framing {}   // story angle that drove fastest placement for similar dogs
    concern_mitigation {}      // known concerns for this profile + what addressed them
  }

Output: (coaching packet — gap coaching, priority actions, platform-specific notes)
  top_gaps[]                   // gaps ranked by impact, with specific actions for each
  shot_list[]                  // prioritized shot agenda tied to gap context
  description_draft            // suggested rewrite, scoped to priority gaps
  live_meet_tips[]             // what to watch for, what to lead with
  presenter_brief              // the one-liner the presenter says first
```

**Intelligence:** `platform_hints{}` is the return channel for accumulated platform learning. Standalone BCS omits it — coaching is effective without it. Platforms populate it from outcome data over time. See [`docs/intelligence.md`](docs/intelligence.md).
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

### [P-05] Story Builder API — `/story/build`
**What:** The core AI story generation API. Given a dog's current story and gap context from `/bcs/score`, produce a coached description, a coaching packet, and — when boilerplate is detected — a reformatted version of that boilerplate ready for the Rescue Template Library.
**Why it matters:** This is where the raw submission becomes a story. The gap context is what makes coaching specific — not "make this better" but "fix these three exact dimensions." See FLOW.md Step 3 for the full orchestration context.
**API shape:**
```
POST /story/build
Input:
  story{}                   // the original published presentation (for tone/context reference)
  curated_content {         // output from upstream curation APIs — NOT raw files
    selected_photos[]       // from /photos/curate output
    video_coverage{}        // from /video/coach output — what was confirmed captured
    coaching_context {      // from H-01 checklist — confirmed content pieces, moments noted
      checklist_completed[] // content pieces confirmed captured
      moments_noted[]       // specific moments flagged during capture
      shot_agenda_coverage  // what was asked for vs. what was delivered
    }
  }
  priority_gaps[]           // from /bcs/score
  score_context{}           // per-dimension gap detail from /bcs/score
  platform_hints{}          // optional

Output: (unchanged — coached_story, coaching_packet, reformatted_boilerplate[], review_required: true)
```

**Note:** `curated_content{}` receives the OUTPUT of curation APIs (/photos/curate, /video/coach), not raw uploads. Raw content is processed by those APIs first. story/build focuses on one job: producing the best possible coached description from confirmed, curated material.
**Boilerplate handling:** When `/bcs/score` detects non-story content (UW rules, transport logistics, org blurb, apply links), `/story/build` receives that context and reformats it — cleaned up and consistently structured — returned alongside the coached story. The rescue sees the clean split immediately. No forced workflow change; the reformatted content becomes a natural candidate for G-07 when they're ready.
**Stack:** Python or Node + LLM of your choice (GPT-4o recommended).
**Full spec:** `strategy/feature-specs/story-builder.md`
**Related:** Discussion [#27](https://github.com/mei0872/best-chance-studio/discussions/27) — non-story content detection design
**Deliverable:** Standalone API endpoint. Test against the Moose example in FLOW.md — input the 3/18 profile, verify the output hits personality_hook, foster_voice, and family_vision.

---

### [P-06] Story Represent API — `/story/represent`
**What:** Given a dog's session history and near-miss signals, generate a fresh coaching brief for a dog who didn't place. The next session knows what the last session tried.
**Why it matters:** Dogs that don't place on first presentation need a new angle — not a repeat of what already didn't work. This API reads what was tried, what signals came back, and builds the next approach from there. See FLOW.md Step 9 for the full orchestration context.
**API shape:**
```
POST /story/represent
Input:
  dog_info{}
  session_history[]        // prior coaching sessions, what was tried
  platform_hints{          // optional — richer output when present
    learned {
      near_miss_signals[]  // adopter signals that didn't convert
      top_performer_pattern
    }
    dog_context {
      days_in_care
      escalation_risk
    }
  }

Output:
  new_angle                // what to try next, and why
  what_was_tried[]         // summary of prior attempts
  what_was_missing[]       // gaps that prior sessions didn't close
  try_this_next[]          // specific, actionable coaching prompts
  new_shot_agenda[]        // updated shot list if visual assets need work
```
**Design principle:** Degrades gracefully. No `platform_hints` → solid general coaching based on session history. With `platform_hints` → targeted brief built from real adopter signal. The API never fails because context is absent — it uses what it's given.
**Stack:** Python or Node + LLM of your choice.
**Deliverable:** Standalone API endpoint. Test against both Path A (platform-connected) and Path B (standalone with manually logged signals) as described in FLOW.md.

---

### [P-07] Audio Cleanup — `/video/clean-audio`
**What:** Takes raw capture footage and returns a clean audio track — videographer voice removed, filler words (ums, ands, pauses) cut, background noise reduced.
**Why it matters:** Raw capture always contains direction talk, instructions during shooting, and ambient noise. This cleans it before production so /video/produce works from the best possible audio.
**API shape:**
```
POST /video/clean-audio
Input:  { video_url: string, remove_voices?: [ "videographer" ], remove_fillers?: boolean }
Output: { clean_audio_url: string, clean_video_url: string, edits_made: [ string ] }
```
**Stack:** Python + ffmpeg + Whisper (voice identification and removal). Speaker diarization to isolate and remove the videographer's voice.
**Deliverable:** Standalone API endpoint. Test with a raw capture clip containing direction talk — verify output has clean audio with the dog's natural sounds preserved.

> Grab this task: comment below to claim it. Questions? Start a Discussion.

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
**YouTube OAuth note:** Rescues connect their YouTube channel once during BCS setup. After that, /video/export uploads directly and returns the published URL — no manual steps. The URL then travels to Petfinder, AdoptAPet, platform dog profiles, and social. This is a BCS setup requirement, not limited to any single platform.
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

**Best Chance Studio** is an open source coaching and scoring layer that gives every rescue dog their best possible story, and every presenter the coaching they need to tell it.

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
