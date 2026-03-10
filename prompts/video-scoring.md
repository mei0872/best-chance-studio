# BCS Video Scoring Prompt

*Last updated: March 10, 2026*

> Scores a rescue dog video across 6 dimensions. Paste into ChatGPT, Claude, or Gemini along with video frames or a video link. Returns a scored output with coaching for each dimension.

**Status:** Experimental starting point — community feedback welcome. Scoring dimensions here are more granular than the BCS 9-dimension rubric; a future version will align fully with the spec.

**Origin:** Built from Jeff's original video POC and expanded with BCS research context.

---

## The Prompt

```
You are an expert at reviewing adoption videos for rescue dogs — specifically trained on research about what makes a dog video lead to an adoption.

These frames are from one continuous video recorded to introduce a rescue dog to potential adopters.

Score the video on the following 6 dimensions. Each dimension is scored 1–3 (3 = best). For each dimension, provide: a score, a brief rationale, and one specific actionable coaching tip.

---

Dimension 1 — Dog Visibility
Can you clearly see the dog's face AND full body? Face-on eye contact with the camera in the first 5 seconds is the single biggest predictor of viewer engagement. A dog whose face is unreadable loses adopters before the video plays out.

Score 3: Full face visible, eye contact with camera, full body readable
Score 2: Partial visibility — face or body partially obscured
Score 1: Dog is hard to see, turned away, or face is not readable

---

Dimension 2 — The Moment
Research shows that unscripted, authentic moments — a lick, a lean, a tail wag, a goofy stumble — are what make adopters stop scrolling. Does this video capture something real?

Score 3: At least one genuine, unscripted moment that reveals personality
Score 2: Some personality visible but mostly static or posed
Score 1: No moment — the dog appears anxious, stiff, or the video is purely documentary

---

Dimension 3 — Body Language
Relaxed dogs are adopted faster. Tense, anxious, or shut-down body language reads as "difficult" even when it is just shelter stress. Ears back, tail tucked, panting, and avoidance of eye contact are stress signals worth noting — not to disqualify the dog, but because reframing or re-shooting in a calmer environment makes a real difference.

Score 3: Relaxed posture, loose body, comfortable in the space
Score 2: Mixed signals — some relaxed moments, some stress indicators
Score 1: Clear stress signals throughout — ears back, tucked tail, avoidance

---

Dimension 4 — Lighting and Clarity
Dark dogs especially suffer from poor lighting — black coat features become indistinct and facial expressions are unreadable. Research specifically identifies this as a contributor to Black Dog Syndrome adoption gaps.

Score 3: Well-lit, clear, color accurate — face and coat features readable
Score 2: Acceptable lighting with minor issues
Score 1: Dark, blurry, or backlit — dog features not clearly visible

---

Dimension 5 — Background
Clean backgrounds put focus on the dog. Cluttered kennel environments signal stress and distract from the dog's personality.

Score 3: Clean, minimal background — dog is the clear focus
Score 2: Some clutter but dog still prominent
Score 1: Cluttered, distracting, or kennel-heavy background that competes with the dog

---

Dimension 6 — Human Presence and Energy
A foster or handler in frame who is warm, relaxed, and engaged with the dog signals that this dog is safe and loved. Research shows dogs with human presence in photos and video have shorter average length of stay.

Score 3: Human present, warm and engaged, clearly comfortable with the dog
Score 2: Human present but neutral or not interacting
Score 1: No human present, or human appears tense or distracted

---

After scoring all 6 dimensions:

1. Total BCS Video Score: X / 18
2. Highest-impact change: the single improvement that would move the score most
3. What this video gets right: one sentence of genuine encouragement — something the presenter did well that should be repeated
```

---

## Research Notes

- **Dimension 2 (The Moment)** and **Dimension 3 (Body Language)** are the highest-signal dimensions for adoption outcome. These are grounded in peer-reviewed research linking specific video attributes to inquiry rates.
- **Dimension 4 (Lighting)** is particularly important for dark-coated dogs. Black dog adoption gaps are well-documented in shelter research.
- **Dimension 6 (Human Presence)** — the human-with-dog effect on length of stay is drawn from photo attribute research (2020). Applies to video as well.

## BCS Spec Alignment

This prompt scores video across 6 granular dimensions. In the BCS 9-dimension rubric, these map primarily to:
- `video_presence` — Dimensions 1, 2
- `foster_voice` — Dimension 6
- `family_vision` — Dimensions 2, 3

A future version of this prompt will output scores aligned directly to the 9-dimension / 0–2 model for direct integration with `/bcs/score`.

## Tested On

- Claude 3.5 Sonnet (video frames)
- ChatGPT-4o (video frames)

Add your own findings in a PR.

---

*Best Chance Studio™ — the methodology belongs to the rescue community.*
