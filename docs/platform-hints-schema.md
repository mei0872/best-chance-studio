# platform_hints — Shared Schema
*Last updated: March 7, 2026*
*Owner: Neo — this is the constitution. Every API signs it.*

> platform_hints is the channel through which the platform's intelligence talks to the open source tools.
> The tools work without it. They work better with it.
> Every API in the BCS pipeline accepts the same shape — no inventing your own format.

---

## The Principle

BCS has 14 APIs. Left to their own devices, 14 engineers build 14 different hint formats and nothing connects.

This document prevents that. One schema. Every API consumes the same fields and ignores what it doesn't need.

> *"The tools are the instruments. platform_hints is the musician. Better musician → better music. Same instruments either way."*

---

## The Full Schema

```json
{
  "platform_hints": {

    // ── STORY ──────────────────────────────────────────────────
    "story": {
      "opening_style":       "anecdote | personality | compatibility | action",
      "description_length":  "short | medium | long",
      "tone":                "warm | playful | gentle | bold",
      "lead_asset":          "video | photo | description",
      "keywords_avoid":      ["energetic", "dominant", "trainable"],
      "keywords_prefer":     ["eager", "clever", "gentle", "lively"]
    },

    // ── PHOTOS ─────────────────────────────────────────────────
    "photos": {
      "count":               3,
      "lead_shot":           "face | action | human-with-dog",
      "order":               ["face", "full-body", "action"],
      "surface":             "web | social | print"
    },

    // ── VIDEO ──────────────────────────────────────────────────
    "video": {
      "length_seconds":      73,
      "music_tone":          "warm | upbeat | gentle | playful | cinematic",
      "pacing":              "slow | medium | fast",
      "open_with":           "action | face | human-moment | quiet",
      "hook_window_seconds": 8
    },

    // ── AI DIRECTOR (live capture) ─────────────────────────────
    "director": {
      "shot_priority":       ["face-close", "eye-contact", "action", "human-interaction"],
      "safe_moments_only":   true,
      "energy_match":        "calm | playful | curious | affectionate"
    },

    // ── CAMPAIGN (themed content) ──────────────────────────────
    "campaign": {
      "name":                "Lick Week",
      "prompt":              "capture a lick moment — only if safe and natural",
      "reel_theme":          "licks",
      "safe_check":          true,
      "active":              true
    },

    // ── DOG CONTEXT (cross-API) ────────────────────────────────
    "dog_context": {
      "bcs_score":           8,
      "days_in_care":        6,
      "escalation_risk":     "low | medium | high",
      "known_gaps":          ["no transport listed", "no video"],
      "strongest_asset":     "personality | photos | video | story",
      "similar_dog_outcome": "median_days_to_adoption: 11"
    },

    // ── PLATFORM LEARNING ──────────────────────────────────────
    "learned": {
      "top_performer_pattern": "leads with first-week anecdote for shy dogs",
      "near_miss_signals":     ["asked about dog compatibility", "favorited but no apply"],
      "what_worked_last_time": "close face shot + 60-second video drove 3 applications"
    }

  }
}
```

---

## Which APIs Use Which Fields

### Core pipeline APIs

| Field Group | Story Build (P-05) | Coaching Packet (P-01) | Photo Curation (P-03) | AI Director (H-01) | Video Coaching (H-02) | Video Produce (H-03) | Video Export (H-04) |
|---|---|---|---|---|---|---|---|
| `story` | ✅ primary | ✅ | — | — | — | — | — |
| `photos` | ✅ calls /curate | — | ✅ primary | — | — | — | — |
| `video` | — | — | — | — | ✅ primary | ✅ primary | ✅ primary |
| `director` | — | ✅ shot_agenda | ✅ shot_agenda | ✅ primary | ✅ coverage | — | — |
| `campaign` | ✅ aware | ✅ aware | ✅ aware | ✅ primary | ✅ aware | ✅ primary | ✅ aware |
| `dog_context` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `learned` | ✅ | ✅ | — | ✅ | ✅ | ✅ | ✅ |

### Review, refinement, and export APIs

| Field Group | Story Refine (P-02) | Re-Present (P-06) | Story Card (G-05) | Platform Fmt (G-06) | Word Check (G-04) | Voice Tx (G-03) |
|---|---|---|---|---|---|---|
| `story` | ✅ primary | ✅ | — | — | — | — |
| `photos` | — | — | ✅ lead_shot | — | — | — |
| `video` | — | — | — | — | — | — |
| `director` | — | ✅ new_shot_agenda | — | — | — | — |
| `campaign` | ✅ aware | — | ✅ aware | — | — | — |
| `dog_context` | ✅ | ✅ primary | ✅ | ✅ urgency | — | — |
| `learned` | ✅ | ✅ primary | — | — | — | — |

**Notes:**
- `Word Check (G-04)` — rule-based v1, no platform_hints needed. Future: `learned.near_miss_signals` could flag words specific to near-miss patterns.
- `Voice Transcription (G-03)` — input-only tool (audio → text). No platform_hints consumed.
- `Re-Presentation Brief (P-06)` — heaviest `learned` consumer. The entire smart-vs-standalone distinction lives here.

**Rule:** Every API ignores fields it doesn't need. No API fails if a field group is absent.

---

## Fallback Behavior (When Hints Are Absent)

Every API follows the same 4-level fallback:

```
1. platform_hints   → use them (platform knows best — real outcome data)
2. history          → learn from what worked before for this dog
3. session inputs   → infer from what was just captured
4. sensible defaults → best general practice
```

Absent hints is not an error. It is standalone / open source mode.

---

## Rules for Contributors

**You must:**
- Accept `platform_hints` as an optional input object
- Ignore gracefully any field you don't recognize
- Never fail if `platform_hints` is null or absent
- Document which field groups your API consumes

**You must not:**
- Invent your own hints format
- Require any hint field to be present
- Treat any hint as a hard constraint — hints are guidance, not commands
- Break if the platform adds a new field group you haven't seen before

---

## Rules for the Platform (Proprietary Layer)

- The platform populates hints from real outcome data — adoption rates, days-to-home, near-miss signals, top performer patterns
- Hints are generated per-dog, per-session — not generic defaults
- The platform learns continuously: what gets a dog like this adopted faster this week may differ from last week
- Hints are never mandatory — they are the platform's best current guess, offered as input

---

## Versioning

`platform_hints` is a living schema. New field groups will be added as the platform learns more.

**Backward compatibility rule:** New fields are always additive. Nothing is removed. Old implementations that don't recognize new fields ignore them silently.

No versioning header required — the ignore-unknown-fields rule makes it self-compatible.

---

## Why This Matters

Without this document: 14 engineers, 14 hint formats, 14 APIs that don't talk to each other.

With this document: the AI Director knows what the Story Builder knows. The Video Production engine reads the same campaign context as the Photo Curation API. The platform's intelligence flows through one consistent channel to every tool in the pipeline.

The hints are what hold the pipeline together without making the tools dependent on each other.
