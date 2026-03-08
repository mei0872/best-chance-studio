# DEC-003: Cross-Rescue Dog Identity

**Status:** Decided
**Date:** 2026-03-08
**Decider:** mei0872 (via GitHub Discussion #12)
**Model(s):** Data, Security

---

## Context

Dogs in rescue move. A dog pulled from a shelter in rural Mississippi may be fostered by one rescue, transported to a partner rescue in New England, and adopted from there. This is the transport corridor — it's how rescue works at scale.

The stubs use `rescue_id` + `dog_name` as implicit identity (`"rescue_id": "blues-city-memphis"`, `"dog_name": "Moose"`). This works for a single rescue. But when Moose transfers from Blues City Memphis to a partner rescue in Vermont, what happens to his BCS history?

If identity is rescue-scoped, Moose starts over at the new rescue. Four months of coaching, three session versions, near-miss signals — all gone. His story doesn't compound. It resets.

If identity is global, Moose's history travels with him. The Vermont rescue picks up where Memphis left off. But global identity requires coordination between rescues that may not use the same systems.

---

## Options

### Option A: Rescue-scoped identity

**How it works:**
- Dog ID = `{rescue_id}-{dog_name_slug}-{sequence}` (e.g., `blues-city-memphis-moose-001`)
- Each rescue manages its own dog namespace. No cross-rescue coordination.
- When a dog transfers, the receiving rescue creates a new dog entry. Prior history is not automatically linked.
- Manual option: coordinator exports session history file (see DEC-002) and imports at new rescue.

**Pros:**
- Simple. No cross-rescue infrastructure needed.
- Works for the common case (most dogs stay within one rescue).
- No identity coordination or collision concerns.
- Privacy: rescue A can't see rescue B's data.

**Cons:**
- Transport corridor dogs lose history on transfer.
- Manual file transfer is error-prone and depends on rescue coordination.
- Published dog inventory can't track a dog across rescues without manual linking.
- Near-miss signals and coaching history don't compound across organizations.

### Option B: Global dog identity (microchip-anchored)

**How it works:**
- Dog ID = microchip number (universally unique, already exists for most rescue dogs).
- Fallback for unchipped dogs: `{originating_rescue_id}-{intake_date}-{name_slug}`.
- Session history is keyed to the global ID. Any rescue with the ID can access prior history.

**Pros:**
- History travels with the dog automatically.
- Microchip numbers are already standard in rescue (and required by many states).
- Published dog inventory is truly per-dog, not per-rescue.
- Enables transport corridor tracking and outcome measurement.

**Cons:**
- Not all dogs are microchipped at intake (they get chipped, but sometimes after BCS starts).
- Microchip numbers aren't always known by the foster submitting to BCS.
- Requires a lookup/coordination layer (even if simple) to resolve identity.
- Privacy implications: rescue A can see what rescue B coached. Is that acceptable?
- Standalone mode can't do cross-rescue lookups without connectivity.

### Option C: Rescue-scoped with optional linking

**How it works:**
- Default: rescue-scoped identity (Option A).
- Optional: rescues can link two dog entries as "same dog" using a shared transfer token or microchip number.
- Linking merges session history. Unlinking is not supported (once linked, always linked).
- Linking is explicit — both rescues must confirm.

**Pros:**
- Simple by default (rescue-scoped). Transport corridor support is opt-in.
- No mandatory coordination infrastructure.
- Privacy maintained unless both rescues agree to share.
- Works offline in default mode.

**Cons:**
- Linking UX adds complexity.
- Two systems to reason about (linked vs unlinked dogs).
- If one rescue uses BCS and the other doesn't, linking doesn't help.
- Published inventory still fragmented unless linked.

---

## Tradeoffs

| Factor | A: Rescue-scoped | B: Global | C: Scoped + linking |
|--------|------------------|-----------|-------------------|
| Simplicity | High | Medium | Medium |
| Transport corridor support | No (manual) | Yes | Opt-in |
| Offline support | Full | Partial (lookups need connectivity) | Full (default) / Partial (linking) |
| Privacy | Strong | Weak (cross-rescue visibility) | Strong (default) / Controlled (linked) |
| Implementation effort | Low | High | Medium |
| History compounding | Per-rescue only | Across rescues | Opt-in across rescues |

---

## Recommendation

**Option C: Rescue-scoped with optional linking.** Start simple. Most dogs stay within one rescue. For the transport corridor case, provide an explicit linking mechanism — but don't require it. The linking token can be as simple as the microchip number or a shared session export file.

This avoids building global identity infrastructure before the use case demands it, while leaving the door open for transport corridor support. If outcome data later shows that history compounding across rescues significantly improves adoption speed, upgrade to Option B.

---

## Decision

**Option C: Rescue-scoped with optional linking.** Confirmed by stakeholder.

Stakeholder notes:
- Rescue-scoped is the default that works for 90% of dogs. Simple, fast, no coordination overhead.
- Microchip as the optional linking token is the right choice — it's already the universal dog identifier.
- Manual session export/import (per DEC-002) handles the transfer case for now.
- The door to Option B stays open — the ID format upgrades cleanly if outcome data later justifies it.

**Stakeholder addition:** When a transfer happens and a new rescue creates a new entry, the receiving rescue should see a clear **"Import session from prior rescue"** prompt — not just a blank intake form. This UX detail is what makes Option C work in the field.

---

## Consequences

- Dog ID format: `{rescue_id}-{name_slug}-{sequence}` (rescue-scoped by default)
- Entity model includes optional `linked_ids[]` field for cross-rescue references
- Session export/import (DEC-002) becomes the transport corridor mechanism
- Published dog inventory supports optional merging of linked entries
- **Transfer UX: "Import session from prior rescue" prompt on new dog entry** (stakeholder requirement)
- Future: global registry could be built on top without breaking existing IDs
