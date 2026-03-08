# Security Architecture — Best Chance Studio

*Last updated: March 7, 2026*
*Status: Foundation established. Key assumptions resolved — see questions-architect.md.*

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
| **Spoofing** | Low — single user, no auth | Medium — rescue identity, foster identity, distinct roles (Q-P3) | [ ] TBD |
| **Tampering** | Low — local data only | Medium — session history, scores could be modified | [ ] TBD |
| **Repudiation** | Low — no audit requirement | Medium — who approved which story? | [ ] TBD |
| **Information Disclosure** | Medium — API keys in browser | Medium — PII in transit, stored sessions | [ ] TBD |
| **Denial of Service** | Low — local only | Medium — AI API rate limits, cost attacks | [ ] TBD |
| **Elevation of Privilege** | Low | Medium — rescue A accessing rescue B's data, foster vs coordinator role escalation | [ ] TBD |

---

## 2. PII Inventory

### Personal Data in the System

| Data | Where It Appears | Classification | Offline? |
|------|------------------|---------------|----------|
| Dog name | Everywhere | **Not PII** (Q-X2) | Yes |
| Dog photos/videos | Media pipeline | Medium — may contain humans. BCS is source of record (Q-D3). Photographer retains rights, BCS license via ToS (Q-L1). | Yes |
| Foster name | Coaching packet, presenter brief | **PII — standard protections** (Q-X2). Stripped from published inventory by default. | Yes |
| Foster voice notes | Transcription pipeline | Medium — biometric adjacent | Yes |
| Rescue name + location | Rescue registration, exports | Low-Medium | Yes |
| Rescue coordinator contact | Registration | Medium — PII | No |
| Adopter signals (near-miss) | Platform hints, session history | Medium — behavioral data | Platform only |
| YouTube OAuth tokens | Credential storage | High — access tokens | No |

### Data Flow Concerns
- Foster voice notes contain biometric-adjacent data (voice recordings). These should be transcribed and the audio discarded unless explicitly retained.
- Photos may contain identifiable humans (foster families, children). No face detection or PII extraction should occur.
- Near-miss signals from platforms may contain adopter behavioral data. BCS tools should treat these as opaque signals — no attempt to identify individual adopters.
- **AI-generated content must be labeled as AI-assisted** (Q-L2). Coaching packets and exported descriptions carry disclosure.

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

### Resolved (Q-D3, Q-L1)
- **Storage**: BCS is the source of record for media. Durable object storage required.
- **Ownership**: Photographer retains rights. BCS usage license granted via terms of service.
- **Access control**: Per-rescue. Multi-rescue instances (Q-X1) require rescue-scoped media access.

### Remaining Concerns
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

### Auth Model (Resolved — Q-X1, Q-P2, Q-P3)

Multi-rescue support required (Q-X1). Self-serve registration (Q-P2). Distinct foster vs coordinator roles with different permissions (Q-P3).

| Mode | Auth Approach |
|------|--------------|
| Standalone (offline tools) | No auth — G-series tools are stateless, no rescue context |
| Hosted | Self-serve registration, OAuth or token-based auth, rescue-scoped data |
| Multi-rescue hosted | Role-based access control (foster vs coordinator), rescue-scoped data isolation |
| Platform-connected | Platform handles auth, passes rescue context to BCS |

### Role-Based Access Control (Q-P3)
| Role | Can Do | Cannot Do |
|------|--------|-----------|
| **Foster** | Submit content, approve stories, view own dogs | View other rescues' data, manage rescue settings |
| **Coordinator** | Everything foster can + review all dogs, manage presenters, trigger re-presentation | Access other rescues' data |

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

### Standalone API Key Management (Resolved — DEC-005)
Stakeholder added `docs/ai-credentials.md` which resolves this:

- **Standalone tools:** BYOK (Bring Your Own Key). Provider selection, key entry, validation. Setup in under 3 minutes.
- **Platform implementations:** Credentials managed server-side.
- **Contributors:** Ollama for zero-cost local development.

Every BCS implementation that uses AI-powered APIs must provide a setup flow that collects valid AI provider credentials before any AI feature is invoked. Keys are stored securely per the credential spec. Graceful failure when credentials are missing or invalid.
