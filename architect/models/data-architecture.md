# Data Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Foundation established. Key assumptions resolved — see questions-architect.md.*

---

## 1. Entity Model

### Core Entities

| Entity | Description | Key Attributes | Source |
|--------|-------------|----------------|--------|
| **Dog** | The animal being coached for adoption | name, breed, age, energy, rescue_id, foster_notes, voice_notes | Intake submission |
| **Rescue** | Organization managing the dog | rescue_id, name, location, credentials | Registration |
| **Session** | One coaching run through the BCS pipeline | session_id, dog ref, version, status, timestamps | Orchestrator |
| **Score** | Diagnostic output from `/bcs/score` | rubric_version, total_score, max_score, dimensions[], priority_gaps[] | `stubs/bcs-score.json` |
| **CoachingPacket** | Assembled output — the north star | All fields in `stubs/coaching-packet.json` | Pipeline assembly |
| **Media** | Photos, videos, voice notes, produced reels | type, filename/url, metadata, processing_status | Foster submission + pipeline |
| **ShotAgenda** | Targeted photo/video capture plan | items[], priority, coverage_status | `/photos/curate`, `/video/coach` |
| **StoryVersion** | Versioned coached description | text, version, refine_count, review_status | `/story/build`, `/story/refine` |

### Relationships

```
Rescue ──1:N──→ Dog
Dog    ──1:N──→ Session
Session ──1:1──→ Score (before)
Session ──1:1──→ Score (after)
Session ──1:N──→ StoryVersion
Session ──1:1──→ CoachingPacket
Session ──1:N──→ Media
Session ──1:1──→ ShotAgenda
Dog    ──1:1──→ PublishedInventoryEntry (when approved + published)
```

### Resolved Questions
- **Dog identity across rescues** — See `DEC-003-dog-identity.md`. Rescue-scoped by default with optional linking.
- **Foster as entity** — Yes. Per Q-P3, fosters and coordinators are distinct user roles with different permissions. Foster is a first-class entity with identity and role-based access.

### Updated Entity: Foster

| Entity | Description | Key Attributes | Source |
|--------|-------------|----------------|--------|
| **Foster** | Person caring for the dog and submitting content | foster_id, name (PII), rescue_id, role | Registration |

### Updated Relationships
```
Rescue ──1:N──→ Foster
Foster ──1:N──→ Dog (fostering)
```

Per Q-X2: Foster names are PII with standard protections. Dog names are not PII. Published dog inventory strips foster identity by default.

---

## 2. Session Lifecycle (State Machine)

```
intake → scored → coached → pending_review → approved → published
                    ↑            │                         │
                    └── tweak ───┘                         │
                                                           ↓
                                                    re-presented → coached (v2) → ...
```

Key states from the stubs and FLOW.md:
- **intake**: Raw submission received (text, photos, voice notes)
- **scored**: `/bcs/score` complete — gap diagnostic available
- **coached**: `/story/build` + `/photos/curate` complete — coaching packet assembled
- **pending_review**: `review_required: true`, `review_status: "pending_foster_approval"`
- **approved**: Foster accepted the coached description
- **published**: Exported to platforms, logged in published dog inventory
- **re-presented**: `/story/represent` triggered — new session version created with prior history

### State Transition Rules
- `scored → coached` requires at least one API call that produces coaching output
- `coached → approved` requires explicit foster action (never auto-approved)
- `approved → published` may be automatic or manual depending on platform integration
- Any state can transition to `re-presented` when the dog doesn't place

---

## 3. Versioning Strategy

From FLOW.md: "Every coaching session is v1. When new photos come in, that's v2. When the video lands, v3."

### What Gets Versioned
- **CoachingPacket**: `version` field increments per session. Prior versions retained.
- **StoryVersion**: `refine_count` tracks within-session refinements. Each session resets.
- **Score**: Before/after per session. Tied to `rubric_version`.
- **rubric-config.json**: Semantic versioned (`1.0.0`). Scores reference which rubric produced them.

### History Contract (Resolved — Q-D1)
`/story/represent` has access to **all** prior sessions for a dog. No compression, no truncation. Storage must accommodate unbounded session history per dog.

Required access:
- All prior session versions for a dog
- Coaching tips tried per session
- Near-miss signals (platform-supplied or manually entered)
- What changed between versions

---

## 4. Storage Strategy

*DEC-002 partially resolved: LocalStorage for v1 prototype (per P-02 spec). Long-term strategy (IndexedDB + file export) recommended but awaiting stakeholder decision.*

### Data Categories

| Category | Examples | Sensitivity | Offline Requirement |
|----------|----------|-------------|---------------------|
| **Config** | rubric-config.json, platform-hints-schema | Public | Must work offline |
| **Session state** | Current coaching session, draft story | Per-rescue | Must work offline |
| **Session history** | Prior versions, scores, near-miss signals | Per-rescue | Should work offline |
| **Media (raw)** | Submitted photos, voice notes, raw video | Per-rescue | Must reference offline |
| **Media (produced)** | Reels, thumbnails, story cards | Per-rescue | May require connectivity |
| **Published inventory** | Final coached dogs, published stories | Semi-public | Requires persistence |
| **Platform hints** | Learned patterns, outcome data | Per-platform | Requires connectivity |

### Storage Location Options
See `DEC-002-standalone-persistence.md` for the full analysis.

### Media Storage (Resolved — Q-D3)
BCS is the source of record for media. Rescues may keep copies, but BCS's system is the canonical store. This means:
- Media entity model uses URLs, not just filenames
- BCS needs durable object storage (or equivalent)
- Access control is per-rescue (Q-X1: multi-rescue instances supported)
- Photographer retains rights; BCS usage license granted via terms of service (Q-L1)

---

## 5. Published Dog Inventory

From FLOW.md: "Every dog that completes the BCS process and gets published must be logged — dog profile, final coached story, final BCS score, and publish date."

### Minimum Schema
```json
{
  "dog_id": "moose-blues-city-001",
  "dog_name": "Moose",
  "rescue_id": "blues-city-memphis",
  "final_score": 15,
  "rubric_version": "1.0.0",
  "coached_description": "...",
  "photo_urls": ["..."],
  "video_url": "...",
  "publish_date": "2026-03-07",
  "session_count": 3,
  "outcome": null
}
```

### Scope (Resolved — Q-D2)
Only **approved + published** dogs enter the inventory. Coached-but-unapproved sessions remain in session history but do not graduate to the published inventory.

### Remaining Questions
- Does `outcome` (adopted, returned, transferred, euthanized) belong here? See `questions-stakeholder.md` Q-O2.
- Per-rescue by default (DEC-003 recommendation). Cross-rescue merging via optional linking.
