# Security Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Section headers and key concerns established. Detail to be filled as Phase 1 tasks complete.*

---

## 1. Threat Model

### System Modes

BCS operates in two distinct modes with different threat profiles:

| Mode | Description | Trust Boundary |
|------|-------------|---------------|
| **Standalone** | Static files, no backend, local storage | Browser sandbox only |
| **Platform-connected** | Backend proxy, platform_hints, outcome data | Backend + platform API |

### STRIDE Analysis (To Be Completed)

| Threat | Standalone Risk | Platform Risk | Mitigation |
|--------|----------------|---------------|------------|
| **Spoofing** | Low — single user, no auth | Medium — rescue identity, foster identity | [ ] TBD |
| **Tampering** | Low — local data only | Medium — session history, scores could be modified | [ ] TBD |
| **Repudiation** | Low — no audit requirement | Medium — who approved which story? | [ ] TBD |
| **Information Disclosure** | Medium — API keys in browser | Medium — PII in transit, stored sessions | [ ] TBD |
| **Denial of Service** | Low — local only | Medium — AI API rate limits, cost attacks | [ ] TBD |
| **Elevation of Privilege** | Low | Medium — rescue A accessing rescue B's data | [ ] TBD |

---

## 2. PII Inventory

### Personal Data in the System

| Data | Where It Appears | Classification | Offline? |
|------|------------------|---------------|----------|
| Dog name | Everywhere | Low sensitivity | Yes |
| Dog photos/videos | Media pipeline | Medium — may contain humans | Yes |
| Foster name | Coaching packet, presenter brief | Medium — PII | Yes |
| Foster voice notes | Transcription pipeline | Medium — biometric adjacent | Yes |
| Rescue name + location | Rescue registration, exports | Low-Medium | Yes |
| Rescue coordinator contact | Registration | Medium — PII | No |
| Adopter signals (near-miss) | Platform hints, session history | Medium — behavioral data | Platform only |
| YouTube OAuth tokens | Credential storage | High — access tokens | No |

### Data Flow Concerns
- Foster voice notes contain biometric-adjacent data (voice recordings). These should be transcribed and the audio discarded unless explicitly retained.
- Photos may contain identifiable humans (foster families, children). No face detection or PII extraction should occur.
- Near-miss signals from platforms may contain adopter behavioral data. BCS tools should treat these as opaque signals — no attempt to identify individual adopters.

---

## 3. Media Security

### Photo/Video Lifecycle

```
Foster captures → submitted to BCS → processed (curate/coach/produce) → exported → published
                                          │
                                          ▼
                                   intermediate files (.tmp/)
                                   (disposable, never retained)
```

### Concerns
- **Storage**: Where do raw and processed media files live? (See Q-D3 in questions-architect.md)
- **Access control**: Who can view a dog's media? Only the submitting rescue? Any BCS user?
- **Retention**: How long are raw submissions kept after the dog is adopted?
- **Produced reels**: Once exported to YouTube, is the local copy retained?
- **Thumbnails/cards**: Generated images may be shared publicly — ensure no embedded metadata (EXIF stripping)

---

## 4. Auth Boundaries

### What's Public
- `rubric-config.json` — open source, community-owned
- `platform-hints-schema.md` — open source schema definition
- Published dog inventory entries (once exported to public platforms)

### What's Per-Rescue
- Active sessions and coaching history
- Raw media submissions
- Foster notes and voice transcripts
- Presenter briefs and coaching packets

### What's Per-Platform
- `platform_hints` learned data (outcome patterns, near-miss signals)
- Adopter behavioral data
- YouTube OAuth credentials per rescue

### Auth Model Options
*Depends on DEC-004 (orchestration location) and Q-X1 (rescue isolation).*

| Mode | Auth Approach |
|------|--------------|
| Standalone single-rescue | None — trust the browser user |
| Standalone multi-rescue | Client-side rescue selection (no real security) |
| Hosted single-rescue | API key or simple password |
| Hosted multi-rescue | OAuth or token-based auth, rescue-scoped data |
| Platform-connected | Platform handles auth, passes rescue context to BCS |

---

## 5. platform_hints Trust Boundary

`platform_hints` is an input from an external system. It must be treated as untrusted data.

### Validation Rules
- **Schema validation**: Hints must conform to documented field groups. Unknown fields are ignored (not executed).
- **No code execution**: Hints are data (strings, numbers, arrays). Never evaluate hint values as code.
- **Bounded values**: Enum fields (`opening_style`, `tone`, `energy_match`) must be validated against allowed values. Reject unknowns gracefully.
- **Size limits**: `near_miss_signals` array should be bounded (e.g., max 50 items). `keywords_avoid` / `keywords_prefer` bounded similarly.
- **No credential forwarding**: platform_hints must never contain or request API keys, tokens, or credentials.

### What a Malicious Platform Could Attempt
- Inject prompt-injection strings via `learned.top_performer_pattern` or `near_miss_signals`
- Inflate `dog_context.escalation_risk` to manipulate coaching urgency
- Pass excessively large hint objects to cause memory issues
- Include tracking identifiers in hint fields

### Mitigation
- Sanitize all string fields before passing to LLM prompts
- Validate enum values against allowlists
- Enforce size limits on arrays and string lengths
- Log hint sources for audit (in platform-connected mode)

---

## 6. Supply Chain

### External Dependencies (Current)
- **LLM provider(s)**: API keys for story generation, photo analysis, video coaching
- **Speech-to-text**: Whisper API or equivalent for voice transcription
- **YouTube API**: OAuth credentials for video export
- **CDN/hosting**: If hosted, whatever serves the static files

### Credential Management
| Credential | Storage | Rotation |
|-----------|---------|----------|
| LLM API key | `.env` (server-side) or browser (standalone — risky) | Manual |
| YouTube OAuth | `token.json` per rescue | Auto-refresh via OAuth flow |
| Platform API key | Backend config (platform-connected mode) | Platform-managed |

### Key Concern: Standalone API Key Exposure
In standalone mode, if AI features require API keys, those keys are exposed in the browser. Options:
1. **No AI in standalone** — rule-based scoring only (aligns with DEC-001 Option A)
2. **User provides own key** — foster/rescue enters their API key (UX burden, security risk)
3. **Proxy service** — lightweight backend that holds keys (no longer truly standalone)
4. **Rate-limited public key** — BCS provides a key with strict per-session rate limits (cost risk)

This is a fundamental tension. See DEC-001 and DEC-004.
