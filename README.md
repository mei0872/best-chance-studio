# Best Chance Studio

*Last updated: March 13, 2026*

Open source dog presentation tools that give every rescue dog their best chance at adoption.

**Free for every rescue. That includes the AI. We're building a charity-funded pool — supported by foundations and donors — so rescue orgs never pay for the AI that helps their dogs get adopted. No matter where they post, no matter which tools they use.**

---

## A Note from Kip, Michele & Beth

We've been fostering dogs since 2019 — alongside Beth Aversa at Blues City Animal Rescue in Memphis. We love dogs. We have seven of our own and we've fostered hundreds. We're hooked on fostering.

But we both come from systems backgrounds — and when you spend enough time inside a broken system, you can't help but see the problems. Or the opportunities. Depends how you want to look at it.

Here's the thing: Kip is terrible at posting dogs.  Pics and video is a pain, and the description never comes out easy. The whole process is always hard, and tedious. But fostering is a community — everybody pitches in — so he keeps sitting down and doing it anyway. We both know there's a better way. We've known it for years. We just finally decided to build it.

What we build here is going to be loved by rescues. It's going to help them get dogs adopted so much faster. We're very excited!

— Kip, Michele & Beth

---

## tl;dr

The average rescue dog who isn't a puppy, purebred, or doodle waits months for a home. The talent to move them faster already exists inside every rescue. It just needs better coaching, better tools, and a standard that every rescue can access.

**Best Chance Studio is that standard. Open source. MIT licensed. Built on research. Free for rescues — including the AI.**

→ **[How it all fits together — FLOW.md](FLOW.md)** — full API walkthrough with real inputs and outputs.

---

## Start Here — Pick a Task

These are ready to build right now:

| Issue | What it is | Difficulty |
|---|---|---|
| [G-04] Word Check Tool | Flags words that hurt adoption — based on a 70,733-dog study. Simple HTML tool. | Good first issue |
| [G-05] Story Card Generator | Takes a coached story + photo and generates a shareable image card for Facebook/Instagram. | Good first issue |
| [G-06] Story Formatter | Reformats an approved description for Petfinder, AdoptAPet, Instagram — respects character limits. | Good first issue |
| [P-02] Story Builder UI | The interface that wraps the `/story/build` API. Mobile-first, no framework required. | Project |
| [P-03] Photo Curation API | Selects best photos, identifies visual gaps, generates a targeted shot list. | Project |

**Before you build:** Read [FLOW.md](FLOW.md) — it's a full API walkthrough using a real dog (Moose). It shows exactly how every piece connects. Takes 15 minutes and saves hours of guessing.

→ [See all open issues](../../issues)

---

## What BCS Does

BCS runs a coaching session for every dog that needs one. You don't need an existing presentation to start. You don't need photos, a description, or a video already in hand. You need a dog and someone who cares about that dog.

**Two ways in — same destination:**

- **Starting with just a dog** — BCS asks you about the dog. What do you notice? What does the dog do? What's the one thing you'd want a family to know? From your answers, BCS builds the story with you and tells you exactly what to capture next.

- **Starting with existing content** — bring what you have: a description, some photos, a video link. BCS scores it against the rubric, shows you exactly what's missing, and gives you research-backed ways to close the gaps. If the dog is posted, take a pic or video of the existing post as input into BCS - we'll make it simple.

Either way, the output is the same: a complete coaching packet — specific, actionable, ready to publish.

### The Rubric

BCS scores a dog's presentation across 9 dimensions — personality, photos, video, compatibility, foster voice, and more — on a 0–2 scale. Every dimension has a clear standard. Every gap gets a specific fix, ranked by adoption impact.

[See the full rubric](RUBRIC.md)

### What it looks like in practice

**Before BCS:**
> *"Moose is a 3 year old lab mix. He is good with other dogs and kids. He loves to play fetch. He is looking for his forever home."*
>
> One blurry shelter photo. No video.
> **BCS score: 3 / 18**

