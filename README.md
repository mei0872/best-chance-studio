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

Every day a rescue dog waits is a day the tools failed them.

The average rescue dog waits 4–6 months for a home. The talent to move them faster already exists inside every rescue. It just needs better coaching, better tools, and a standard that every rescue can access.

**Best Chance Studio is that standard. Open source. MIT licensed. Built on research. Free forever.**

---

## What it looks like in practice

**Before BCS:**
> *"Moose is a 3 year old lab mix. He is good with other dogs and kids. He loves to play fetch. He is looking for his forever home."*
> BCS score: **4 / 12**

**After BCS:**
> *"Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play."*
> BCS score: **9 / 12** · Shot list generated · Transport listed · YouTube-ready video produced

→ [See the full input/output breakdown](bcs-example.md)

---

## The Problem

The rescue world has never had a standard for what great looks like at adoption time.

Rescues care deeply — that's not the problem. The people doing this work got into it because they love dogs. Not because they love marketing. Nobody taught them to think like a realtor. A realtor doesn't list square footage — they help you picture your life there. That skill is learned. The rescue world has never had the infrastructure to teach it.

Here's what that gap looks like in a real listing:

> *"DOB: 1/22/2016. He is a very sweet boy, loves people; wants to be a lap dog. He is gentle, well mannered, house/leash trained, obeys basic commands."*

Fifty-five words. Written by someone who loves this dog. No standard to measure against. No coaching to do better. No chance.

Best Chance Studio is the infrastructure that was never there. Not a correction of what rescues are doing wrong — a gift of the coaching they never had access to.

---

## What Best Chance Studio Is

A 12-point rubric that scores a dog's presentation: photos, description, video, transport, foster availability, and more. Gap analysis tells the presenter exactly what to fix. Coached dogs move faster.

The APIs are open source primitives. Any platform can use them. Best Chance Studio is the reference implementation — and [Wag On Home](https://github.com/mei0872/wag-on-home) is built on top of it, with a proprietary intelligence layer that gets smarter with every adoption outcome.

```
/bcs/score       → AI-driven scoring — story, photos, and video analyzed

/photos/curate   → selects + orders the strongest photos from raw uploads

/story/build     → produces the full coached story and coaching packet

/video/direct    → real-time coaching during live capture
                   high bar: AI Director live on your phone — where to stand,
                   what angle, when you've got the shot

/video/coach     → analyzes footage post-capture; returns improvement notes

/video/produce   → produces the highlight reel (cuts, music, pacing)

/video/export    → YouTube-ready output (format, thumbnail, title, tags)
                   high bar: multi-platform in one pass — YouTube, Instagram,
                   TikTok, Facebook each optimized simultaneously
```

---

## The Research Backing

We analyzed 33,240+ rescue listings. Here's what the data shows:

| Finding | What it means |
|---|---|
| Eye contact photos → shorter time to adoption | A great photo is the difference between a scroll-past and a heartbeat |
| 100+ word descriptions outperform shorter ones | Specific adjectives change outcomes — "eager," "clever," "gentle" win |
| Word choice predicts adoption speed | "Energetic" signals high maintenance. "Lively" signals joy. Same dog. Different outcome. |
| 0 of 25 longest-listed dogs had transport listed | Zero. Transport turns a local dog into a national candidate in one checkbox. |

---

## Why Open Source

The BCS rubric is a starting hypothesis — grounded in peer-reviewed research, refined by real rescue experience. The goal is for the community to improve it over time: better scoring dimensions, sharper coaching rules, new signal types.

The tools are MIT licensed. Fork them, deploy them, use them standalone. Any rescue anywhere can run Best Chance Studio without connecting to any platform.

The `platform_hints` layer is an open standard — we define it, anyone can implement it. Any platform that tracks adoption outcomes can feed signal back into the APIs. Wag On Home provides the richest implementation because we track what happens after every adoption. But the standard is open.

Our goal: these open APIs become the standard the rescue world builds on.

---

## Two Ways In

### Grab something from the pull list
No application. No commitment. Pick a task, build it, ship something real. Every item has a dog on the other side of it.

→ [Browse open issues](../../issues)

### Go deeper
If you ship something and can't stop thinking about what comes next — let's talk.

One lead engineer role on the Wag On Home platform. Own the architecture. Design the foundation. Equity. The real conversation.

→ KipMeierhofer@gmail.com

---

## The People

**Kip Meierhofer** — Co-founder. 25 years building enterprise systems (Northwestern Mutual). 7 dogs at home. ~100 fosters a year. Built this because the tools that should have existed didn't.

**Michele Meierhofer** — Co-founder. 20+ years marketing leadership. Brand, voice, and the person who will tell you when something sounds corporate and needs to be torn down.

**Beth Aversa** — Blues City Animal Rescue, Memphis. ~500 dogs a year. Weekly transport to 7 East Coast cities. Our first real partner.

---

## Built On Top of BCS

**[Wag On Home](https://github.com/mei0872/wag-on-home)** — the adoption platform built on the BCS coaching layer. Proprietary intelligence on top of an open standard.

---

## Contact

KipMeierhofer@gmail.com · wag-on-home.com

Questions on a task → comment on the issue
Everything else → KipMeierhofer@gmail.com
