# DEC-007: Native Mobile App Strategy

**Status:** Decided
**Date:** 2026-03-19
**Decider:** App owner (stakeholder confirmation)
**Model(s):** Software, Technical

---

## Context

BCS G-series tools currently ship as single-file HTML pages that run in any mobile browser. This works — but native apps unlock better UX, persistent local storage, native sharing, and a path to device features (camera, microphone) that the H-series and future tools will need.

The question is: how should BCS deliver native mobile apps, and in what order?

---

## Options

### Option A: Native SwiftUI (iOS) + Jetpack Compose (Android)

**How it works:**
- Port G-series tool logic to platform-native code
- SwiftUI + SwiftData on iOS 17+, Kotlin + Jetpack Compose + Room on Android (TBD)
- Each platform gets its own codebase in `ios/` and `android/`
- `rubric-config.json` is the shared source of truth, bundled in both apps

**Pros:**
- Best possible UX — native animations, gestures, accessibility
- Full access to device APIs (camera, file system, share sheet) from day one
- SwiftData / Room give real persistence (not LocalStorage's 5MB cap)
- App Store / Play Store distribution — discoverability and trust
- Sets up clean architecture for H-series features (camera, video, real-time AI)

**Cons:**
- Two codebases to maintain
- More upfront work than wrapping HTML in a WebView
- Requires Apple Developer account ($99/year) and Google Play account ($25 one-time)

### Option B: WebView Wrapper

**How it works:**
- Embed existing HTML files (`bcs-scorer.html`, `bcs-rubric.html`) in a native WebView shell
- Thin native layer for navigation, app icon, and App Store listing
- HTML tools do all the real work

**Pros:**
- Fastest path to an app — existing HTML works as-is
- One codebase for tool logic (HTML)
- Minimal native code to maintain

**Cons:**
- WebView UX feels non-native (scroll behavior, transitions, input handling)
- Limited access to device APIs without bridge code
- Storage still constrained by WebView (IndexedDB, LocalStorage)
- Hard to extend for camera/video features later — bridge complexity grows fast
- App Store reviewers sometimes reject thin WebView wrappers

### Option C: Cross-Platform Framework (React Native / Flutter)

**How it works:**
- Single codebase targeting both iOS and Android
- React Native (JS) or Flutter (Dart)

**Pros:**
- One codebase for both platforms
- Large ecosystems and community support
- Faster than writing native twice

**Cons:**
- Contradicts the project's "no frameworks" philosophy for G-series
- Adds significant dependency surface (React Native = Node + Metro + native bridges)
- Performance and UX lag behind true native, especially for animations and camera
- Contributors need framework-specific knowledge
- Debugging cross-platform issues adds complexity

---

## Tradeoffs

| Factor | A: Native | B: WebView | C: Cross-Platform |
|--------|-----------|------------|-------------------|
| UX quality | Best | Weakest | Good |
| Build effort | High (per platform) | Low | Medium |
| Device API access | Full | Limited | Good (with plugins) |
| Maintenance | Two codebases | One (HTML) | One (framework) |
| Contributor onboarding | Swift / Kotlin skills | HTML/JS only | Framework-specific |
| H-series readiness | Ready | Major rework | Plugin dependent |
| App Store acceptance | Strong | Risky | Strong |
| Offline persistence | SwiftData / Room | WebView storage | SQLite / platform bridge |

---

## Recommendation

**Option A: Native SwiftUI + Jetpack Compose.** The G-series tools are simple enough that porting is straightforward. The real value is in the foundation it sets — persistent storage, native sharing, and clean architecture for camera/video features (H-series) down the road. A WebView wrapper would ship faster but create technical debt that compounds as soon as we need device APIs.

---

## Decision

**Option A: Native, platform-specific apps.**

- **iOS first:** SwiftUI + SwiftData, iOS 17+ minimum, `ios/BestChanceStudio/`
- **Android second:** Kotlin + Jetpack Compose + Room (after iOS ships), `android/`
- **MVP scope:** G-01 (Scorer) + G-02 (Rubric Reference)
- **Full scope:** All G-series tools (G-01 through G-06) on both platforms
- **Distribution:** TestFlight → App Store (iOS), internal testing → Play Store (Android)
- **Shared contract:** `rubric-config.json` bundled in both apps as the single source of truth

### Platform Order Rationale

iOS first because:
1. Primary user base (solo fosters) skews iPhone in the US rescue community
2. SwiftUI + SwiftData on iOS 17+ provides the cleanest modern development experience
3. Validates the native approach before investing in Android
4. Android implementation benefits from lessons learned on iOS

---

## Consequences

- `ios/` directory becomes the iOS app home. `android/` reserved for future Android app.
- HTML tools (`bcs-scorer.html`, `bcs-rubric.html`) remain canonical — native apps are an additional delivery target, not a replacement.
- `rubric-config.json` must stay backward-compatible — native apps bundle it and decode it at launch.
- G-series task specs in TASKS.md get mobile variants (`[G-01-ios]`, `[G-02-ios]`).
- PRD Section 7 (Component Inventory) updated to include native mobile apps.
- CONTRIBUTING.md updated with mobile acceptance criteria.
- Future G-03 through G-06 implementations should plan for both HTML and native from the start.