**After BCS:**
> *"Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play."*
>
> **BCS score: 14 / 18** · Presentation shot list generated · YouTube-ready video produced · Killer New Post 
>
> The video coached from that shot list? Two people watched it, called each other into the room, and said *"that's our dog."*

---

### What Best Chance Studio Is

Coaching that gives every rescue dog their best chance — better photos, better descriptions, better video, and a clear picture of what each dog needs to go home. The scoring rubric is one piece of it. So is the shot list, the video coaching, the story rewrite, and the presenter prep. All of it together moves dogs faster.

This design is backed by peer-reviewed research — including a 2019 study of 70,733 dogs linking specific language choices to adoption speed, and a 2020 study on how photo attributes affect how fast dogs get adopted.

### A few terms used throughout

**Story** — everything currently published that represents a dog: the description, photos, video, all of it together. Not just the words. The whole presentation. This is what BCS scores and improves.

**Session** — a BCS work session to improve a dog's story. Starts with the current story, ends with a better one and a coaching packet.

**Score** — a diagnostic, not a grade. Tells you where the story is now, which of the 9 dimensions are missing, and what to fix first.

**Coaching packet** — the output of a session: gap analysis, shot list, improvement plan, description draft. What a rescue coordinator reads before Saturday's adoption event.

---

The full BCS pipeline includes:

- **9-dimension rubric** — scores the current presentation against a clear community standard
- **Gap analysis** — every gap identified and ranked by adoption impact
- **Story builder** — coached description rewriting, led by what only this dog's presenter knows
- **Word impact check** — flags language from adoption research that reduces inquiry rates
- **Shot list** — specific photo and video guidance tailored to this dog
- **Coaching packet** — everything the presenter needs, in one place, ready to execute

---

## Just You, the Dog, and BCS

BCS guides content capture from the very first step. A first-time volunteer who has never done this before can follow BCS through a session and come out the other side with a story worth publishing — photos, description, video coaching, the whole thing. That's the mission: take the talent that already exists inside every rescue and give it the infrastructure it never had.

BCS is designed to score your existing presentation if you have one, otherwise just you and the dog and your existing content is great. Bring in what's already out there: take pics or video of the existing post details (pics, vids, youtube url, profile, memos). BCS sees what adopters are actually seeing, identifies the exact gaps, and builds an improvement plan from there with new, coached-content capture.

Two starting points, same destination:

---

## Platform Collaboration — Where We're Headed

BCS is designed to get smarter over time by collaborating directly with adoption platforms.

**Platform hints** are signals an adoption platform can send back to BCS — insights from real adoption data that make coaching more targeted and timely:

- *Trend insights* — "engagement with outdoor action shots is up 40% this spring"
- *Seasonal context* — "spring adoption traffic peaks in 3 weeks — March Madness theme week is driving early engagement"
- *Audience signals* — "adopters searching for this dog's breed are asking about apartment compatibility more than usual right now"
- *Dog-specific signals* — "3 adopters have viewed this listing and dropped off at the description — here's what the data suggests"

This is the collaboration layer. A rescue volunteer using BCS on a platform that supports platform hints gets coaching that reflects what real adopters are actually responding to right now — not just static research.

Platform hints are a roadmap feature — not available in the current version. But the API is designed to receive them from day one. If you're building an adoption platform and want to explore integration, reach out.

---

## Free. Forever. For Every Rescue.

This is not a goal. It is the constraint the funding model is built around.

BCS works through a hosted model: rescue orgs use BCS through a certified platform host — a shelter network, an adoption platform, or a regional rescue coalition running BCS on their behalf. **Hosts cover the AI costs. Rescues pay nothing and configure nothing.**

AI and infrastructure costs are funded by animal welfare foundations, corporate sponsors, and individual donors. The BCS community is building charity-funded AI pools specifically so certified hosts can cover these costs without ever passing them to rescues. The founder personally seeds early costs. The rescue community doesn't pay. That's the deal, and there's no asterisk.

