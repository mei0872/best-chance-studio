# BCS Data Dictionary

*Last updated: March 10, 2026*

> **This document is for engineers building BCS API implementations.** For the community-readable rubric, see [RUBRIC.md](../RUBRIC.md).

Single source of truth for all field names, types, and valid values used across the BCS spec. When a field name appears in any API request or response, this is the authoritative definition.

---

## How to Use This

- **Implementors:** Before writing any API handler, look up every field here. Use the canonical name exactly — no aliases.
- **Contributors:** When proposing new fields, add them here first and reference this doc in your PR.
- **Reviewers:** If a PR uses a field not in this dictionary, ask for it to be added before merging.

---

## Input Fields

Fields submitted to BCS APIs by the caller.

### story{}

The current published presentation — what adopters see right now on the rescue's listing platform.

| Field | Type | Valid Values | Notes |
|-------|------|-------------|-------|
| story.name | string | any | Dog's name as it appears on the listing |
| story.text | string | any | The full published description text — also accepted as `story.description` in some call patterns |
| story.photo_urls[] | array of strings | valid URLs | Direct URLs to published listing photos for analysis |
| story.video_url | string \| null | valid URL or null | Published video URL (YouTube, Vimeo, etc.) |
| story.platform | string | "petfinder" \| "adoptapet" \| "rescuegroups" \| "shelterluv" \| "other" | Source platform — also accepted as `story.source` |
| story.age | string | "Baby" \| "Young" \| "Adult" \| "Senior" | Aligned with Petfinder standard |
| story.breed_primary | string | any | Primary breed as listed |
| story.breed_secondary | string \| null | any | Secondary breed if mixed |
| story.size | string | "Small" \| "Medium" \| "Large" \| "XL" | Aligned with Petfinder standard |
| story.gender | string | "Male" \| "Female" \| "Unknown" | Aligned with Petfinder standard |
| story.coat | string \| null | "Short" \| "Medium" \| "Long" \| "Wire" \| "Hairless" \| "Curly" | Aligned with Petfinder standard |
| story.attributes | object | see below | Behavioral/health attributes |
| story.attributes.house_trained | boolean \| null | true/false/null | null = unknown |
| story.attributes.good_with_dogs | boolean \| null | true/false/null | |
| story.attributes.good_with_cats | boolean \| null | true/false/null | |
| story.attributes.good_with_children | boolean \| null | true/false/null | |
| story.attributes.special_needs | boolean \| null | true/false/null | |
| story.attributes.spayed_neutered | boolean \| null | true/false/null | |
| story.attributes.shots_current | boolean \| null | true/false/null | |

### new_content{}

New raw material submitted for building the next version. This is the caller's raw submission — processed by curation APIs before reaching /story/build.

| Field | Type | Valid Values | Notes |
|-------|------|-------------|-------|
| new_content.photo_urls[] | array of strings | valid URLs | Raw new photos — fed to /photos/curate first |
| new_content.video_url | string \| null | valid URL | Raw new footage — fed to /video/coach first |
| new_content.foster_notes | string \| null | any | Freeform foster observations |
| new_content.voice_note_url | string \| null | valid URL | Audio recording — fed to /voice/transcribe first |

### curated_content{}

Output of upstream curation APIs. Passed to /story/build — NOT submitted directly by users. See the curation pipeline in [FLOW.md](../FLOW.md) Step 3.

| Field | Type | Notes |
|-------|------|-------|
| curated_content.selected_photos[] | array of objects | Output from /photos/curate — best photos selected and ordered |
| curated_content.video_coverage{} | object | Output from /video/coach — what was confirmed captured |
| curated_content.coaching_context{} | object | Output from H-01 — confirmed content pieces, moments noted |
| curated_content.coaching_context.checklist_completed[] | array of strings | Content pieces confirmed captured |
| curated_content.coaching_context.moments_noted[] | array of strings | Specific moments flagged during capture |
| curated_content.coaching_context.shot_agenda_coverage | string | What was asked for vs. what was delivered |

### score_context{}

Passed downstream from /bcs/score to coaching and story APIs. Carries per-dimension gap detail so downstream APIs know exactly what to target.

