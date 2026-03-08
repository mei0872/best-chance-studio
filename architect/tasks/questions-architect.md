# Architect's Questions — Blocking

*These questions must be resolved before the architecture models can be finalized. Organized by model.*

*Last updated: March 7, 2026*

---

## Data Architecture

### Q-D1: Session history depth
How many prior sessions should `/story/represent` have access to? All of them? Last N? Does history get summarized/compressed after a threshold?

**Why it blocks:** Determines storage requirements and the session history model schema.

### Q-D2: Published dog inventory scope
FLOW.md says "every coached dog that goes through BCS before launch is a real dog ready to be matched." Does the inventory include dogs that were coached but never approved by the foster? Or only approved+published?

**Why it blocks:** Defines the terminal states in the session state machine.

### Q-D3: Media storage ownership
Who stores the actual photo/video files? BCS (standalone), the rescue's existing storage, or a platform? The stubs reference filenames (`photo_001.jpg`) but not URLs or storage locations.

**Why it blocks:** Media entity design, security model for access control.

---

## Technical Architecture

### Q-T1: Target environments
Is BCS deployed as: (a) a static site a rescue self-hosts, (b) a hosted service rescues sign up for, (c) a downloadable tool that runs locally, or (d) all of the above?

**Why it blocks:** Drives the entire infrastructure model and offline strategy.

### Q-T2: AI provider assumption
FLOW.md describes AI-powered APIs (story/build, photos/curate, video/direct) but doesn't specify which LLM/vision provider. Is there a target provider? Is provider abstraction a requirement from day 1?

**Why it blocks:** DEC-005 (AI cost model), service catalog, credential management.

### Q-T3: Video processing location
Video production (H-03) and export (H-04) are compute-heavy. Can these run client-side (WASM/WebCodecs) or do they require server-side processing?

**Why it blocks:** DEC-006 (offline media boundary), infrastructure cost model.

---

## Software Architecture

### Q-S1: Orchestration engine ownership
FLOW.md describes BCS as "the orchestration layer" that sequences API calls. Is this orchestration logic: (a) a single coordinator module, (b) distributed across the UI, or (c) a separate backend service?

**Why it blocks:** DEC-004, component boundaries, error recovery strategy.

### Q-S2: Single-file constraint scope
CONTRIBUTING.md says "self-contained HTML file" for Core tasks (G-series). Does this constraint apply to Project tasks (P-series) and High Bar tasks (H-series) too?

**Why it blocks:** Component packaging, dependency management, build tooling decisions.

### Q-S3: platform_hints delivery mechanism
The schema is defined but: how does a platform actually deliver hints to the tools? HTTP header? Wrapper object in the request body? Injected config? The stubs don't show hints in requests.

**Why it blocks:** API contract finalization, integration testing strategy.

---

## Security Architecture

### Q-X1: Rescue isolation
In standalone mode, can multiple rescues use the same BCS instance? Or is each instance single-rescue?

**Why it blocks:** Auth model, data isolation, multi-tenancy design.

### Q-X2: Foster PII handling
Foster names appear in coaching packets and session history. What's the PII classification? Is anonymization required for the published dog inventory?

**Why it blocks:** Data retention policy, GDPR/privacy considerations, export format.
