# How BCS Works — The Full Flow

*Last updated: March 7, 2026*

*A technical walkthrough with real inputs and outputs*

BCS is an orchestration layer. It doesn't just call one API — it reads the gaps, decides what to tackle first, calls the right tools in the right order, and assembles everything into one coaching packet. A foster submits whatever they have. BCS figures out what's missing, what matters most, and what to fix first. Here's exactly how it works.

→ New here? Read the [README](README.md) first for mission and context. Then come back here before picking a task from the pull list.

---

## Step 1: The Foster Submits What They Have

No form to fill out. No checklist. The foster drops in what they have — a paragraph of text, a photo or two, some notes from the past few months — and BCS takes it from there.

**`/voice/transcribe` — before anything else, words become text**
If the foster has voice notes — observations about the dog, things they've been meaning to write down — they record them in-app. `/voice/transcribe` converts audio to text via Whisper and feeds it directly into the session alongside the written notes. No typing required.

```json
POST /voice/transcribe
{ "audio": "note_001.m4a" }

→ { "transcript": "Moose has this thing he does every morning — finds a tennis ball and brings it to whoever's having coffee. Been doing it since week one." }
```

That transcript becomes `foster_notes` in the submission. The detail that ends up driving the whole story may start as 15 seconds of audio on a phone.

→ Building this? See [G-03] in the pull list.

This is Moose. Three years old, black lab mix, four months in foster care. Here's what came in:

```json
{
  "dog_name": "Moose",
  "raw_text": "Moose is a 3 year old lab mix. He is good with other dogs and kids. He is house trained. He has been in foster care for 4 months.",
  "photos": ["photo_001.jpg", "photo_002.jpg"],  // array — Moose submitted 2 raw shots
  "videos": [],                                   // array — empty, no video yet
  "foster_notes": "Been with us 4 months. Loves fetch. Great with our kids.",
  "rescue_id": "blues-city-memphis"
}
```

BCS receives this and immediately knows what it's working with: one photo, no video, a thin raw description, and foster notes that are — quietly — full of gold. The orchestration starts now.

---

## Step 2: `/bcs/score` — Read the Gaps

