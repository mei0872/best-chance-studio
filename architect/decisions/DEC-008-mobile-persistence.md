# DEC-008: Mobile App Persistence Strategy

**Status:** Decided
**Date:** 2026-03-19
**Decider:** App owner (stakeholder confirmation)
**Model(s):** Data, Technical

---

## Context

DEC-002 established the web persistence strategy: IndexedDB + file export, with LocalStorage as a v1 prototype fallback. Native mobile apps need their own persistence approach — the web storage APIs don't apply.

The iOS app (DEC-007) needs to persist scored dogs across sessions so a rescue coordinator can track dogs over time, review past scores, and export results. The current HTML scorer (`bcs-scorer.html`) is session-only — scores are lost on page refresh. The native app should do better.

---

## Options

### Option A: SwiftData (iOS 17+)

**How it works:**
- Apple's modern persistence framework, built on Core Data but with a declarative Swift-native API
- `@Model` classes define the schema. `ModelContainer` manages the store.
- Automatic lightweight schema migration when models change
- Queries via `@Query` property wrapper in SwiftUI views
- Data stored in app sandbox — survives app updates, cleared on uninstall

**Pros:**
- Native to SwiftUI — minimal boilerplate, reactive updates
- Automatic schema migration for simple changes
- No external dependencies
- Handles relationships cleanly (Dog → Sessions → Scores)
- iCloud sync available if needed later (via CloudKit backing)

**Cons:**
- iOS 17+ only (rules out iOS 16 and below)
- Newer framework — less community knowledge than Core Data
- No cross-platform equivalent (Android would use Room)

### Option B: Core Data

**How it works:**
- Apple's mature persistence framework (15+ years)
- NSManagedObject subclasses, NSPersistentContainer
- Manual or generated model classes

**Pros:**
- Supports iOS 15+
- Battle-tested, extensive documentation
- iCloud sync via NSPersistentCloudKitContainer

**Cons:**
- Verbose boilerplate — model editor, generated classes, fetch requests
- Doesn't feel native to SwiftUI (requires wrappers)
- Schema migrations more manual than SwiftData
- Overkill for the current data model complexity

### Option C: SQLite directly (via GRDB or similar)

**How it works:**
- Direct SQLite database access via a Swift library
- Manual schema definition and queries
- Full SQL control

**Pros:**
- Maximum control over schema and queries
- Cross-platform mental model (Android uses SQLite under Room too)
- No framework abstractions to fight

**Cons:**
- Manual everything — no reactive SwiftUI integration
- No built-in relationship management
- More code to maintain
- External dependency (GRDB or similar library)

---

## Tradeoffs

| Factor | A: SwiftData | B: Core Data | C: SQLite |
|--------|-------------|-------------|-----------|
| SwiftUI integration | Native | Wrapper needed | Manual |
| Boilerplate | Minimal | Significant | Medium |
| iOS version | 17+ | 15+ | 15+ |
| Schema migration | Automatic | Manual | Manual |
| Learning curve | Low (Swift-native) | Medium | Low (SQL) |
| Cross-platform parity | Low | Low | High |
| Maturity | New (2023) | Very mature | Very mature |

---

## Recommendation

**Option A: SwiftData.** Since DEC-007 already decided on iOS 17+ minimum, SwiftData is available and is the natural fit for SwiftUI. The data model is simple (Dog → ScoringSession → DimensionScore) and doesn't need Core Data's advanced features. SwiftData's declarative API matches the SwiftUI paradigm and minimizes boilerplate.

---

## Decision

**Option A: SwiftData.**

### Entity Model

```
Dog (1) ──→ (many) ScoringSession (1) ──→ (many) DimensionScore
```

**Dog:**
- `name: String`
- `createdAt: Date`
- `sessions: [ScoringSession]` (cascade delete)

**ScoringSession:**
- `dog: Dog`
- `scoredAt: Date`
- `totalScore: Int`
- `maxScore: Int` (always 18 currently)
- `grade: String` (A+, A, B, C, D)
- `gradeLabel: String`
- `rubricVersion: String` (from `rubric-config.json`)
- `dimensionScores: [DimensionScore]` (cascade delete)

**DimensionScore:**
- `session: ScoringSession`
- `dimensionId: String` (matches `rubric-config.json` dimension IDs)
- `score: Int` (0, 1, or 2)
- `maxScore: Int` (always 2 currently)

### Export Strategy

- **Share sheet** replaces the HTML version's blob download approach
- Export formats: JSON, CSV, PDF (matching the HTML tool's export structure)
- `UIActivityViewController` wrapped for SwiftUI — gives native AirDrop, Messages, Mail, Files
- DEC-002's "export prompt unavoidable" requirement maps to: prompt user to export before deleting a dog or clearing data

### Android Equivalent (Future)

When Android ships (per DEC-007), the equivalent is:
- **Room** (Jetpack persistence library, built on SQLite)
- Same entity model (Dog → ScoringSession → DimensionScore)
- Same export formats (JSON, CSV, PDF)
- Android share intent replaces iOS share sheet

---

## Consequences

- SwiftData `ModelContainer` configured at app entry point (`BestChanceStudioApp.swift`)
- Dog records persist across app launches — users see scored dogs when they return
- Multiple scoring sessions per dog supported (score → improve → re-score)
- `rubricVersion` on each session enables future rubric evolution tracking
- Export must be prompted before destructive actions (delete dog, clear data) per DEC-002
- Android Room implementation will mirror this schema when that platform ships