| Field | Type | Notes |
|-------|------|-------|
| score_context.total_score | integer | 0–18 |
| score_context.grade | string | "D" \| "C" \| "B" \| "A" \| "A+" |
| score_context.dimensions[] | array of objects | Per-dimension scores (see Output Fields — /bcs/score) |
| score_context.priority_gaps[] | array of strings | Dimension IDs with lowest scores — sorted by impact |

### dog_info{}

Optional supplementary context accepted by most BCS APIs. Fields are passed through to output unchanged.

| Field | Type | Notes |
|-------|------|-------|
| dog_info.name | string | Dog's name |
| dog_info.breed | string | Breed description — freeform |
| dog_info.age | string | Age description — freeform |

### shot_agenda[]

Passed to /video/coach alongside footage. Defines what was asked for so the API can score coverage.

| Field | Type | Notes |
|-------|------|-------|
| shot_agenda[].id | string | Identifier for this shot (e.g. "fetch_drop", "eye_contact") |
| shot_agenda[].description | string | What to capture |
| shot_agenda[].priority | string | "high" \| "medium" \| "low" |

---

## Output Fields

Fields returned by BCS APIs.

### /bcs/score response

Scores a dog's current submission across 9 dimensions to produce a gap diagnostic — telling BCS where to focus coaching first.

| Field | Type | Valid Values | Notes |
|-------|------|-------------|-------|
| rubric_version | string | semver (e.g. "1.0.0") | Rubric version that produced this score — used for comparison across versions |
| total_score | integer | 0–18 | Sum of all dimension scores |
| max_score | integer | 18 | Always 18 |
| grade | string | "D" \| "C" \| "B" \| "A" \| "A+" | See [rubric.md](rubric.md) for grade scale |
| grade_label | string | e.g. "Needs Work", "Fair", "Good" | Human-readable grade label |
| dimensions[] | array | — | One entry per dimension |
| dimensions[].id | string | see [rubric.md](rubric.md) | Dimension identifier — use id not name |
| dimensions[].score | integer | 0–2 | Per-dimension score |
| dimensions[].max | integer | 2 | Always 2 |
| dimensions[].gap | string \| null | any | What's missing — null if score is 2 |
| priority_gaps[] | array of strings | dimension ids | Lowest-scoring dimensions, sorted by impact — consumed directly by /story/build and /photos/curate |
| coaching_summary | string | any | One plain-language sentence summarizing the overall gap and where to start |
| detected_boilerplate[] | array of objects | — | Non-story content found in the description — may be empty |
| detected_boilerplate[].type | string | "transport_info" \| "uw_rules" \| "apply_link" \| "org_blurb" \| "fta_offer" | Classification of the detected segment |
| detected_boilerplate[].excerpt | string | any | The detected boilerplate segment, as found in the description |
| review_required | boolean | always true | BCS never auto-publishes |

**The 9 dimension ids:**
`personality_hook` · `visual_impact` · `video_presence` · `compatibility_clarity` · `foster_voice` · `no_surprises` · `story_first_gate` · `presenter_readiness` · `family_vision`

### /story/build response

Produces the coached description, a coaching packet, and (when boilerplate is detected) reformatted logistics content — all from confirmed, curated material and the gap context from /bcs/score.

| Field | Type | Notes |
|-------|------|-------|
| coached_story | string | The improved description — always use this name, never coached_description |
| coaching_packet{} | object | Summary of what changed and what improved |
| coaching_packet.what_changed | string | Plain-language summary of what was done and why |
| coaching_packet.dimensions_improved[] | array of strings | Dimension ids that improved in this build |
| coaching_packet.estimated_score_delta | string | Estimated point improvement (e.g. "+8") |
| reformatted_boilerplate[] | array of objects | Cleaned non-story content, separated from the dog story |
| reformatted_boilerplate[].original | string | The original detected boilerplate |
| reformatted_boilerplate[].reformatted | string | Cleaned, consistently structured version |
| reformatted_boilerplate[].type | string | Same type enum as detected_boilerplate |
| review_required | boolean | Always true |

### /coaching/packet response (assembled packet)

The final assembled coaching packet — everything the frontend needs from a complete BCS pipeline run. Not a direct POST endpoint; assembled by BCS after orchestrating the full pipeline.

