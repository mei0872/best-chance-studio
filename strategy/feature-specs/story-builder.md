# Story Builder — Feature Spec

*Last updated: March 8, 2026*

---

## What It Is

Story Builder is the atomic unit of BCS work. It takes whatever a rescue team has — from one photo and a sentence to a full production team — and produces the best coached story possible right now.

It is not a form. It is not a template generator. It is a coaching session.

---

## The Two Layers

Every dog that goes through Story Builder produces two versions of their description:

**Portable layer** — for listing platforms. Character-limit-aware. Compatible with Petfinder, AdoptAPet, Facebook, Instagram. Works without any video or live meet context.

**Enriched layer** — for the live meet and platform-native experiences. Longer, richer, includes the presenter brief and live meet coaching. Not constrained by character limits.

Both layers come from one session. Story Builder produces them together.

---

## The Foster Reality

Story Builder serves everyone from a solo introvert foster at midnight with one phone and a dog who won't sit still — to a rescue team with a coordinator, presenter, videographer, and social media person.

**Build for the person with the least, not the most.**

The minimum viable session is: one sentence + one photo → still produces something useful.

The maximum capable output is: full coached story + presenter brief + shot list + video coaching + shareable card.

Both are real. Neither is hypothetical. The session starts with what's submitted and builds toward the maximum capable output as more assets come in.

---

## Session Lifecycle

```
OPEN        → Session created. Dog profile submitted.
IN_PROGRESS → BCS score run. Story generation begun. Foster reviewing.
COMPLETE    → Story approved by foster. Assets locked. Export enabled.
```

Sessions are versioned. Every time new assets come in (photos, video, foster notes), that's a new version — not a new session. The history is preserved.

```
v1 → story from text only
v2 → story updated after photos submitted
v3 → story updated after video submitted and /video/coach feedback incorporated
```

Nothing is lost. Nothing resets. The story compounds.

---

## Session Input Contract

```json
{
  "dog_name": "string",
  "rescue_id": "string",
  "session_id": "string | null",          // null = new session

  "raw_text": "string",                   // free-text from foster — any length
  "foster_notes": "string | null",        // additional observations
  "voice_transcript": "string | null",    // pre-processed from /voice/transcribe

  "photos": [                             // array — can be empty
    { "url": "string", "caption": "string | null" }
  ],
  "videos": [                             // array — can be empty
    { "url": "string" }
  ],

  "prior_session": {                      // optional — for session continuity
    "story_version": "number",
    "coached_description": "string",
    "coaching_tips_tried": ["string"],
    "near_miss_signals": ["string"]
  },

  "platform_hints": {}                    // optional — platform intelligence layer
}
```

---

## Session Output Contract

```json
{
  "session_id": "string",
  "version": "number",

  "score_before": "number",
  "score_after": "number",
  "score_max": 18,
  "rubric_version": "string",

  "coached_description": {
    "portable": "string",                 // listing-platform-ready, within limits
    "enriched": "string"                  // full version, no character constraint
  },

  "coaching_packet": {
    "what_changed": "string",
    "dimensions_improved": ["string"],
    "estimated_score_delta": "string",
    "presenter_brief": "string",
    "key_asset": "string"
  },

  "photo_selection": ["string"],          // selected photo URLs in order
  "shot_list": [                          // generated from gap context + story
    {
      "priority": "number",
      "description": "string",
      "why": "string"
    }
  ],

  "video_coaching": {
    "status": "pending | complete | not_applicable",
    "coaching": "string | null",
    "shot_agenda": ["object"],
    "estimated_score_impact": "string | null"
  },

  "next_steps": [
    {
      "priority": "number",
      "action": "string",
      "impact": "string"
    }
  ],

  "review_status": "pending_approval | approved | rejected",
  "review_required": true
}
```

---

## Orchestration — How Story Builder Uses BCS APIs

Story Builder is a session layer that orchestrates the BCS APIs in sequence. It does not contain scoring or coaching logic itself — it calls the right APIs in the right order and assembles the output into one coaching packet.

**Full orchestration flow is documented in FLOW.md.** Read it before building the session UI ([P-02]) or the Story Builder API ([P-05]).

High-level sequence:
1. `/voice/transcribe` — if voice notes present, transcribe first
2. `/word/check` — clear the raw description before story generation
3. `/bcs/score` — read the gaps, generate the coaching map
4. `/story/build` — produce the coached story using gap context
5. `/photos/curate` — select and order photos, generate shot list
6. `/story/refine` — human gate — foster approves, tweaks, or starts over
7. `/story/card` + `/story/format` — export-ready when approved

Video pipeline runs in parallel when footage is submitted.

---

## The Human Gate

Nothing leaves Story Builder without the foster's approval. `review_required: true` is hardcoded in the output — it is not configurable.

Three paths after review:
- **Accept** → story locked, `review_status: approved`, export enabled
- **Tweak** → foster notes what to change, `/story/refine` generates a new version
- **Start over** → back to intake, session history preserved

Quick-tap tweak options (no free-text required for common changes):
`Shorter` · `Longer` · `More playful` · `Emphasize calm` · `Less jargon` · `Different opening`

`refine_count` is tracked per session. 4+ refinements on a single story is a signal the intake data was thin — a coaching opportunity.

---

## What "Done" Looks Like for a Story Builder Build

**Minimum:** Session UI ([P-02]) accepts any combination of text/photos/video, calls `/bcs/score` and `/story/build`, returns a coaching packet, and shows the foster the review gate.

**Full:** All 7 API calls wired up. Both portable and enriched description layers. Shot list generated. Video coaching prompt present when no video submitted. Export to card and formatted output available after approval.

Test against the Moose example in FLOW.md: start with the 3/18 raw profile, verify the coached output improves at minimum personality_hook, foster_voice, and family_vision.

---

## Related Tasks

- **[P-02]** Story Builder Session UI — the UI that wraps this flow
- **[P-04]** BCS Score API — called in Step 3
- **[P-05]** Story Builder API — the `/story/build` endpoint
- **[G-04]** Word Check Tool — called in Step 2
- **[G-05]** Story Card Generator — called after approval
- **[G-06]** Story Formatter — called after approval

→ Full orchestration: [FLOW.md](../../FLOW.md)
