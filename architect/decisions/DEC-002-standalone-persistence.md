# DEC-002: Standalone Persistence Strategy

**Status:** Open
**Date:** 2026-03-07
**Decider:** Stakeholder
**Model(s):** Data, Technical

---

## Context

BCS sessions must persist across browser refreshes, phone restarts, and multi-day coaching cycles. A foster starts a session on Monday, takes new photos Wednesday, and gets the video Friday. The session can't reset between those touchpoints.

FLOW.md requires session history: "/story/represent only works because it can see what Session 1 tried." Published dog inventory must persist permanently: "every coached dog that goes through BCS must be logged."

In standalone mode (no backend), persistence lives entirely in the browser or as exported files. The question is which browser storage mechanism — and whether file export is a backup or the primary strategy.

---

## Options

### Option A: LocalStorage

**How it works:**
- Sessions serialized as JSON strings in `localStorage`.
- Key scheme: `bcs-session-{dog_id}-{version}`, `bcs-inventory-{dog_id}`.
- Simple get/set API. Synchronous. Works in every browser.

**Pros:**
- Dead simple to implement.
- Synchronous — no async complexity.
- Universally supported.
- Survives browser refresh and restart.

**Cons:**
- **5MB limit** per origin. A few sessions with embedded media references could hit this fast.
- No structured queries — searching session history requires deserializing everything.
- Cleared by "Clear browsing data" — fosters lose everything.
- No file/blob storage — media must be referenced by path, not stored.
- Single origin — if rescue uses different devices, data doesn't travel.

### Option B: IndexedDB

**How it works:**
- Sessions stored as structured objects in IndexedDB.
- Indexes on dog_id, rescue_id, session_status, version.
- Can store blobs (photos, audio) alongside session data.
- Async API (Promise-based).

**Pros:**
- **Much larger storage** (hundreds of MB, browser-dependent).
- Structured queries — find all sessions for a dog, all dogs pending review.
- Can store media blobs directly (photos, voice notes).
- Survives browser refresh and restart.
- Transaction support for data integrity.

**Cons:**
- More complex API (async, transactions, versioning).
- Still browser-local — doesn't travel between devices.
- Still cleared by "Clear browsing data."
- Browser support is universal but API surface is verbose.
- Mobile Safari has known storage eviction behavior under pressure.

### Option C: File Export/Import

**How it works:**
- Sessions exported as JSON files (or ZIP with media) to the device's filesystem.
- Foster explicitly saves/loads session files.
- No browser storage dependency — files are the persistence layer.

**Pros:**
- **Survives everything** — browser clear, device switch, OS update.
- Foster owns their data as actual files.
- Can be shared (email a session file to the coordinator).
- No storage limits.
- Works with the "single HTML file" philosophy.

**Cons:**
- Manual — foster must remember to export.
- No auto-save. Crash before export = lost work.
- File management UX is poor on mobile.
- No structured queries across sessions without loading all files.
- Sharing introduces versioning conflicts.

### Option D: IndexedDB + File Export (Hybrid)

**How it works:**
- Primary storage: IndexedDB (auto-save, structured queries, media blobs).
- Backup: One-click export to JSON/ZIP file.
- Import: Load a previously exported session file back into IndexedDB.
- Published dog inventory auto-exports as a backup file periodically.

**Pros:**
- Best of both: auto-save + durability.
- Structured queries for active work.
- File export for backup, sharing, device transfer.
- Handles the "Clear browsing data" risk.

**Cons:**
- Most complex to implement.
- Two persistence layers to keep in sync.
- Export/import needs conflict resolution for overlapping sessions.

---

## Tradeoffs

| Factor | A: LocalStorage | B: IndexedDB | C: File Export | D: Hybrid |
|--------|-----------------|--------------|---------------|-----------|
| Storage limit | 5MB | 100MB+ | Unlimited | 100MB+ / Unlimited |
| Media storage | No | Yes (blobs) | Yes (ZIP) | Yes |
| Auto-save | Yes | Yes | No | Yes |
| Survives "Clear data" | No | No | Yes | Partially |
| Cross-device | No | No | Yes (manual) | Yes (manual) |
| Query capability | None | Indexed | None | Indexed |
| Implementation effort | Low | Medium | Medium | High |
| Mobile UX | Good | Good | Poor | Good + export option |

---

## Recommendation

**Option D: IndexedDB + File Export.** IndexedDB handles the daily workflow — auto-saving sessions, storing media references, querying session history. File export handles the durability gap — backup before clearing browser data, share with coordinator, transfer between devices.

The implementation order should be: IndexedDB first (covers 90% of use), file export second (covers the edge cases). LocalStorage can serve as a thin fallback for browsers with IndexedDB issues, storing only the current session ID and minimal state.

---

## Decision

[Awaiting stakeholder input]

---

## Consequences

If Option D:
- Data layer needs an abstraction over IndexedDB (object stores: sessions, dogs, media, inventory)
- Export format needs a documented schema (JSON manifest + media files in ZIP)
- Import needs conflict detection (same dog_id, different versions)
- UI needs export/import controls (prominent enough fosters actually use them)
- Mobile Safari storage eviction must be tested and documented
- Published dog inventory needs periodic auto-export as safety net
