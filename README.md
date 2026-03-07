# Best Chance Studio
*Last updated: March 7, 2026*

Open source coaching tools that give every rescue dog their best chance at adoption.

**Free for every rescue. Forever. No matter what platform they post on.**

---

## A Note from Kip, Michele & Beth

We've been fostering dogs since 2009 — alongside Beth Aversa at Blues City Animal Rescue in Memphis. We love dogs. We have seven of our own and we've fostered hundreds. We're hooked on fostering.

But we both come from systems backgrounds — and when you spend enough time inside a broken system, you can't help but see the problems. Or the opportunities. Depends how you want to look at it.

Here's the thing: Kip is absolutely terrible at writing dog descriptions. Always has been. But fostering is a community — everybody pitches in — so he keeps sitting down and doing it anyway. We both know there's a better way. We've known it for years. We just finally decided to build it.

What we build here is going to be loved by rescues. It's going to help them get dogs adopted so much faster. And we will do it with you.

— Kip, Michele & Beth

---

## tl;dr

The average rescue dog who isn't a puppy, purebred, or doodle waits 4–6 months for a home. The talent to move them faster already exists inside every rescue. It just needs better coaching, better tools, and a standard that every rescue can access.

**Best Chance Studio is that standard. Open source. MIT licensed. Built on research. Free forever.**

---

## What it looks like in practice

**Before BCS:**
> *"Moose is a 3 year old lab mix. He is good with other dogs and kids. He loves to play fetch. He is looking for his forever home."*
> BCS score: **3 / 18**

**After BCS:**
> *"Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play."*
> BCS score: **14 / 18** · Shot list generated · YouTube-ready video produced

---

## What Best Chance Studio Is

Coaching that gives every rescue dog their best chance — better photos, better descriptions, better video, and a clear picture of what each dog needs to go home. The scoring rubric is one piece of it. So is the shot list, the video coaching, the story rewrite, and the presenter prep. All of it together moves dogs faster.

The APIs are open source primitives. Any platform can use them. MIT licensed. Free forever.

---

## Start Here Before Picking an API

These APIs work together as a system. An API built without understanding how the pieces connect will fit the spec but miss the point.

→ **[Read FLOW.md first](FLOW.md)** — it shows exactly how BCS orchestrates every API, what each one receives, and what it's expected to return. Takes 10 minutes. Saves hours of building in the wrong direction.

## The APIs

```
BCS              → the complete assembled application — all APIs below work together as one tool
                   start here if you want to build the whole thing: see [BCS-01] in TASKS.md

/bcs/score       → AI-driven scoring — story, photos, and video analyzed

/coaching/packet → dog score + profile → full coaching brief for the presenter
                   what to fix, shot list (shot_agenda), description draft, live meet tips

/word/check      → paste a description → flagged words + adoption-proven replacements
                   backed by a 70,733-dog study on what language moves adoptions

/voice/transcribe → record a voice note in-app → Whisper transcription → text into session
                   no typing required — speak what you know about the dog

/photos/curate   → selects + orders the strongest photos from raw uploads

/story/build     → produces the full coached story and coaching packet

/story/refine    → foster tweaks the generated story until it's right
                   accept · tweak · start over — nothing publishes without approval

/story/represent → dog didn't place → fresh coaching approach based on what's been tried

/story/card      → approved story → shareable image card for social (1:1 and 4:5)

/story/format    → approved story → platform-formatted output
                   Petfinder · AdoptAPet · Instagram · Facebook — character limits handled

/video/direct    → real-time coaching during live capture
                   high bar: AI Director live on your phone — pre-session briefing,
                   shot agenda tracking, where to stand, when you've got the shot

/video/coach     → analyzes footage post-capture; returns improvement notes
                   + agenda coverage report: what was captured vs. still missing

/video/produce   → produces the highlight reel (cuts, music, pacing)

/video/export    → YouTube-ready output (format, thumbnail, title, tags)
                   high bar: multi-platform in one pass — YouTube, Instagram,
                   TikTok, Facebook each optimized simultaneously
```

→ [See the full input/output breakdown](bcs-example.md)

---

## Ways Engineers Can Help the Rescue Community

### Grab something from the pull list
Pick a task, build it, ship something real. Every API done well will help hundreds — if not thousands — of dogs get to their homes faster. The rescue world thanks you.

→ [See the full pull list — TASKS.md](TASKS.md)

### Help us build more tools
We have more ideas than we have hands. We're looking for full-time help to build them. If you ship something and can't stop thinking about what comes next — that's the conversation we want to have.

→ KipMeierhofer@gmail.com
→ [How the project is governed — GOVERNANCE.md](GOVERNANCE.md)

---

## The People

**Kip Meierhofer** — Co-founder. 25 years building enterprise systems (Northwestern Mutual). Fostering since 2009. 7 dogs at home. Hundreds of fosters alongside Beth at Blues City. Built this because he's been sitting down to write dog descriptions for 15 years and he's still terrible at it — and there was never anything to help. Building the thing that should have existed years ago.

**Michele Meierhofer** — Co-founder. 20+ years marketing leadership. She might be the most dedicated foster mom in the rescue world — she's loved every dog that's come through their door. The brand, the voice, and the heart of everything we build.

**Beth Aversa** — Blues City Animal Rescue, Memphis. ~500 dogs a year. Weekly transport to Chicago, Denver, and 7 East Coast cities. Our first real partner.

---

## Contact

→ [Browse open issues](../../issues)

KipMeierhofer@gmail.com · wag-on-home.com