| Field | Type | Notes |
|-------|------|-------|
| dog_name | string | Dog's name |
| rescue_id | string | Rescue identifier — passed through unchanged |
| session_id | string | Session identifier — passed through unchanged |
| version | integer | Session version number (1, 2, 3…) |
| rubric_version | string | Rubric version used for scoring |
| score_before | integer | BCS score at session start |
| score_after | integer | BCS score after coaching |
| score_max | integer | Always 18 |
| coached_story | string | The improved description |
| photo_selection[] | array of strings | URLs of selected photos, in display order |
| shot_list[] | array of objects | Prioritized shot agenda |
| shot_list[].priority | integer | Display order (1 = highest priority) |
| shot_list[].description | string | What to capture — specific and actionable |
| shot_list[].why | string | Why this shot matters for this dog |
| video_coaching{} | object | Current video status and coaching |
| video_coaching.status | string | "pending" \| "captured" \| "complete" |
| video_coaching.prompt | string | What to capture next — specific to this dog |
| video_coaching.estimated_score_impact | string | Estimated score gain when captured (e.g. "+4") |
| next_steps[] | array of objects | Prioritized actions for the rescue team |
| next_steps[].priority | integer | Action order (1 = do first) |
| next_steps[].action | string | Specific action to take |
| next_steps[].impact | string | Estimated dimension impact (e.g. "+2 on visual_impact") |
| presenter_brief | string | The one-liner the presenter leads with — always |
| review_required | boolean | Always true |
| review_status | string | "pending_foster_approval" \| "approved" \| "tweaking" |
| dimensions_improved[] | array of strings | Dimension ids that improved this session |

### /story/format response

Reformats the approved coached story for a specific platform's character limits. Appends rescue-defined boilerplate templates when provided.

| Field | Type | Notes |
|-------|------|-------|
| formatted_output | string | coached_story + appended templates, within char limit |
| char_count | integer | Total character count of formatted_output |
| limit | integer | Character limit for the target platform |
| status | string | "within_limit" \| "at_limit" \| "over_limit" |
| story_budget | integer | Characters allocated to coached_story (platform_limit minus template_length) |
| templates_included[] | array of strings | Template ids that were appended |
| template_warning | string \| null | Present if templates leave < ~300 chars for the dog story — names the offending template |

### /voice/transcribe response

Converts a foster's voice note to text before scoring begins.

| Field | Type | Notes |
|-------|------|-------|
| transcript | string | Full transcribed text — merges into foster_notes in the session |

### /word/check response

Flags words that measurably affect adoption speed, based on a 70,733-dog study.

| Field | Type | Notes |
|-------|------|-------|
| flagged[] | array of objects | Words found from the study's list |
| flagged[].word | string | The flagged word or phrase |
| flagged[].reason | string | Why this word affects adoption speed |
| flagged[].suggested_replacement | string \| null | Suggested replacement if available |
| impact_score | number | Composite impact score — higher = more language affecting adoption speed |
| clean_version | string | Rewritten description with flagged language addressed |
| clean | boolean | true if no flagged words found |

### /photos/curate response

Selects and orders the strongest photos. The rejected list with reasons is itself coaching.

| Field | Type | Notes |
|-------|------|-------|
| selected[] | array of strings | URLs of selected photos |
| ordering[] | array of integers | Display order for selected photos (parallel array — index 0 of selected[] displays at ordering[] position) |
| photo_gaps[] | array of strings | Specific visual problems found in submitted photos |
| shot_list[] | array of objects | Targeted shot agenda aligned to the dog's story and gap context |
| shot_list[].priority | integer | Shot priority (1 = highest) |
| shot_list[].description | string | What to capture — specific and actionable |
| shot_list[].why | string | Why this shot matters for this dog |
| coaching_note | string \| null | Top-line coaching note for the session |
| rejected[] | array of objects | Photos not selected, with reason |
| rejected[].url | string | Photo URL |
| rejected[].reason | string | Why rejected — specific, actionable |

### /video/coach response

Reviews captured footage against the original shot agenda — scoring what landed and flagging what still needs to be reshot.

| Field | Type | Notes |
|-------|------|-------|
| what_landed[] | array of strings | Moments that worked — keep doing this |
| what_to_improve[] | array of strings | Specific, actionable improvements for next session |
| agenda_coverage[] | array of objects | Coverage status for each shot in the original shot_agenda |
| agenda_coverage[].id | string | Shot id from the original shot_agenda |
| agenda_coverage[].captured | boolean | Whether this shot was captured |
| agenda_coverage[].note | string \| null | Present when not captured — explains what happened and how to reshoot |
| next_session_priority | string | The single most important thing to capture next time |
| estimated_score_impact | string | Estimated score gain from completing missing shots |

