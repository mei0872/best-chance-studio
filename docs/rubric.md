# BCS Scoring Rubric

*Last updated: March 9, 2026*

The BCS score rates a dog's current published presentation on 9 dimensions, from 0–2 each (total: 0–18).
This page is the human-readable companion to the `/bcs/score` API. Use it when implementing the scoring logic.

---

## Grade Scale

| Score | Grade | What it means |
|-------|-------|---------------|
| 0–4   | D     | Critical gaps — most adopters will scroll past |
| 5–7   | C     | Below average — some engagement, significant room to improve |
| 8–11  | B     | Solid — competitive listing, good engagement expected |
| 12–15 | A     | Strong — stands out, high adoption potential |
| 16–18 | A+    | Exceptional — this dog's story is doing everything right |

---

## The 9 Dimensions

### Personality Hook

**What it measures:** Does the adopter know who this dog IS — not just breed and age, but personality? Is there one specific moment or detail that makes this dog stick in someone's mind?

**Score 0:** Age, breed, sex. That's it. Could describe any dog of this type. Nothing sticks.

**Score 1:** Some warmth, but generic. A detail is present but it could describe many dogs of this breed — not only this one.

**Score 2:** Specific, memorable, only-this-dog detail. A moment, a behavior, a quirk the foster witnessed firsthand. Makes you feel something.

**Common gap:** The detail exists in the foster's head but never makes it to the description. The best coaching question: *"What does this dog do every single morning?"*

---

### Visual Impact — Photos

**What it measures:** Do the photos make someone stop scrolling? Dog's face visible? Real light, real expression, real life?

**Score 0:** Single shot, blurry, kennel background, dog facing away. No eye contact, no personality visible.

**Score 1:** 1–2 photos, decent quality, but limited angles or expression. Passable but not compelling.

**Score 2:** 3+ photos: face-on with eye contact, full body, in motion or with a human. Natural light. Personality is visible.

**Common gap:** Kennel photos taken under fluorescent light with the dog looking away. The foster had more to offer but submitted whatever was on their phone.

---

### Video Presence

**What it measures:** Does a video exist? Does it make you feel something in the first 10 seconds?

**Score 0:** No video. The adopter has no way to see this dog in motion before requesting a meet.

**Score 1:** Video exists but opens on a wall, or is low-energy, or too long with no hook. The dog is technically visible but the video doesn't pull you in.

**Score 2:** Video exists, dog's personality is visible in the first 10 seconds, authentic and not staged, emotionally engaging.

**Common gap:** No video at all. Most rescue dogs are presented without one. A 60-second authentic clip of the dog doing their signature thing is worth more than any description.

---

### Compatibility Clarity

**What it measures:** Can the right adopter self-identify immediately? And the wrong adopter self-select out? Kids, other dogs, cats, energy level, home type — stated clearly.

**Score 0:** Nothing stated about compatibility or household requirements. The adopter has to guess whether this dog fits their life.

**Score 1:** Some compatibility noted, but incomplete or vague. "Good with kids" with no context on what "good" looks like, or missing key requirements like energy level or home type.

**Score 2:** Clear, specific, complete. The right adopter knows immediately. The wrong adopter knows too — and that's a feature, not a flaw.

**Common gap:** "Good with kids and other dogs" with no information on energy level, home type, or what the dog actually needs. A wrong adopter who self-selects out saves everyone time and prevents a returned dog.

---

### Foster Voice

**What it measures:** Does this listing feel like a real person who knows and loves this dog — or does it feel like a form was filled out?

**Score 0:** Clinical, factual, vet-record language. No human warmth. "He is up to date on vaccines and house trained."

**Score 1:** Some personality in the writing, but still leans generic or template-like. You can tell someone tried, but it could still be about any dog.

**Score 2:** Personal, warm, specific details only the foster would know. You can feel the relationship between this person and this dog.

**Common gap:** Template language copy-pasted from a previous dog's listing, lightly edited. Reads like a brochure. The test: read it out loud — if it sounds like a brochure, it isn't done.

---

### No Surprises

**What it measures:** Are any challenges or special needs communicated clearly — without being scary or unnecessarily disqualifying?

**Score 0:** Challenges omitted entirely (adopter discovers them after placement, leading to returns) — OR framed so negatively the dog sounds unadoptable before anyone meets them.

**Score 1:** Challenges are mentioned but framed in a way that sounds worse than it is, or buried so deep in the description that an adopter might miss them.

**Score 2:** Any challenges are stated specifically and reframed positively. The right home recognizes themselves. The wrong home knows to look elsewhere.

**Common gap:** Omitting challenges entirely to avoid scaring off adopters. This leads to failed placements, returned dogs, and fosters who stop trusting the process. The fix: reframe, don't hide. "Only dog" is not a flaw — it's a match requirement.

---

### Story-First Gate

**What it measures:** Is a coached intro video ready? Can someone feel this dog before they ever request a live meet?

**Score 0:** No intro video. Adopters arrive cold — they have never seen this dog in motion before the first live meet.

**Score 1:** Some intro video exists but uncoached, low energy, or too long without a hook. Better than nothing, but not doing the work it should.

**Score 2:** Short, coached, warm intro video ready — dog's personality is visible in under 60 seconds. The adopter feels this dog before they walk in the door.

**Common gap:** No intro video means the live meet is the first impression. Everything depends on one interaction with no setup. A 60-second authentic video changes that completely.

---

### Presenter Readiness

**What it measures:** Does the presenter know this dog? Have they read the coaching packet? Do they know the strongest asset and the likely questions?

**Score 0:** Presenter is meeting this dog for the first time during the live meet. No coaching, no preparation, no strongest moment identified.

**Score 1:** Presenter knows the basics but is likely to read from the bio or get caught off guard by compatibility questions.

**Score 2:** Presenter can speak to specific moments, addresses compatibility questions naturally, and knows what to lead with before the adopter asks.

**Common gap:** The coaching packet exists but the presenter reads it for the first time during the live meet. The packet is only useful if the presenter reads it beforehand and internalizes the opening line.

---

### Family Vision

**What it measures:** After seeing this listing — photos, video, description — can the adopter picture this dog in their life? Not "this seems like a nice dog" but "that's my dog."

**Score 0:** Listing is invisible. No image forms. No feeling. You read it and feel nothing.

**Score 1:** Listing is warm but stays abstract. Describes the dog without making you feel the dog. You understand what the dog is like; you can't picture it in your life.

**Score 2:** Listing creates a picture. You can see the dog at the end of your bed, in your car, on your couch. The scene is specific enough to be real.

**Common gap:** Descriptions that tell instead of show. The dog is described but never pictured. The fix: close with a scene — the dog in the adopter's specific life, not a generic "forever home."

---

## How BCS Uses the Rubric

- `/bcs/score` returns a score per dimension + overall grade
- `/coaching/packet` uses the gaps to generate improvement coaching
- `/story/build` uses priority gaps to guide story reconstruction
- The rubric is versioned — see Discussion #20 for the rubric versioning policy

---

## Notes for Implementors

- Score the *current published presentation* — what adopters see right now
- Do not score intent or potential — only what is actually visible
- Photos and video: accept URLs for direct analysis, not pre-computed counts
- `review_required: true` on all outputs — nothing auto-publishes
- Dimension weights are configurable via `rubric-config.json` — do not hardcode them in scoring logic
- The rubric config is the single source of truth; when weights change, only the config changes — no API contract changes
