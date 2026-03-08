# Architecture Tasks — Best Chance Studio

*Living document. Last updated: March 7, 2026.*

This tracks every architecture task across all 4 models. Tasks are organized by phase — foundation first, then decisions, then validation.

Legend: `[ ]` not started | `[~]` in progress | `[x]` done

---

## Phase 1: Foundation

### 1.1 Data Architecture

- [ ] **Entity model** — Define all entities (Dog, Session, Rescue, Foster, CoachingPacket, Score, Media, ShotAgenda) with attributes and relationships
- [ ] **State machine** — Map session lifecycle: intake → scored → coached → reviewed → approved → published → re-presented
- [ ] **Versioning strategy** — How coaching packets, scores, and stories version across sessions (v1 → v2 → v3)
- [ ] **Storage strategy** — What lives where: client-side (LocalStorage/IndexedDB), file export, server DB, published dog inventory
- [ ] **Published dog inventory schema** — Schema for the persistent record of every dog that completes BCS (profile, story, score, publish date)
- [ ] **Session history model** — How `/story/represent` accesses prior sessions, what signals compound across versions

### 1.2 Technical Architecture

- [ ] **Dependency graph** — Map all 14 APIs and their call dependencies (what calls what, what context propagates)
- [ ] **Offline tier definitions** — Classify every feature: works offline / works offline degraded / requires connectivity
- [ ] **AI service catalog** — Which APIs need LLM calls, which are rule-based, estimated token costs per call
- [ ] **Infrastructure options** — Standalone (static files) vs hosted (API server) vs hybrid deployment models
- [ ] **Mobile-first constraints** — Document 375px viewport, touch targets, camera/mic access patterns
- [ ] **Performance budget** — Target load times, scoring latency, media processing benchmarks

### 1.3 Software Architecture

- [ ] **Component map** — All components, their boundaries, input/output contracts, and which `platform_hints` fields they consume
- [ ] **Orchestration design** — How BCS sequences API calls, carries context, handles partial failures
- [ ] **Config loading strategy** — How `rubric-config.json` and `platform_hints` are loaded, cached, and versioned
- [ ] **API contract inventory** — Validate all stubs against FLOW.md; flag inconsistencies
- [ ] **Error handling strategy** — What happens when one API in the pipeline fails mid-sequence
- [ ] **Output assembly** — How the coaching packet is assembled from individual API responses

### 1.4 Security Architecture

- [ ] **Threat model** — STRIDE analysis for BCS (standalone + platform-connected modes)
- [ ] **PII inventory** — What personal data exists (foster names, dog locations, rescue contacts) and where it flows
- [ ] **Media security** — Photo/video storage, access control, retention policy
- [ ] **Auth boundaries** — What's public (rubric), what's per-rescue (sessions), what's per-platform (hints, outcomes)
- [ ] **platform_hints trust boundary** — How to validate hints from external platforms without trusting blindly
- [ ] **Supply chain** — Dependencies, CDN resources, API keys, OAuth credentials scope

---

## Phase 2: Decisions (ADRs)

Each decision blocks some part of implementation. Ordered by dependency.

- [ ] **DEC-001: Offline scoring** — Two-tier (rule-based offline + AI online) or single-tier? → Blocks: scoring engine, offline tier definitions
- [ ] **DEC-002: Standalone persistence** — LocalStorage, IndexedDB, file export, or backend? → Blocks: storage strategy, session history
- [ ] **DEC-003: Dog identity** — Rescue-scoped vs global dog ID for transport corridors → Blocks: entity model, published dog inventory
- [ ] **DEC-004: Orchestration location** — Client-side, server-side, or isomorphic? → Blocks: component map, deployment model
- [ ] **DEC-005: AI cost model** — Target cost-per-dog and provider abstraction → Blocks: AI service catalog, infrastructure
- [ ] **DEC-006: Offline media boundary** — What media ops work offline vs deferred? → Blocks: offline tiers, mobile constraints

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
        │  DEC-001 ←── AI service catalog
        │  DEC-002 ←── Storage strategy
        │  DEC-003 ←── Entity model
        │  DEC-004 ←── Component map
        │  DEC-005 ←── AI service catalog
        │  DEC-006 ←── Offline tier definitions
        │                      │
        └──────────────────────└──→ Implementation (pull list tasks)
```

Phase 1 tasks inform the decisions. Decisions unblock implementation. Validation confirms everything holds together before code ships.
