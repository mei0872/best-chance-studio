# BCS API Stubs

*Last updated: March 7, 2026*

## What Are Stubs?

Stubs are static request/response examples for every BCS API endpoint. They let you build, test, and wire up the frontend **without a live backend** — just load the JSON and treat it as the real API response.

Each file represents one API call in the BCS pipeline, using a consistent example: **Moose**, a 3-year-old black lab mix at Blues City Animal Rescue in Memphis (`rescue_id: "blues-city-memphis"`).

## File Index

| File | API Endpoint | Step |
|---|---|---|
| `voice-transcribe.json` | `POST /voice/transcribe` | Step 1 — voice notes → text |
| `bcs-score.json` | `POST /bcs/score` | Step 2 — gap diagnostic |
| `story-build.json` | `POST /story/build` | Step 3 — coached story |
| `photos-curate.json` | `POST /photos/curate` | Step 4 — photo selection + shot list |
| `video-coach.json` | `POST /video/coach` | Step 5 — footage review |
| `video-export.json` | `POST /video/export` | Step 5 — platform-ready export |
| `coaching-packet.json` | Final assembled packet | Step 6 — full output contract |

## How to Use

### For frontend development
Load a stub file and mock the API call to return `response`. Example (fetch mock):

```js
import bcsScore from './stubs/bcs-score.json';

// In your mock layer:
if (endpoint === '/bcs/score') return bcsScore.response;
```

### For API development
Use the `request` object as a test payload and validate your endpoint returns a response that matches the shape of `response`.

### For integration testing
Run the pipeline in sequence: feed each stub's `response` into the next stub's `request` to simulate the full BCS orchestration flow.

## Stub File Structure

Every stub follows the same shape:

```json
{
  "_description": "One sentence describing what this API does",
  "_flow_reference": "See Step X in FLOW.md",
  "request": { ... },
  "response": { ... }
}
```

## Key Constants (Moose scenario)

- `dog_name`: `"Moose"`
- `rescue_id`: `"blues-city-memphis"`
- `session_id`: `"bcs-moose-001"`
- Starting score: `3 / 18`
- Score after story build: `11 / 18`
- 9 scoring dimensions: `personality_hook`, `visual_impact`, `video_presence`, `compatibility_clarity`, `foster_voice`, `no_surprises`, `story_first_gate`, `presenter_readiness`, `family_vision`

## Source of Truth

All examples are derived from `FLOW.md`. Where FLOW.md contains exact JSON, it's used verbatim. Where FLOW.md describes behavior without a full example (e.g. `/video/coach`), the stub was filled in using consistent Moose-scenario context.

Rubric dimensions and weights come from `rubric-config.json` (v1.0.0).
