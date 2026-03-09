# How BCS Gets Smarter

*Last updated: March 9, 2026*

BCS APIs are stateless — each call is independent. The system gets smarter through the platform layer, not within individual API calls.

---

## The Learning Loop

1. BCS produces a coaching packet and coached story for a dog
2. The dog gets adopted — or doesn't
3. The platform logs the outcome alongside what was tried (story angle, coaching focus, behavior framing)
4. Over time, patterns emerge: which approaches work for which types of dogs
5. The platform passes that intelligence back into future sessions via `platform_hints{}`

---

## platform_hints{} — The Return Channel

`platform_hints{}` is how accumulated platform learning flows back into individual BCS sessions:

```json
{
  "platform_hints": {
    "similar_dog_patterns": {},      // what worked for dogs with similar profile/gaps
    "adopter_signals": {},           // what questions adopters typically ask for this type
    "failed_adoption_learnings": [], // concerns that came up in failed adoptions for similar dogs
    "top_performer_framing": {},     // story angle that drove fastest placement for similar dogs
    "concern_mitigation": {}         // known concerns for this profile + what addressed them
  }
}
```

BCS defines the interface. The platform builds the intelligence layer that populates it. A standalone BCS implementation omits `platform_hints{}` — coaching is still effective, just without accumulated learning.

The full `platform_hints{}` schema — all fields, which APIs consume which groups, fallback behavior — is documented in [`docs/platform-hints-schema.md`](platform-hints-schema.md).

---

## Better Profiles → Better Matching

As BCS profiles improve and outcome data accumulates, adopter-dog matching improves downstream. Matching is a platform-layer feature — BCS provides the profile quality and outcome data that makes it possible.

---

## What BCS Does Not Own

- Outcome storage — implementor responsibility
- Pattern analysis — platform responsibility
- Match scoring — platform responsibility

BCS owns the spec. Platforms own the learning.

---

## Standalone vs. Platform-Connected

A standalone BCS implementation works without `platform_hints{}`. Coaching is effective — based on the rubric, the gap analysis, and the session inputs. It just doesn't have accumulated outcome data informing it.

A platform-connected implementation populates `platform_hints{}` from real adoption outcomes: what story angles converted, what adopter questions predicted a near-miss, what framing worked for dogs with this profile in this geography. That learning flows back into every coaching call automatically.

The API is identical in both cases. The difference is what the platform passes in.
