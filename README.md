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

## The Problem

The rescue world has never had a standard for what great looks like at adoption time.

Rescues care deeply — that's not the problem. The people doing this work got into it because they love dogs. Not because they love marketing. Nobody taught them to think like a realtor. A realtor doesn't list square footage — they help you picture your life there. That skill is learned. The rescue world has never had the infrastructure to teach it.

Here's what that gap looks like in a real listing:

> *"DOB: 1/22/2016. He is a very sweet boy, loves people; wants to be a lap dog. He is gentle, well mannered, house/leash trained, obeys basic commands."*

Fifty-five words. Written by someone who loves this dog. No standard to measure against. No coaching to do better. No chance.

Best Chance Studio is the infrastructure that was never there. Not a correction of what rescues are doing wrong — a gift of the coaching they never had access to.

---

## What it looks like in practice

**Before BCS:**
> *"Moose is a 3 year old lab mix. He is good with other dogs and kids. He loves to play fetch. He is looking for his forever home."*
> BCS score: **4 / 20**

**After BCS:**
> *"Moose has a move. The second you sit on the floor — doesn't matter why — he finds the nearest tennis ball and drops it in your lap. Not asking. Just assuming you came to play."*
> BCS score: **9 / 20** · Shot list generated · YouTube-ready video produced

→ [See the full input/output breakdown](bcs-example.md)

---

## What Best Chance Studio Is

A 10-dimension rubric (scored out of 20) that evaluates a dog's story: photos, description, video, personality hook, compatibility, foster voice, and more. Gap analysis tells the presenter exactly what to fix. Coached dogs move faster.

The APIs are open source primitives. Any platform can use them.

→ [Why we open sourced this](WHY.md)
→ [The research behind the rubric](bcs-example.md)

---

## Two Ways In

### Grab something from the pull list
No application. No commitment. Pick a task, build it, ship something real. Every item has a dog on the other side of it.

→ [Browse open issues](../../issues)

### Go deeper
If you ship something and can't stop thinking about what comes next — let's talk.

→ KipMeierhofer@gmail.com

---

## The APIs

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

## The People

**Kip Meierhofer** — Co-founder. 25 years building enterprise systems (Northwestern Mutual). Fostering since 2009. 7 dogs at home. Hundreds of fosters alongside Beth at Blues City. Built this because he's been sitting down to write dog descriptions for 15 years and he's still terrible at it — and there was never anything to help. Building the thing that should have existed years ago.

**Michele Meierhofer** — Co-founder. 20+ years marketing leadership. She might be the most dedicated foster mom in the rescue world — she's loved every dog that's come through their door. The brand, the voice, and the heart of everything we build.

**Beth Aversa** — Blues City Animal Rescue, Memphis. ~500 dogs a year. Weekly transport to 7 East Coast cities. Our first real partner.

---

## Contact

KipMeierhofer@gmail.com · wag-on-home.com

Questions on a task → comment on the issue
Everything else → KipMeierhofer@gmail.com