### /video/clean-audio response

Cleans raw capture footage — removes direction talk, filler words, and background noise.

| Field | Type | Notes |
|-------|------|-------|
| clean_audio_url | string | Cleaned audio track |
| clean_video_url | string | Video with cleaned audio applied |
| edits_made[] | array of strings | Description of each edit applied |

### /story/represent response

Generates a fresh coaching brief for a dog who didn't place — building from what was tried and what signals came back.

| Field | Type | Notes |
|-------|------|-------|
| new_angle | string | What to try next, and why — specific to this dog and this market |
| what_was_tried[] | array of strings | Summary of prior session approaches |
| what_was_missing[] | array of strings | Gaps that prior sessions didn't close |
| try_this_next[] | array of strings | Specific, actionable coaching prompts for the next session |
| new_shot_agenda[] | array of objects | Updated shot list — same shape as shot_list[] — when visual assets need work |

---

## Shared / Cross-API Fields

| Field | Always present? | Notes |
|-------|----------------|-------|
| review_required | Yes — all story output | Always true. BCS never auto-publishes. |
| platform | Input only | "petfinder" \| "adoptapet" \| "rescuegroups" \| "shelterluv" \| "other" |
| dog_id | Optional | Implementor-defined identifier for the dog — passed through unchanged |
| session_id | Optional | Implementor-defined session identifier — passed through unchanged |
| rescue_id | Optional | Implementor-defined rescue identifier — passed through unchanged |
| rubric_version | Output — /bcs/score and coaching packet | Semver string — pin to compare scores across rubric versions |

---

## Canonical Names — Do Not Alias

These names are locked. Using any other name is a spec violation:

| Canonical name | Do NOT use |
|---------------|-----------|
| coached_story | coached_description, new_story, improved_story |
| total_score | score, total, bcs_score |
| grade | letter_grade, score_grade |
| dimensions[] | scores[], categories[], rubric_scores[] |
| dimensions[].id | name, label, dimension_name |
| priority_gaps[] | gaps[], weak_spots[], low_scores[] |
| detected_boilerplate[] | boilerplate[], non_story[], logistics[] |
| detected_boilerplate[].excerpt | text, segment, content |
| reformatted_boilerplate[] | cleaned_boilerplate[], formatted_boilerplate[] |
| coaching_summary | summary, coaching_note, summary_note |
| review_required | needs_review, pending_review, auto_publish |
| curated_content{} | new_content (in /story/build context), processed_content |
| story{} | input{}, profile{}, listing{} |

---

## Platform Alignment Notes

BCS field names align with Petfinder v2 and RescueGroups v5 where practical:

| BCS field | Petfinder v2 | RescueGroups v5 | Notes |
|-----------|-------------|----------------|-------|
| story.text | description | animals.descriptionText | BCS uses `story.text` to distinguish input from the coached output |
| story.age | age (Baby/Young/Adult/Senior) | animals.age | Same values |
| story.gender | gender (Male/Female/Unknown) | animals.sex | BCS uses `gender` to align with Petfinder |
| story.size | size (Small/Medium/Large/XL) | animals.size | Same values |
| story.coat | coat (Short/Medium/Long/Wire/Hairless/Curly) | — | Petfinder standard |
| story.attributes.house_trained | attributes.house_trained | animals.isHouseTrained | BCS uses snake_case |
| story.attributes.good_with_dogs | environment.dogs | animals.isGoodWithDogs | BCS uses attributes namespace |
| story.attributes.good_with_cats | environment.cats | animals.isGoodWithCats | |
| story.attributes.good_with_children | environment.children | animals.isGoodWithKids | |
| story.attributes.special_needs | attributes.special_needs | animals.hasSpecialNeeds | |
| story.photo_urls[] | photos[] | animals.photos | BCS accepts URLs, not upload objects |
| story.video_url | videos[] | animals.videos | BCS accepts a single URL |

---

## References

- Full rubric and dimension ids: [docs/rubric.md](rubric.md)
- Platform hints schema: [docs/platform-hints-schema.md](platform-hints-schema.md)
- How BCS gets smarter: [docs/intelligence.md](intelligence.md)
- Annotated example flows: [FLOW.md](../FLOW.md)
