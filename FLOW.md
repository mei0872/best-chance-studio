# How BCS Works — The Full Flow

*Last updated: March 7, 2026*

*A technical walkthrough with real inputs and outputs*

BCS is an orchestration layer. It doesn't just call one API — it reads the gaps, decides what to tackle first, calls the right tools in the right order, and assembles everything into one coaching packet. A foster submits whatever they have. BCS figures out what's missing, what matters most, and what to fix first. Here's exactly how it works.

---

## Step 1: The Foster Submits What They Have

No form to fill out. No checklist. The foster drops in what they have — a paragraph of text, a photo or two, some notes from the past few months — and BCS takes it from there.

This is Moose. Three years old, black lab mix, four months in foster care. Here's what came in:

```json
{
  "dog_name": "Moose",
  "raw_text": "Moose is a 3 year old lab mix. He is good with other dogs and kids. He is house trained. He has been in foster care for 4 months.",
  "photos": ["photo_001.jpg"],
  "video": null,
  "foster_notes": "Been with us 4 months. Loves fetch. Great with our kids.",
  "rescue_id": "blues-city-memphis"
}
```

BCS receives this and immediately knows what it's working with: one photo, no video, a thin raw description, and foster notes that are — quietly — full of gold. The orchestration starts now.

---

## Step 2: `/bcs/score` — Read the Gaps

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

---

## Step 4: `/photos/curate` — Work With What's There

BCS doesn't wait for perfect photos. It works with what the foster submitted, selects the best available frame, identifies exactly what's wrong with it, and generates a specific shot list for what to retake.

The gap context travels with this call too. `/photos/curate` isn't curating in a vacuum — it knows the visual impact dimension scored 0 and why.

```json
// Request
POST /photos/curate
{
  "dog_name": "Moose",
  "photos": ["photo_001.jpg"],
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

---

## Step 5: No Video → Generate Coaching Prompt

BCS sees `"video": null` in the original submission. It doesn't error. It doesn't skip. It doesn't ask the foster to "please upload a video."

It generates a coaching prompt — specific, actionable, tied directly to Moose's story. The foster gets a direction, not a blank ask.

This happens at the logic layer. No external API call required.

```json
// BCS generates coaching prompt (no API call needed — logic layer)
{
  "prompt_type": "video_absent",
  "priority": "high",
  "coaching": "Fetch is Moose's superpower — and it doesn't exist yet on camera. A 60-second video of the tennis ball drop is worth more than any description we can write.",
  "shot_direction": "Start sitting on the floor. Wait for Moose to bring the ball. Let it happen naturally. Don't stage it — just capture what he already does every day.",
  "estimated_score_impact": "+4 on video_presence and story_first_gate"
}
```

The foster gets exactly what to do next. Four points sitting on the table, waiting for a 60-second video on a phone.

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

## What This Means for Engineers

A few things worth internalizing before you build:

**Each API is independently callable.** You can build and test `/bcs/score` without touching `/story/build` or `/photos/curate`. Each endpoint has a clean input contract and a defined output. Start anywhere on the pull list.

**BCS is the orchestration layer.** It decides the call order and carries context between APIs. The individual APIs don't need to know about each other — BCS is the glue. If you're building an API endpoint, your job is to receive the input contract and return the output contract. BCS handles the sequencing.

**The gap context is what makes the coaching specific.** When BCS passes `score_context` to `/story/build`, the story it gets back is targeted. Without that context, you get generic improvement. With it, you get a story built around the three exact dimensions that scored zero. That specificity is the product.

**Version tracking is built in.** Every coaching session is `v1`. When new photos come in, that's `v2`. When the video lands, `v3`. The story evolves, scores climb, and nothing from prior sessions is lost. Coordinators can see the full arc.

**The coaching packet is the output contract.** Whatever the front-end displays — the coached description, the shot list, the presenter brief, the next steps — it all comes from the packet. Build your API, return the right fields, and the packet assembles itself correctly. That's the north star every endpoint is pointing at.

---

Pick any API from the pull list. Build it to spec. The coaching packet is the north star — everything flows toward it.