Every rescue. Every dog. Every presentation. Free — because a host takes on the cost and the governance so rescues never have to.

---

## For Funders & Sponsors

### Why fund BCS?

Every dollar you put into BCS directly reduces the time a dog waits for a home. Not theoretically — trackably.

BCS records every presentation completed, every dog coached, and every outcome we can verify. Donors receive automatic quarterly reports:

> *"Your donation funded X presentations this quarter.  Adoption platforms will eventually report Y dogs placed."*

No manual reporting requests. No chasing receipts. Built into the platform from day one.

**Fully transparent finances.** All transactions are public via Open Collective. Any funder can see exactly where funds go.

**Measurable, not theoretical.** Foundations and grant programs get the stewardship infrastructure they need — built in, not bolted on later.

### How to fund BCS

🔗 **[Fund BCS on Open Collective](https://opencollective.com/best-chance-studio)**

- Tax-deductible via Open Collective Foundation (501(c)(3) fiscal sponsor)
- Any amount. Credit card, check, or Donor-Advised Fund (DAF) — all accepted.
- No minimum. No commitment. Renew based on impact numbers, not promises.

### Sponsorship tiers

**Community Funder** — any amount.
Listed in this README and in every quarterly impact report. Your contribution is acknowledged in the community that's using these tools.

**BCS Powered By** — named sponsor tier for organizations funding at meaningful scale.
Logo in README. Named in all impact reports. Early access to anonymized research findings and outcome data from the broader BCS community.

BCS is designed to carry many funders — foundations, corporate giving programs, individual donors, DAF holders. No single funder owns BCS. That's the point. Your contribution sits alongside others who believe the same thing: that the rescue community deserves better tools, and that funding them is a direct line to dogs going home.

### A note for grant program officers

BCS is designed to meet the stewardship standards of serious funders. If you're evaluating this project for a grant:

- The methodology is open and peer-reviewable — [RUBRIC.md](RUBRIC.md), [FLOW.md](FLOW.md)
- Outcome tracking is built in from the first session — not added for reporting purposes
- Every certified implementation contributes anonymized outcome data to the community standard
- Quarterly reports are automatic, not manual — and available to any funder at any time

We're working toward a measurable claim on time-to-adoption impact. We're not there yet — that data builds as BCS is used in the field. We'll report what we know, and we'll be clear about what we're still learning.

---

## License

MIT licensed — use the code freely.

---

## How to Use BCS

**If you're a rescue org:**
You don't set anything up. Find a certified BCS host — a platform or organization running BCS on your behalf — and use their tools. No accounts. No API keys. No cost. No tech. That's the model.

**If you're a developer or researcher:**
Clone the repo and bring your own API key for testing and development. See [INSTALL.md](INSTALL.md) and [AI-SETUP.md](AI-SETUP.md). Never use a rescue org's funded production access for development.

**If you want to host BCS for rescue orgs:**
You're a platform host. Read the section below — hosting comes with governance responsibilities.

**To understand the full pipeline:**
BCS is a 14-API orchestration pipeline. Each API is standalone — run the full pipeline or any piece of it. [FLOW.md](FLOW.md) walks the complete flow with real inputs and outputs.

---

## For Platform Hosts

A BCS host is any organization running BCS on behalf of rescue orgs — an adoption platform, a shelter network, a regional rescue coalition, or any group that wants to bring BCS to the rescues they serve.

**Hosts are responsible for:**
- Covering AI costs for every rescue org they serve (never passing costs to rescues)
- Verifying that users are legitimate rescue organizations
- Enforcing usage governance and preventing misuse
- Keeping BCS free, zero-setup, and zero-burden for every rescue they serve

**The AI cost model:**
BCS uses AI for coaching features. Hosts pay for it — rescues don't. The BCS community is building charity-funded AI pools so that certified hosts can cover these costs through foundation grants, corporate sponsors, and donor contributions rather than charging rescues. If you're building a host implementation and want to connect with the funding model, reach out.

This is the governance layer that makes "free forever for every rescue" a real promise, not a marketing line.

---

## For Engineers — Start Here

→ **[Read FLOW.md first](FLOW.md)** — it shows exactly how BCS orchestrates every API, what each one receives, and what it's expected to return. Takes 10 minutes. Saves hours of building in the wrong direction.

The APIs work as a system. Each one is also standalone — run the full pipeline or any piece:

```
/bcs/score        → AI-driven scoring across 9 dimensions — story, photos, and video analyzed
/coaching/packet  → dog score + profile → full coaching brief for the presenter
/word/check       → paste a description → flagged words + adoption-proven replacements
/voice/transcribe → record a voice note → Whisper transcription → text into session
/photos/curate    → selects + orders the strongest photos from raw uploads
/story/build      → produces the full coached story and coaching packet
/story/refine     → foster tweaks the generated story until it's right
/story/represent  → dog didn't place → fresh coaching approach based on what's been tried
/story/card       → approved story → shareable image card for social
/story/format     → approved story → platform-formatted output (Petfinder, AdoptAPet, Instagram, Facebook)
/video/direct     → real-time coaching during live capture (high bar — AI Director live on your phone)
/video/coach      → analyzes footage post-capture; returns improvement notes + agenda coverage
/video/produce    → produces the highlight reel (cuts, music, pacing)
/video/export     → YouTube-ready output (format, thumbnail, title, tags)
```

→ [Full pull list — TASKS.md](TASKS.md)
→ [Prompts directory — paste-and-go scoring prompts for ChatGPT/Claude](prompts/README.md)

## Contributing

The pull list is open. No application. No standups. No coordination overhead.

If something catches your eye — grab it. Build it. If it ships, you'll know it helped place real dogs.

### Three ways in

**Grab & Go** *(2–4 hours)*
Small, well-scoped tasks. Pick one up any time. Good entry point for new contributors who want to see what BCS is before committing to more.
→ [TASKS.md — Grab & Go section](TASKS.md#grab-and-go)

**Project** *(1–2 weekends)*
A meaningful feature or improvement with a clear finish line. More satisfying. Still self-contained.
→ [TASKS.md — Projects section](TASKS.md#projects)

**Core** *(ongoing)*
You can't stop thinking about what comes next. That's a different conversation.
→ Start with [CONTRIBUTING.md](CONTRIBUTING.md), then reach out.

> *"The pull list is how we find each other."*

We have more ideas than hands. If you want to build something that matters — not theoretically, but in a way where you can watch the outcome data — this is the place to do it.

---

## The People

**Kip Meierhofer** — co-creator. 25 years building enterprise systems. Fostering since 2019. Seven dogs at home. Hundreds of fosters through the door. Built this because he's been sitting down to write dog descriptions for years and was never any good at it — not for lack of caring, but because nobody ever gave him the tools to do it right. Best Chance Studio is what he wishes he'd had every time he sat down to write a description for a dog who deserved better.

**Michele Meierhofer** — co-creator. 20+ years in marketing. The brand, the voice, and the heart of everything we build. She's loved every dog that's come through their door — and her instincts for what moves people are in every line of this.

**Beth Aversa** — Blues City Animal Rescue, Memphis. Roughly 500 dogs a year. Weekly transport runs up the east coast and to Chicago. Our first real rescue partner — the person who made it real. Everything in BCS has been stress-tested against what works in Beth's world.

---

## Contact

Questions, partnership inquiries, funding conversations, or just want to talk about the problem:

📧 **KipMeierhofer@gmail.com**

Fund BCS:
🔗 **[opencollective.com/best-chance-studio](https://opencollective.com/best-chance-studio)**

---

*Best Chance Studio — free for every rescue. Forever.*
*MIT licensed. Community owned. The coaching belongs to the rescue community.*

