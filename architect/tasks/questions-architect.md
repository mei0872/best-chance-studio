# Architect's Questions — Resolved

*All questions resolved with working assumptions on March 7, 2026. These are assumptions, not final decisions — we can pivot if any change, but they unblock architecture work now.*

---

## Data Architecture

### Q-D1: Session history depth — RESOLVED
**Assumption:** All prior sessions are available to `/story/represent`. No compression, no truncation.

**Implication:** Storage must accommodate unbounded session history per dog. May need indexing for performance as history grows.

### Q-D2: Published dog inventory scope — RESOLVED
**Assumption:** Only approved + published dogs enter the inventory. Coached-but-unapproved sessions are retained in session history but not in the published inventory.

**Implication:** The session state machine has a clear terminal gate: `approved → published → inventory`. Unapproved sessions stay in session storage but don't graduate.

### Q-D3: Media storage ownership — RESOLVED
**Assumption:** BCS is the source of record for media. Rescues may keep copies, but BCS's system is the canonical store.

**Implication:** BCS needs a durable media storage layer (object storage or equivalent). Media entity model needs URLs, not just filenames. Backup and retention policies required. Security model must protect media access per-rescue.

---

## Technical Architecture

### Q-T1: Target environments — RESOLVED
**Assumption:** All of the above — static site, hosted service, downloadable tool. The solution must be something anyone can run.

**Implication:** Architecture must support multiple deployment modes without code changes. Configuration-driven deployment. Docker/container packaging for hosted mode, static file export for self-host, downloadable package for local.

### Q-T2: AI provider assumption — RESOLVED
**Assumption:** OpenAI, Claude, or local models are all likely. Provider abstraction is required from day 1.

**Implication:** Confirms DEC-005 recommendation (Option B). Build the `AICapability` abstraction interface with adapters for cloud providers and local models (Ollama). Prompts stored as templates, adapter handles model-specific formatting.

### Q-T3: Video processing location — RESOLVED
**Assumption:** Server-side by default. Client-side as an option for users with sufficient local hardware. BCS should offer server-side post-processing for those who need it.

**Implication:** Video pipeline (H-03, H-04) must support both execution environments. Server-side is the primary path. Confirms DEC-006 — video production is firmly "online required" with an optional local processing mode.

---

## Software Architecture

### Q-S1: Orchestration engine ownership — RESOLVED
**Assumption:** A separate backend service (single coordinator module) owns the full pipeline orchestration. Client-side tools (G-01, P-01, P-02) remain standalone for offline use and don't go through the orchestrator. When online, P-02 calls the orchestrator rather than calling individual APIs directly.

**Implication:** Confirms DEC-004 isomorphic model. The orchestrator is a server-side service that sequences API calls, threads context, handles partial failures, and assembles the coaching packet. Client-side tools are independent offline utilities.

### Q-S2: Single-file constraint scope — RESOLVED
**Assumption:** Single-file HTML constraint applies to G-series and some P-series (P-01, P-02). Not a universal constraint. P-03, P-04 are standalone APIs. H-series is mixed (H-02 is HTML, H-01/H-03/H-04 are contributor's choice).

**Implication:** No universal build system needed. G-series and early P-series are zero-dependency HTML files. Server-side components (P-03+, H-series) can use whatever tooling the contributor chooses.

### Q-S3: platform_hints delivery mechanism — RESOLVED
**Assumption:** Optional object in the request body, consistent with the stubs and platform-hints-schema.md.

**Implication:** No special headers or injection mechanisms. APIs accept `platform_hints` as a top-level optional field in the POST body. Absent = standalone mode. Present = platform-connected mode.

---

## Security Architecture

### Q-X1: Rescue isolation — RESOLVED
**Assumption:** Multiple rescues may share the same BCS instance (partner rescues using a shared system).

**Implication:** Multi-tenancy required. Data must be isolated per-rescue at the storage layer. Auth model needs rescue-scoped access. Session history, media, and coaching packets are rescue-private by default. Cross-rescue visibility only through explicit linking (see DEC-003).

### Q-X2: Foster PII handling — RESOLVED
**Assumption:** Dog names are not PII. Standard human PII protections apply to foster names, contact info, and other human-identifying data.

**Implication:** Foster names in coaching packets and session history require standard PII handling — access control, no unnecessary exposure, anonymization in published inventory unless foster consents. Published dog inventory uses dog name only; foster identity is stripped by default.
