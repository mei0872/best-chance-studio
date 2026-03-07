# Contributing to Best Chance Studio

*Last updated: March 7, 2026*

Welcome. Every item on the pull list has a real dog on the other side of it.
Here's how to show up for them.

---

## How to Claim a Task

1. Find an issue that looks interesting (browse [open issues](../../issues))
2. Leave a comment: *"Claiming this — starting now"*
3. Build it
4. Open a PR when it's ready

That's it. No approval needed. No coordination overhead. First person to comment and ship it, ships it.

If you're mid-build and realize someone else already started — reach out. We'd rather have two people who care than none.

---

## What "Done" Looks Like

### Core Tasks (G-01, G-02)
Self-contained HTML file. No build step. Works offline. Open it in a browser, it runs.

Mobile-friendly at 375px. Brand colors applied (`#F4622A`, `#F9A826`, `#F9F7F4`, `#1E1E2E`).

### Project Tasks (P-01, P-02, P-03)
Working prototype. The thing it says it does, it does.

For APIs: a test UI or clear `curl` examples. A developer reading the PR should be able to run it in under 5 minutes.

For UIs: LocalStorage is fine for v1. No backend required unless the spec says otherwise.

### High Bar Tasks (H-01, H-02, H-03, H-04)
Working proof of concept. The hard technical problem is solved — it doesn't have to be polished.

For AI Director (H-01): live camera → real-time output. Pre-session briefing and shot agenda tracking included. Latency is the hard problem. If it's 3 seconds late, it doesn't count.

For Video Production (H-03): raw footage in → produced reel out. Music, cuts, and pacing that reflect the dog.

For Video Export (H-04): reel in → platform-ready output. YouTube first, multi-platform at high bar.

---

## Code Style

- **Plain, readable, no unnecessary frameworks.** If vanilla JS can do it, use vanilla JS.
- **No build steps for Core tasks.** An HTML file that requires npm to run is not done.
- **Comments over cleverness.** This codebase serves everyone from a midnight foster to a production team. Build accordingly.
- **One thing per file.** Each deliverable is a single, focused tool. Don't bundle.

---

## The Foster Reality

This tool serves everyone from a solo introvert foster at midnight with one phone and a dog who won't sit still — to a rescue team with a coordinator, presenter, videographer, and social media person.

**Build for the person with the least, not the most.**

The minimum viable use case is: one photo + one sentence → still produces something useful. The maximum capable output is a broadcast-quality produced reel. Both are real. Neither is hypothetical.

If your build would be confusing, slow, or broken for the solo midnight foster — it's not done.

---

## The platform_hints Schema

Every API in the Best Chance Studio pipeline accepts a shared `platform_hints` object. This is the channel through which the platform's intelligence talks to the tools — carrying learned parameters like what music tone is converting for dogs like this one, how long the video should be, and which shot to lead with.

**The rules:**
- Every API must accept `platform_hints` as an optional input object
- Ignore gracefully any field you don't recognize
- Never fail if `platform_hints` is null or absent
- Treat hints as guidance, not commands — they are the platform's best current guess
- Document which field groups your API consumes

Full schema → [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md) — lives in this repo, read it before building any H-series task.

Without this: five APIs, five hint formats, nothing connects.
With this: the AI Director knows what the Story Builder knows. The platform's intelligence flows through one consistent channel to every tool in the pipeline.

---

## How to Submit

Open a PR with:
- **Title:** what it does (one line)
- **Description:** which dog it helps — literally, if you can. "This means Beth can score all 40 dogs before Saturday instead of doing it by feel." is the kind of PR description that belongs here.

No formal code review process yet. If it runs and does what it says, we're merging it.

---

## Questions

→ KipMeierhofer@gmail.com
→ [How the project is governed — GOVERNANCE.md](GOVERNANCE.md)

If you're unsure whether something is in scope, just ask. If you're deep in a build and something doesn't add up in the spec — ask. The spec is a starting point, not a cage.
