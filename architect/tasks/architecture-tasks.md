# Architecture Tasks — Best Chance Studio

*Living document. Last updated: March 8, 2026.*

This tracks every architecture task across all 4 models. Tasks are organized by phase — foundation first, then decisions, then validation.

Legend: `[ ]` not started | `[~]` in progress | `[x]` done

---

## Phase 1: Foundation

### 1.1 Data Architecture

- [~] **Entity model** — Define all entities (Dog, Session, Rescue, Foster, CoachingPacket, Score, Media, ShotAgenda) with attributes and relationships. *Entities and relationships defined. Foster elevated to first-class entity (Q-P3). Dog identity resolved as rescue-scoped (DEC-003).*
- [~] **State machine** — Map session lifecycle: intake → scored → coached → reviewed → approved → published → re-presented. *States defined. Terminal gate clarified: only approved+published dogs enter inventory (Q-D2).*
- [~] **Versioning strategy** — How coaching packets, scores, and stories version across sessions (v1 → v2 → v3). *Strategy outlined. All session history retained with no truncation (Q-D1).*
- [~] **Storage strategy** — What lives where: client-side (LocalStorage/IndexedDB), file export, server DB, published dog inventory. *Categories defined. LocalStorage for v1 prototype (P-02 spec). IndexedDB + file export for production (DEC-002 decided). BCS is source of record for media (Q-D3).*
- [~] **Published dog inventory schema** — Schema for the persistent record of every dog that completes BCS (profile, story, score, publish date). *Minimum schema defined. Scope clarified: approved+published only (Q-D2). Foster PII stripped by default (Q-X2).*
- [~] **Session history model** — How `/story/represent` accesses prior sessions, what signals compound across versions. *History contract defined. All sessions retained (Q-D1).*

### 1.2 Technical Architecture

- [x] **Dependency graph** — Map all 14 APIs and their call dependencies (what calls what, what context propagates). *Fully mapped including H-03→H-04 internal dependency and P-04 as unifying scorer.*
- [~] **Offline tier definitions** — Classify every feature: works offline / works offline degraded / requires connectivity. *Three tiers proposed. DEC-001 decided (two-tier scoring). DEC-006 recommendation confirmed by task specs.*
- [~] **AI service catalog** — Which APIs need LLM calls, which are rule-based, estimated token costs per call. *Catalog complete. Provider abstraction required day 1 (Q-T2). Target < $0.50/dog.*
- [x] **Infrastructure options** — Standalone (static files) vs hosted (API server) vs hybrid deployment models. *Resolved: all deployment modes supported (Q-T1). Isomorphic architecture (DEC-004). Server-side orchestrator (Q-S1).*
- [~] **Mobile-first constraints** — Document 375px viewport, touch targets, camera/mic access patterns. *Technical requirements documented. Multi-language support required (Q-P1).*
- [~] **Performance budget** — Target load times, scoring latency, media processing benchmarks. *Proposed numbers exist. Need validation against real hardware.*

### 1.3 Software Architecture

- [x] **Component map** — All components, their boundaries, input/output contracts, and which `platform_hints` fields they consume. *Complete — updated with all task specs (G-01 through H-04). Stack, inputs, outputs, and hints documented per component.*
- [~] **Orchestration design** — How BCS sequences API calls, carries context, handles partial failures. *Two-layer model defined: Layer 1 (rule-based, client-side), Layer 2 (AI pipeline, server-side orchestrator per Q-S1). Data flow questions identified.*
- [x] **Config loading strategy** — How `rubric-config.json` and `platform_hints` are loaded, cached, and versioned. *Defined. platform_hints delivered as optional request body object (Q-S3).*
- [~] **API contract inventory** — Validate all stubs against FLOW.md; flag inconsistencies. *Cross-reference table built. 7 missing stubs flagged. Rubric discrepancy resolved (9 dimensions confirmed).*
- [~] **Error handling strategy** — What happens when one API in the pipeline fails mid-sequence. *Failure modes and graceful degradation documented.*
- [~] **Output assembly** — How the coaching packet is assembled from individual API responses. *Assembly map complete. PDF as v1 export format (Q-P5). AI disclosure field added (Q-L2).*

