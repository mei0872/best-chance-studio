# Best Chance Studio
*Last updated: March 9, 2026*

Open source coaching tools that give every rescue dog their best chance at adoption.

**Free for every rescue. That includes the AI. We're building a charity-funded pool — supported by foundations and donors — so rescue orgs never pay for the AI that helps their dogs get adopted. No matter where they post, no matter which tools they use.**

---

## A Note from Kip, Michele & Beth

We've been fostering dogs since 2019 — alongside Beth Aversa at Blues City Animal Rescue in Memphis. We love dogs. We have seven of our own and we've fostered hundreds. We're hooked on fostering.

But we both come from systems backgrounds — and when you spend enough time inside a broken system, you can't help but see the problems. Or the opportunities. Depends how you want to look at it.

Here's the thing: Kip is absolutely terrible at writing dog descriptions. Always has been. But fostering is a community — everybody pitches in — so he keeps sitting down and doing it anyway. We both know there's a better way. We've known it for years. We just finally decided to build it.

What we build here is going to be loved by rescues. It's going to help them get dogs adopted so much faster. And we will do it with you.

— Kip, Michele & Beth

---

## tl;dr

The average rescue dog who isn't a puppy, purebred, or doodle waits 4–6 months for a home. The talent to move them faster already exists inside every rescue. It just needs better coaching, better tools, and a standard that every rescue can access.

**Best Chance Studio is that standard. Open source. MIT licensed. Built on research. Free for rescues — including the AI.**

---

---

## How BCS Talks About This

A few terms used throughout this spec — worth understanding before diving in:

**Story** — everything currently published that represents a dog: the description, photos, video, all of it together. Not just the words. The whole presentation. This is what BCS scores and improves.

**Session** — a BCS work session to improve a dog's story. Starts with the current story, ends with a better one and a coaching packet.

**Score** — a diagnostic, not a grade. Tells you where the story is now, which of the 9 dimensions are missing, and what to fix first.

**Coaching packet** — the output of a session: gap analysis, shot list, improvement plan, description draft. What a rescue coordinator reads before Saturday's adoption event.

## What it looks like in practice

**Before BCS:**
> *"Moose is a 3 year old lab mix. He is good with other dogs and kids. He loves to play fetch. He is looking for his forever home."*
> BCS score: **3 / 18**

**After BCS:**
> *"Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play."*
> BCS score: **14 / 18** · Shot list generated · YouTube-ready video produced
> The video coached from that shot list? Two people watched it, called each other into the room, and said *"that's our dog."*

---

## What Best Chance Studio Is

Coaching that gives every rescue dog their best chance — better photos, better descriptions, better video, and a clear picture of what each dog needs to go home. The scoring rubric is one piece of it. So is the shot list, the video coaching, the story rewrite, and the presenter prep. All of it together moves dogs faster.

This design is backed by peer-reviewed research — including a 2019 study of 70,733 dogs linking specific language choices to adoption speed, and a 2020 study on how photo attributes affect how fast dogs get adopted.

**BCS works from wherever you are.** Two starting points — same destination:

**Starting with just a dog** — no photos, no description, no existing listing needed. BCS asks you about the dog. What do you notice? What does the dog do? What's the one thing you'd want a family to know? From your answers, BCS builds the story with you and tells you exactly what to capture next. A first-time volunteer who has never done this before can follow BCS through a session and come out with a story worth publishing.

**Starting with existing content** — bring what you have: paste the Petfinder description, upload the photos from ShelterLuv, drop in the YouTube link. BCS reads what adopters are actually seeing, identifies the exact gaps, and gives you research-backed ways to close them. Going from version 0.1 to version 2.0 of a dog's presentation is what BCS is designed to make easy.

**No intake form. No platform registration. Just a dog and someone who cares.**

The APIs are open source primitives. Any platform can use them. MIT licensed. Free forever.

---

## Platform Collaboration — Where We're Headed

BCS is designed to get smarter over time by collaborating directly with adoption platforms through **platform hints** — signals a platform can send back to BCS that make coaching more targeted and timely:

- *Trend insights* — "engagement with outdoor action shots is up 40% this spring"
- *Seasonal context* — "March adoption traffic peaks in 3 weeks — theme week is driving early engagement"
- *Audience signals* — "adopters searching for this breed are asking about apartment compatibility right now"
- *Dog-specific signals* — "3 adopters viewed this listing and dropped off at the description"