→ **[Read the full BCS rubric first](https://wag-on-home.com/bcs-review.html)** — every dimension, what it means, what good looks like, how it gets better over time. Takes 5 minutes. Makes everything below make sense.

Before doing anything else, BCS needs a map.

The score isn't a grade — it's a diagnostic. It tells BCS where the gaps are, how serious each one is, and which ones to tackle first. Without this step, every subsequent API call is flying blind. With it, every call knows exactly what it's solving for.

BCS calls `/bcs/score` first. Always.

```json
// Request
POST /bcs/score
{
  "dog_name": "Moose",
  "text": "Moose is a 3 year old lab mix. He is good with other dogs and kids. He is house trained. He has been in foster care for 4 months.",
  "photo_count": 1,
  "video_present": false,
  "foster_notes": "Been with us 4 months. Loves fetch. Great with our kids."
}

// Response
{
  "total_score": 3,
  "max_score": 18,
  "dimensions": [
    {
      "id": "personality_hook",
      "score": 0,
      "max": 2,
      "gap": "No specific moment or memorable detail. Could describe any lab."
    },
    {
      "id": "visual_impact",
      "score": 0,
      "max": 2,
      "gap": "Single shot, fluorescent lighting, no eye contact."
    },
    {
      "id": "video_presence",
      "score": 0,
      "max": 2,
      "gap": "No video present."
    },
    {
      "id": "compatibility_clarity",
      "score": 1,
      "max": 2,
      "gap": "Mentions kids and other dogs but vague — no specifics about home type or energy needs."
    },
    {
      "id": "foster_voice",
      "score": 0,
      "max": 2,
      "gap": "Reads like a form. No warmth, no relationship visible."
    },
    {
      "id": "no_surprises",
      "score": 1,
      "max": 2,
      "gap": "Energy level not communicated — adopter doesn't know what they're getting."
    },
    {
      "id": "story_first_gate",
      "score": 0,
      "max": 2,
      "gap": "No intro video. Adopter arrives cold."
    },
    {
      "id": "presenter_readiness",
      "score": 0,
      "max": 2,
      "gap": "No coached story. No strong asset identified."
    },
    {
      "id": "family_vision",
      "score": 0,
      "max": 2,
      "gap": "Nothing forms. Can't picture this dog anywhere."
    }
  ],
  "priority_gaps": ["personality_hook", "foster_voice", "family_vision"],
  "coaching_summary": "Moose has no story yet. An adopter reads this and feels nothing. Start with the personality hook — find the specific moment only this foster knows."
}
```

BCS now has its map. Score: 3 out of 18. Three priority gaps: `personality_hook`, `foster_voice`, `family_vision`. 

Here's the key orchestration decision: BCS doesn't work down the list mechanically. It looks at the priority gaps and asks — which API call fixes the most at once? The story does. Fix the story and you fix the personality hook, the foster voice, and the family vision in a single pass. 

BCS calls `/story/build` next.

→ Building this API? See [P-04] in the pull list.

---

## Step 2b: `/word/check` — Clear the Description Before Building

Before `/story/build` runs, BCS passes the raw description through `/word/check`. This catches language that measurably hurts adoption speed — not based on opinion, but on a 70,733-dog study.

```json
POST /word/check
{ "description": "Moose is a 3 year old lab mix. He is good with other dogs and kids. He is house trained. He has been in foster care for 4 months." }

→ {
    "flagged": [
      { "word": "good with", "reason": "vague — doesn't signal anything specific", "suggested_replacement": "great with" },
      { "word": "house trained", "reason": "neutral — expected, not a selling point", "suggested_replacement": "move this fact into context, not as a lead" }
    ],
    "impact_score": 34,
    "clean_version": "Moose is a 3-year-old lab mix — great with other dogs and kids, fully settled at home, four months in foster care."
  }
```

BCS passes both the `flagged` list and the `clean_version` into `/story/build` as context. The story that comes back is built on top of language that's already been cleared — and the coaching packet tells the foster exactly which words to avoid in future sessions.

→ Building this? See [G-04] in the pull list.

---

## Step 3: `/story/build` — Find the Story

BCS doesn't just pass the raw text to `/story/build`. It passes the raw text, the foster notes, *and* the gap context from Step 2. That last part is what makes the coaching specific instead of generic.

The foster notes are the gold here. "Loves fetch" — three words buried in a free-text field — is the detail that becomes the whole story. BCS surfaces it. `/story/build` uses it.

```json
// Request
POST /story/build
{
  "dog_name": "Moose",
  "raw_text": "Moose is a 3 year old lab mix. He is good with other dogs and kids. He is house trained. He has been in foster care for 4 months.",
  "foster_notes": "Been with us 4 months. Loves fetch. Great with our kids.",
  "priority_gaps": ["personality_hook", "foster_voice", "family_vision"],
  "score_context": {
    "personality_hook": {
      "score": 0,
      "gap": "No specific moment or memorable detail. Could describe any lab."
    },
    "foster_voice": {
      "score": 0,
      "gap": "Reads like a form. No warmth, no relationship visible."
    },
    "family_vision": {
      "score": 0,
      "gap": "Nothing forms. Can't picture this dog anywhere."
    }
  }
}

// Response
{
  "coached_description": "Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play. He's been doing it since day one, to every single person who walked through the door.\n\nHe's three, fully house-trained, great with other dogs and kids. He's been patient in a way that honestly shouldn't be possible — four months in rescue, and every day he keeps showing up.\n\nHe needs a family who'll actually let him tire them out. He will find the tennis ball. He will drop it in your lap. The only question is whether you're ready for that.",
  "coaching_packet": {
    "what_changed": "Pulled the fetch behavior from foster notes and made it the personality hook. Rewrote in first-person foster voice. Closed with the family vision — the adopter can picture this dog in their living room.",
    "dimensions_improved": [
      "personality_hook",
      "foster_voice",
      "family_vision",
      "compatibility_clarity"
    ],
    "estimated_score_delta": "+8"
  }
}
```

"Loves fetch" just became the opening line of Moose's whole story. That's the orchestration doing its job. BCS passed the gap context so `/story/build` knew exactly what it was solving for — not just "make this better," but "find the personality hook, write in the foster's voice, and close with something an adopter can picture."

Four dimensions improved. One API call.

→ Building this API? See [P-02] Story Builder Session UI in the pull list.

---

## Step 4: `/photos/curate` — Work With What's There

BCS doesn't wait for perfect photos. It passes all submitted photos to /photos/curate, which does three things: picks the strongest images from what's there, identifies specifically what's wrong with each one, and generates a targeted shot list for what needs to be reshot — built around both the visual gaps AND the story that /story/build just produced. The shot list isn't generic. It's Moose-specific.

The gap context travels with this call too. `/photos/curate` isn't curating in a vacuum — it knows the visual impact dimension scored 0 and why.

```json
// Request
POST /photos/curate
{
  "dog_name": "Moose",
  "photos": ["photo_001.jpg", "photo_002.jpg"],
  "score_context": {
    "visual_impact": {
      "score": 0,
      "gap": "Single shot, fluorescent lighting, no eye contact."
    }
  }
}

// Response
{
  "selected": ["photo_001.jpg"],
  "ordering": [1],
  "photo_gaps": [
    "No eye contact — dog is looking away from camera",
    "Fluorescent shelter lighting — removes warmth and personality",
    "Single angle — no full body, no action, no human connection"
  ],
  "shot_list": [
    {
      "priority": 1,
      "description": "Eye-level, natural light. Get on the floor. Moose looks at the camera, not past it.",
      "why": "Eye contact in natural light is the single strongest predictor of faster adoption."
    },
    {
      "priority": 2,
      "description": "Mid-fetch action shot. Ball in the air, Moose in motion.",
      "why": "Fetch is his personality hook — show it, don't say it."
    },
    {
      "priority": 3,
      "description": "Calm moment on the couch or floor with foster.",
      "why": "This is the dog people actually bring home. The one who fits into a life."
    }
  ],
  "coaching_note": "Three photos. 20 minutes. Completely changes this listing."
}
```

Notice shot #2: "Mid-fetch action shot." `/photos/curate` read the story that `/story/build` just built and aligned the shot list to it. The fetch behavior is now threaded through every asset — description, photos, and (next) video. That's the coaching packet telling a consistent story.

→ Building this API? See [P-03] Photo Curation API in the pull list.

---

## Step 5: The Video Pipeline

### No video yet → coaching prompt + shot agenda
BCS sees `"video": null`. It doesn't error. It generates a coaching prompt and a `shot_agenda` — specific, actionable, tied directly to Moose's story. The foster (and Pat) get a direction, not a blank ask.

```json
{
  "prompt_type": "video_absent",
  "coaching": "Fetch is Moose's superpower — and it doesn't exist yet on camera. A 60-second video of the tennis ball drop is worth more than any description we can write.",
  "shot_agenda": [
    { "id": "fetch_drop",  "description": "Tennis ball drop — sit on the floor, wait for it", "priority": "high" },
    { "id": "eye_contact", "description": "Face-close, eye contact, natural light",           "priority": "high" },
    { "id": "calm_moment", "description": "Resting or settling — the dog they bring home",    "priority": "medium" }
  ],
  "estimated_score_impact": "+4 on video_presence and story_first_gate"
}
```

### `/video/direct` — Pat gets a director in his ear
Before Pat hits record, the AI Director briefs him using the `shot_agenda`. Then it watches the live feed and coaches in real-time — quality *and* coverage.

```
Pre-session: "For Moose we need: (1) the tennis ball drop, (2) eye contact shot, (3) one calm moment. Let's go."

Live:  "Nice — that's the eye contact. Get lower, lose the shadow."
       "Tennis ball moment still needed — wait for him to bring it naturally."
       "Hold that — this is the calm moment we needed."
```

→ Building this? See [H-01] in the pull list.

### `/video/coach` — what was captured vs. what's still missing
After filming, BCS passes the footage to `/video/coach` with the original `shot_agenda`. It scores what was captured and flags what's still needed.

```json
POST /video/coach
{ "video_url": "moose_session1.mp4", "shot_agenda": [...], "dog_context": { "name": "Moose", ... } }

→ {
    "what_landed":  ["Eye contact moment — strong. Natural light, clear personality."],
    "what_to_improve": ["Tennis ball drop was staged — wait for him to initiate it naturally."],
    "agenda_coverage": [
      { "id": "eye_contact", "captured": true  },
      { "id": "fetch_drop",  "captured": false, "note": "Staged — reshoot naturally" },
      { "id": "calm_moment", "captured": true  }
    ],
    "next_session_priority": "Reshoot fetch drop — let Moose initiate. That's the personality hook."
  }
```

→ Building this? See [H-02] in the pull list.

### `/video/produce` — the highlight reel
Raw footage becomes a produced reel — edited, music matched to Moose's personality, paced to hold attention and make the viewer feel something.

```json
POST /video/produce
{ "footage_url": "moose_session1.mp4", "dog_info": { "name": "Moose", "energy": "playful" }, "platform_hints": { "video": { "length_seconds": 63, "music_tone": "warm", "open_with": "action" } } }

→ { "reel_url": "moose_reel_v1.mp4", "duration_seconds": 63, "music": "warm_acoustic_01" }
```

→ Building this? See [H-03] in the pull list.

### `/video/export` — YouTube-ready
The reel gets formatted for platform delivery — correct resolution, thumbnail generated, title and tags written.

```json
POST /video/export
{ "video_url": "moose_reel_v1.mp4", "dog_info": { "name": "Moose", ... }, "target": "youtube" }

→ {
    "exported_url":    "https://youtube.com/...",
    "thumbnail_url":   "moose_thumb.jpg",
    "suggested_title": "Moose — the dog who brings you a tennis ball before you even ask",
    "suggested_tags":  ["lab mix", "adoption", "Memphis", "Blues City Rescue"],
    "duration_seconds": 63
  }
```

→ Building this? See [H-04] in the pull list.

---

## Step 6: The Coaching Packet — Everything Comes Back Together

BCS assembles everything into one packet. The coordinator sees where Moose started and where he is now. The presenter gets a single brief. The next steps are prioritized, specific, and scored.

This is the output contract. Everything the front-end needs comes from here.

```json
// Final coaching packet
{
  "dog_name": "Moose",
  "session_id": "bcs-moose-001",
  "version": 1,
  "score_before": 3,
  "score_after": 11,
  "score_max": 18,
  "coached_description": "Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play...",
  "photo_selection": ["photo_001.jpg"],
  "shot_list": [
    {
      "priority": 1,
      "description": "Eye-level, natural light. Get on the floor. Moose looks at the camera, not past it.",
      "why": "Eye contact in natural light is the single strongest predictor of faster adoption."
    },
    {
      "priority": 2,
      "description": "Mid-fetch action shot. Ball in the air, Moose in motion.",
      "why": "Fetch is his personality hook — show it, don't say it."
    },
    {
      "priority": 3,
      "description": "Calm moment on the couch or floor with foster.",
      "why": "This is the dog people actually bring home. The one who fits into a life."
    }
  ],
  "video_coaching": {
    "status": "pending",
    "prompt": "Fetch is Moose's superpower — and it doesn't exist yet on camera. A 60-second video of the tennis ball drop is worth more than any description we can write.",
    "estimated_score_impact": "+4"
  },
  "next_steps": [
    {
      "priority": 1,
      "action": "Retake photos using shot list",
      "impact": "+2 on visual_impact"
    },
    {
      "priority": 2,
      "action": "Record the tennis ball drop — 60 seconds",
      "impact": "+4 on video_presence + story_first_gate"
    }
  ],
  "presenter_brief": "Lead with the tennis ball move. Every time. It's the moment that makes people call each other into the room."
}
```

Moose went from a 3 to an 11 without any new photos or video. When the shot list comes back and the 60-second video drops in, that number climbs to 15+. The packet tracks every version. Nothing gets lost.

---

## Step 7: `/story/refine` — The Human Gate

Nothing leaves BCS without the foster's approval. `review_required: true` is always present in the coaching packet. The foster sees a full preview — description, photos, video — and has exactly three paths:

| Action | When | What happens |
|---|---|---|
| ✅ **Accept** | "This is right. Use it." | Story locked. `review_status: approved`. Export enabled. |
| ✏️ **Tweak** | "I like the direction — adjust X." | Quick-tap or free text. BCS regenerates. Loop repeats. |
| 🔄 **Start over** | "Doesn't feel like this dog." | Back to intake pre-filled, or fresh generation — UX decision TBD. |

**Quick-tap options:** `Shorter` · `Longer` · `More playful` · `Emphasize calm` · `Less jargon` · `Different title`

```json
POST /story/refine
{ "session_id": "bcs-moose-001", "story_id": "s_001", "refine_instruction": "shorter — and lead with the tennis ball drop, not the breed stats" }

→ { "story_id": "s_001_r1", "description": "...", "review_status": "pending_approval", "refine_count": 1 }
```

`refine_count` is tracked. If a dog consistently needs 4+ refinements, it's a signal the intake data was thin — a coaching opportunity for the foster.

→ Building this? See [P-02] in the pull list.

---

## Step 8: `/story/card` + `/story/format` — Take It Anywhere

Once approved, the story is export-ready. Two final tools make it portable.

**`/story/card`** generates a shareable image card — the kind a foster posts to Facebook or texts to a friend. No link required.

```json
POST /story/card
{ "dog_name": "Moose", "hook": "The dog who brings you a tennis ball before you even ask.", "photo_url": "moose_eye.jpg", "rescue_name": "Blues City Animal Rescue" }

→ { "card_url": "moose_card_1x1.png", "card_url_portrait": "moose_card_4x5.png" }
```

**`/story/format`** reformats the approved description for each platform's character limits — no manual trimming.

```json
POST /story/format
{ "description": "...", "target": "petfinder" }

→ { "formatted": "...", "char_count": 847, "limit": 4000, "status": "within_limit" }
```

Platforms: `petfinder` · `adoptapet` · `instagram` · `facebook` · `rescuegroups`

No native integration with legacy platforms — manual copy/paste by design. BCS builds the story. The foster carries it.

Once the story is formatted and the card is downloaded, the foster copies it to wherever their rescue lists dogs:

> *Copy description → paste into Petfinder listing.*
> *Copy description → paste into AdoptAPet.*
> *Copy description → paste into ShelterLuv.*
> *Save card → post to Facebook, Instagram, rescue group chats.*
> *Paste YouTube URL → anywhere video is accepted.*

The rescue's existing workflow stays intact. No new logins, no platform switching inside BCS. We hand them something great — they post it where their adopters already are.

→ Building these? See [G-05] and [G-06] in the pull list.

---

## Step 9: `/story/represent` — If the Dog Doesn't Place

Moose went through the full pipeline. He got presented. He didn't place. This isn't failure — it's the next session starting.

`/story/represent` generates a fresh coaching brief based on what's been tried and what's missing. **What it knows depends on who's calling it.**

---

### Path A — Smart AI platform (e.g. WAH)

A platform with real adoption outcome data calls `/story/represent` automatically when a dog stalls. It passes the full picture: session history, near-miss signals from real adopters, and learned patterns from similar dogs.

```json
POST /story/represent
{
  "dog_info": { "name": "Moose", ... },
  "session_history": [
    { "story_version": 1, "coaching_tips_tried": ["personality hook", "fetch video"] }
  ],
  "platform_hints": {
    "learned": {
      "near_miss_signals":     ["3 adopters asked about apartment living"],
      "top_performer_pattern": "lab mixes in urban corridors convert faster with compatibility-led descriptions"
    },
    "dog_context": {
      "days_in_care":      11,
      "escalation_risk":   "high"
    }
  }
}
```

The platform knows what adopters said. It knows how long Moose has been waiting. It knows what's worked for similar dogs in this market. `/story/represent` uses all of it:

```json
→ {
    "new_angle":        "Lead with the apartment question — Moose does fine in smaller spaces with enough walks. Three adopters almost said yes over this exact concern.",
    "what_was_tried":   ["Fetch hook", "Eye contact photo", "60-second reel"],
    "what_was_missing": ["Apartment compatibility not addressed"],
    "try_this_next":    ["Add one sentence about Moose's daily walk routine", "Reshoot with city/outdoor background — signals urban dog"],
    "new_shot_agenda":  [...]
  }
```

The foster didn't have to figure any of this out. The platform surfaced it, called the API, and handed them a brief.

---

### Path B — Standalone / no platform intelligence

A rescue not on a smart platform can still call `/story/represent` — but they're the ones supplying the context. No automatic near-miss signals. No learned patterns.

However, a rescue coordinator who's paying attention can pass in a lot. An adopter who emailed a question and didn't apply. A comment someone left on the Facebook post. Something Beth noticed during a conversation. None of this is automated — but it can be manually added to `near_miss_signals` and the API will use it just as it would a platform-generated signal.

```json
POST /story/represent
{
  "dog_info": { "name": "Moose", ... },
  "session_history": [
    {
      "story_version": 1,
      "coaching_tips_tried": ["personality hook", "fetch video"],
      "near_miss_signals": [
        "email inquiry asked if he'd be okay in an apartment — never followed up",
        "Facebook comment: 'love him but we have a cat'",
        "Beth's note: two people asked about his energy level at the event"
      ]
    }
  ]
  // no platform_hints — but human-supplied signal is real signal
}
```

A smart rescue coordinator using standalone mode can get surprisingly close to platform-quality output — they're just doing manually what a smart platform does automatically. The API doesn't care where the signal came from. It uses what it's given.

> *"Standalone mode with no signal: solid general coaching. Standalone mode with manually-logged adopter notes: nearly as targeted as platform-connected. Smart platform: fully automatic — no human in the loop."*

---

**The design principle:** `/story/represent` degrades gracefully. Thin input → solid general coaching. Rich platform input → targeted brief built from real signal. The API never fails because `platform_hints` is absent — it just works harder to infer from what it has.

Session 2 knows what Session 1 tried. The story never resets — it compounds.

→ Building this? See [P-06] in the pull list.

---

## What This Means for Engineers

A few things worth internalizing before you build:

**Each API is independently callable.** You can build and test `/bcs/score` without touching `/story/build` or `/photos/curate`. Each endpoint has a clean input contract and a defined output. Start anywhere on the pull list.

**BCS is the orchestration layer.** It decides the call order and carries context between APIs. The individual APIs don't need to know about each other — BCS is the glue. If you're building an API endpoint, your job is to receive the input contract and return the output contract. BCS handles the sequencing.

**The gap context is what makes the coaching specific.** When BCS passes `score_context` to `/story/build`, the story it gets back is targeted. Without that context, you get generic improvement. With it, you get a story built around the three exact dimensions that scored zero. That specificity is the product.

**Version tracking is built in.** Every coaching session is `v1`. When new photos come in, that's `v2`. When the video lands, `v3`. The story evolves, scores climb, and nothing from prior sessions is lost. Coordinators can see the full arc.

**The coaching packet is the output contract.** Whatever the front-end displays — the coached description, the shot list, the presenter brief, the next steps — it all comes from the packet. Build your API, return the right fields, and the packet assembles itself correctly. That's the north star every endpoint is pointing at.

---

Pick any API from the pull list. Build it to spec. The coaching packet is the north star — everything flows toward it.

---

## How the Rubric Gets Better Over Time

The BCS rubric ships as a fixed set of dimensions and weights. But it's designed to improve — and the mechanism is deliberate.

**The rubric is versionable.** Every `/bcs/score` call returns `rubric_version: "1.0.0"`. Engineers can pin to a version. Platforms know exactly which rubric produced a given score. When the rubric updates, scores are comparable across versions.

**WAH's periodic contribution to the BCS community is the rubric.**
Wag On Home runs a real adoption platform. It captures real outcome data — days-to-home, near-miss signals, what changed between story v1 and v2 that made the difference, which BCS dimensions actually predicted faster adoption. The open source community doesn't have that data. WAH does.

Periodically, WAH analyzes correlations between BCS dimension scores and adoption outcomes and proposes a rubric update:

```
Rubric v1.0 ships — based on research + lived rescue experience
    ↓
WAH runs the platform — captures outcome data across real dogs
    ↓
WAH analysis: "personality_hook scored 0 → median 34 days to adoption.
               personality_hook scored 2 → median 9 days."
    ↓
WAH proposes: raise personality_hook weight · add new dimension: transport_clarity
    ↓
BCS community reviews → rubric v1.1 ships
    ↓
Every tool using BCS gets smarter automatically
```

**What this means for engineers:**
- Dimension weights must be configurable — not hardcoded. Store them in a config object, not scattered through scoring logic.
- The rubric config should be the single source of truth for all weight and dimension definitions.
- When WAH ships a rubric update, it ships as a config change — no API contract changes, no breaking updates.

```json
// rubric-config.json (versionable, community-owned)
{
  "version": "1.1.0",
  "dimensions": [
    { "id": "personality_hook", "max": 2, "weight": 1.4 },
    { "id": "visual_impact",    "max": 2, "weight": 1.0 },
    { "id": "video_presence",   "max": 2, "weight": 1.2 },
    { "id": "transport_clarity","max": 2, "weight": 1.3 }
    // ...
  ]
}
```

**The governance question (open):** WAH proposes rubric updates. The BCS community reviews. Anyone can pin to a prior version. This is the reciprocal relationship — WAH contributes intelligence, the community validates it, everyone benefits. Formal governance process TBD as the community grows.

---

## For Future AI-Native Adoption Platforms

BCS is designed to be standalone — it works without any external intelligence. But it's also designed to receive intelligence from a platform that has it. This section describes what becomes possible when a platform with real adoption outcome data connects to BCS.

The bridge is `platform_hints` — an optional input object every BCS API accepts. When absent, BCS uses sensible defaults. When present, BCS uses the platform's learned outcome data to make every coaching decision sharper.

Full schema: [`strategy/feature-specs/platform-hints-schema.md`](https://github.com/mei0872/wag-on-home-workspace) — the constitution every API signs.

---

### 1. Outcome-Informed Coaching

A standalone BCS call tells Moose: *"Use a personality hook. Eye contact photo. 60-second video."* That's good coaching.

A platform-connected BCS call tells Moose: *"Black labs in the Memphis corridor with this profile convert 3x faster when the opening line is a specific anecdote from the first week. The platform saw this across 847 dogs. Lead with the tennis ball story."*

That's not coaching — that's a pattern the platform learned from real outcomes and fed back in.

```json
"platform_hints": {
  "story": {
    "opening_style": "anecdote",
    "tone": "warm"
  },
  "learned": {
    "top_performer_pattern": "leads with first-week anecdote for black labs in transport corridors",
    "what_worked_last_time": "close face shot + 60-second fetch video drove 3 applications in 4 days"
  }
}
```

The BCS tools don't need to understand where this came from. They receive it, apply it, and produce better output. The platform's intelligence travels through one consistent channel to every tool in the pipeline.

---

### 2. Near-Miss Signal Loops

A near-miss happens: an adopter spends 4 minutes on Moose's profile, favorites him, and doesn't apply. The platform captures that signal and asks one warm question: *"What would help you feel more confident about Moose?"*

Answer: *"I wasn't sure how he'd do with my other dog."*

The platform routes that signal back into the open BCS session as new context:

```json
"platform_hints": {
  "learned": {
    "near_miss_signals": ["asked about dog compatibility — 3 adopters this week"]
  }
}
```

The next `/story/build` call knows to address dog compatibility directly — not because a human reviewed the signal and updated the profile, but because the platform closed the loop automatically.

Every near-miss makes the next story version better. Every version makes the next adopter's experience stronger. The story compounds — until the dog finds their family.

---

### 3. Adopter Profile Awareness

When a platform knows who's looking for a dog like Moose — their living situation, family composition, energy level, experience with large dogs — it can pass that context into BCS:

```json
"platform_hints": {
  "story": {
    "opening_style": "compatibility",
    "tone": "playful"
  },
  "dog_context": {
    "strongest_asset": "personality",
    "similar_dog_outcome": "median_days_to_adoption: 9"
  }
}
```

BCS builds the story toward the adopter who's already looking for this dog. The platform knows who that is. BCS knows how to talk to them. That connection — adopter profile informing story voice — is what turns a listing into a match.

---

### 4. AI Director Calibrated to Outcomes

The AI Director (`/video/direct`) in standalone mode coaches on universal principles: natural light, eye contact, the right moment. Good coaching for any dog.

With platform hints, the Director knows what's converting for dogs like Moose in this market right now:

```json
"platform_hints": {
  "director": {
    "shot_priority": ["face-close", "action", "human-interaction"],
    "energy_match": "playful"
  },
  "video": {
    "length_seconds": 63,
    "open_with": "action",
    "hook_window_seconds": 8
  }
}
```

The Director doesn't guess at the optimal hook window — the platform measured it. 63 seconds, open with action, within 8 seconds. That's what drove applications for dogs like Moose last month in this corridor. The open source tool is now calibrated to real-world outcomes.

---

### 5. The Zero-Person Vision

The end state for a platform that implements this well:

```
Dog arrives
  → BCS scores the submission automatically
  → Story built, coached, platform-hints-informed
  → Shot agenda generated, AI Director briefed
  → Video captured with real-time guidance
  → Reel produced, YouTube-ready, published
  → Adopter browses → near-miss signal captured
  → Platform closes the loop → Story v2 built automatically
  → Dog goes home

No human touches the workflow.
Humans touch the dog.
```

The platform doesn't just connect to BCS — it continuously feeds outcome data back into it. Every adoption closes a loop. Every loop makes the next dog's story sharper. The platform learns what works. BCS applies it. The cycle runs itself.

**BCS is the open source foundation. The platform's intelligence is what makes it compound.**

Any platform that captures real adoption outcomes — days-to-home, near-miss signals, match quality, return rates — can implement this loop. The interface is `platform_hints`. The schema is open. The tools are MIT licensed.

Build the platform. Feed the loop. The dogs get home faster.