### 1.4 Security Architecture

- [~] **Threat model** — STRIDE analysis for BCS (standalone + platform-connected modes). *STRIDE table started. Updated with multi-rescue (Q-X1) and role escalation (Q-P3) threats.*
- [~] **PII inventory** — What personal data exists (foster names, dog locations, rescue contacts) and where it flows. *Inventory complete. Dog names not PII. Foster names are PII with standard protections (Q-X2). AI disclosure required (Q-L2).*
- [~] **Media security** — Photo/video storage, access control, retention policy. *BCS is source of record (Q-D3). Photographer retains rights, BCS license via ToS (Q-L1). Per-rescue access control (Q-X1). Retention policy still open.*
- [~] **Auth boundaries** — What's public (rubric), what's per-rescue (sessions), what's per-platform (hints, outcomes). *Boundaries defined. Auth model resolved: self-serve registration (Q-P2), RBAC with foster/coordinator roles (Q-P3), multi-rescue isolation (Q-X1).*
- [x] **platform_hints trust boundary** — How to validate hints from external platforms without trusting blindly. *Complete — validation rules, attack vectors, and mitigations documented.*
- [~] **Supply chain** — Dependencies, CDN resources, API keys, OAuth credentials scope. *Dependencies and credential management documented. YouTube OAuth scope deferred to H-04 build (Q-L3).*

---

## Phase 2: Decisions (ADRs)

Each decision blocks some part of implementation. Ordered by dependency.

- [x] **DEC-001: Offline scoring** — Two-tier (rule-based offline + AI online). **Decided.** G-01 is Tier 1 (offline), P-04 is Tier 2 (authoritative API). 9 dimensions, max 18 confirmed.
- [x] **DEC-002: Standalone persistence** — IndexedDB + file export for production. LocalStorage for v1 prototype. **Decided.** Export prompt must be unavoidable before storage-clearing actions. File export doubles as transport corridor mechanism.
- [x] **DEC-003: Dog identity** — Rescue-scoped with optional linking via microchip number. **Decided.** Transfer UX must include "Import session from prior rescue" prompt.
- [x] **DEC-004: Orchestration location** — Isomorphic: client-side tools standalone, server-side orchestrator for AI pipeline. **Decided.** Offline path must never return errors — always fall back to rubric-based coaching.
- [x] **DEC-005: AI cost model** — Provider abstraction required day 1. Target < $0.50/dog. BYOK credential flow. **Decided.** Per-call usage logging required. BCS spec silent on who pays.
- [x] **DEC-006: Offline media boundary** — Capture + guidance offline, AI processing online. **Decided.** Client-side brightness/orientation check in v1. Auto-sync queue is "later."

---

## Phase 3: Validation

- [ ] **Models vs stubs** — Walk every stub file through the data and software models; confirm entities, contracts, and state transitions are consistent
- [ ] **Offline scenario walkthrough** — Trace the solo-foster-at-midnight scenario through all 4 models; identify gaps
- [ ] **Contract consistency audit** — Cross-reference FLOW.md step-by-step with stubs/, rubric-config.json, and platform-hints-schema.md
- [ ] **Contributor onboarding test** — Can a new contributor read the architecture docs and understand where their task fits?
- [ ] **Security review** — Walk the threat model through the standalone and platform-connected deployment modes

---

## Dependencies Between Phases

```
Phase 1 Foundation ──→ Phase 2 Decisions ──→ Phase 3 Validation
        │                      │
        │  DEC-001 ←── DECIDED (G-01 + P-04)
        │  DEC-002 ←── DECIDED (IndexedDB + file export)
        │  DEC-003 ←── DECIDED (rescue-scoped + optional linking)
        │  DEC-004 ←── DECIDED (isomorphic)
        │  DEC-005 ←── DECIDED (provider abstraction + BYOK)
        │  DEC-006 ←── DECIDED (capture + guidance offline)
        │                      │
        └──────────────────────└──→ Implementation (pull list tasks)
```

**All 6 decisions are now decided.** Phase 1 is substantially complete — most tasks are in progress with key sections filled. Phase 2 is complete. Phase 3 validation can begin immediately — no remaining blockers.