Platform hints are a roadmap feature — not in the current version. The API is designed to receive them from day one. If you're building an adoption platform and want to explore integration, reach out.

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

---

## Ways Engineers Can Help the Rescue Community

### Grab something from the pull list
Pick a task, build it, ship something real. Every API done well will help hundreds — if not thousands — of dogs get to their homes faster. The rescue world thanks you.

→ [See the full pull list — TASKS.md](TASKS.md)

### Help us build more tools
We have more ideas than we have hands — and we have funding sources being built that will reward the efforts that build them.

> **We're looking for full-time help to build them. If you ship something and can't stop thinking about what comes next — that's the conversation we want to have.**

→ KipMeierhofer@gmail.com
→ [How the project is governed — GOVERNANCE.md](GOVERNANCE.md)

---

## How BCS Stays Free

BCS is MIT licensed. The code costs nothing. AI features — scoring, story coaching, video analysis — cost something to run. That cost should never land on a rescue.

**For rescues:** Any rescue using any BCS tool draws from a community-funded AI pool — supported by foundations and animal welfare donors through Open Collective *(coming soon — opencollective.com/best-chance-studio)*. Zero setup, zero billing, regardless of which platform or tool they're using.

**For charities and foundations:** Your donation funds AI compute directly for rescues using BCS tools. Open Collective handles your representation preferences — anonymous, named, or with your logo — entirely under your control. BCS implementations show a simple "Community-funded" acknowledgment and link back to Open Collective. Nothing more.

**For engineers:** Any implementation drawing from the pool adds one line: a "Community-funded" badge linking to Open Collective. That's the only funding requirement the spec imposes. Full details in [`docs/funding.md`](docs/funding.md).

The charity pool is in progress. We'll update this when it's live.

→ [Full funding model and spec — docs/funding.md](docs/funding.md)
→ Support BCS on Open Collective *(coming soon — opencollective.com/best-chance-studio)*
→ [Scoring rubric reference — docs/rubric.md](docs/rubric.md)
→ [How BCS gets smarter over time — docs/intelligence.md](docs/intelligence.md)
→ [Field reference — docs/data-dictionary.md](docs/data-dictionary.md)

---

## The People

**Kip Meierhofer** — Co-founder. 25 years building enterprise systems (Northwestern Mutual). Fostering since 2019. 7 dogs at home. Hundreds of fosters alongside Beth at Blues City. Built this because he's been sitting down to write dog descriptions for 15 years and he's still terrible at it — and there was never anything to help. Building the thing that should have existed years ago.

**Michele Meierhofer** — Co-founder. 20+ years marketing leadership. She might be the most dedicated foster mom in the rescue world — she's loved every dog that's come through their door. The brand, the voice, and the heart of everything we build.

**Beth Aversa** — Blues City Animal Rescue, Memphis. ~500 dogs a year. Weekly transport to Chicago, Denver, and 7 East Coast cities. Our first real partner.

---

## How Feedback Gets Back to the Community

BCS improves through use — but only if what's learned in the field comes back.

**The principle:** Implementors are responsible for collecting feedback from their users and contributing findings back to the open source community. This is how the spec, rubric, and API design stay grounded in real use rather than assumptions.

**What implementors are encouraged to share back:**
- Aggregate findings from real rescue and adopter usage — patterns worth acting on, not raw data
- Rubric proposals backed by adoption outcome data
- AI cost findings so the spec gets cheaper over time

**How to contribute feedback:**
- API design or spec gaps → [RFC: API Design & Spec Review](https://github.com/mei0872/best-chance-studio/discussions/17)
- Rubric improvements → open a `Rubric Proposal` issue
- General observations → [GitHub Discussions](https://github.com/mei0872/best-chance-studio/discussions)
- Bugs or spec errors → [GitHub Issues](https://github.com/mei0872/best-chance-studio/issues)

→ Full detail: [CONTRIBUTING.md](CONTRIBUTING.md) · [GOVERNANCE.md](GOVERNANCE.md) · [docs/ai-usage-logging.md](docs/ai-usage-logging.md)

---

## Contact

→ [Browse open issues](../../issues)

KipMeierhofer@gmail.com
