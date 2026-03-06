# Best Chance Studio™

*Last updated: March 6, 2026*

Every day a rescue dog waits is a day the tools failed them.
We're building tools that get dogs adopted.

---

## The One Metric

**Dogs going home in under 13 days.**

For the dogs that need help most — seniors, large breeds, dogs with behavioral notes, dogs that don't photograph well — the industry average is 4–6 months. Puppies and doodles move fast. We're not building for them.

The talent to move the harder dogs faster already exists inside every rescue organization. It just needs better coaching, better tools, and a platform that lets every foster immediately tell the story only they know.

One metric. Everything is downstream of it.

---

## The Problem

Existing dog adoption platforms are digital dumping grounds.

A rescue creates a listing. The platform accepts it. No quality bar. No freshness enforcement. No coaching, no feedback, no follow-up. The platform gets its traffic whether the dog goes home or not.

But the platform isn't the only gap.

**The rescue world has never had a standard for what great looks like at adoption time.**

Rescues care deeply — that's not the problem. The people doing this work got into it because they love dogs. Not because they love marketing. Nobody in the rescue world came up through sales or real estate. Nobody taught them how to help an adopter picture that dog at the end of their bed.

A realtor doesn't list square footage. They help you see your life there. That skill is learned — and the rescue world has never had the infrastructure to teach it.

No coaching. No benchmark. No feedback loop. A foster writes the best description they can and hopes it's enough. Most of the time, they have no idea it isn't.

Here's what that looks like:

> *"DOB: 1/22/2016. He is a very sweet boy, loves people; wants to be a lap dog. He is gentle, well mannered, house/leash trained, obeys basic commands."*

Fifty-five words. Written by someone who loves this dog. No standard to measure against. No coaching to do better. No chance.

One session with Best Chance Studio™ changes that. A specific detail that only this dog has. Three photos with eye contact. A note that reveals his sneaky morning kisses during coffee. That's not a hope — that's what the research shows.

---

## What Best Chance Studio™ Is

Best Chance Studio™ is the reference implementation for open source AI-driven coaching that gives every rescue dog their best possible presentation.

The APIs are open source primitives. Any platform can use them. Best Chance Studio™ is the first to combine them into a complete coaching workflow — and Wag On Home is built on top of it, with a proprietary intelligence layer that makes every score smarter with every adoption.

The vision is a platform that runs itself, guided by and for the needs of rescues, and connects every dog to the family that's already looking for them.

---

## Who Uses Best Chance Studio™

**Where we are:** Best Chance Studio™ is in active design — the concept is defined, the rubric is research-backed, the API contracts are written, and the architecture is hardening every day. The tools are being built now through an open pull list. This is the ground floor.

**For any rescue, any platform.**
A better story is a better story wherever it lives. Best Chance Studio™ is designed to improve a listing before it goes anywhere — AdoptAPet, Petfinder, Chewy, Facebook, anywhere a rescue posts. The rescue wins. The dog wins. The platform they're already using gets better listings without doing anything. Best Chance Studio™ gives rescues the standard and coaching to stop waiting for the right adopter to find them — and start driving dogs home.

**For the AI-native adoption platforms being built right now.**
The platforms of the next decade are AI-first and data-centric. Best Chance Studio™ is designed to be the open source foundation they build on — the coaching APIs, the scoring rubric, the quality signal — all open, all composable, all improving as adoption outcome data accumulates.

Best Chance Studio™ doesn't compete with where rescues post today. It's designed to make everything they post better.


**Not a database. Not a platform. A tool.**

Give it what you have — one photo and three sentences, or a full video session and a storyline — and get the best story back. The tool meets you where you are. It assumes heart. It never requires a production team.

Every tool in the pipeline is a discrete, independently callable API. Each one makes the next one better. Each one stands on its own.

```
/bcs/score       → AI-driven scoring on day one — story, photos, and video analyzed
                   high bar: full multi-modal AI analysis + outcome-informed weighting
                   via platform_hints — an open standard any platform can implement

/photos/curate   → selects + orders the strongest photos from raw uploads

/story/build     → produces the full coached story and coaching packet

/video/direct    → real-time coaching during live capture
                   high bar: AI Director live on your phone — where to stand, what angle, when you've got the shot

/video/coach     → analyzes footage post-capture; returns improvement notes

/video/produce   → produces the highlight reel (cuts, music, pacing)
                   high bar: cuts the garbage, finds the magic, adds music — no production team needed

/video/export    → YouTube-ready output (format, thumbnail, title, tags)
                   high bar: multi-platform in one pass — YouTube, Instagram, TikTok,
                   Facebook each optimized simultaneously; outcome-informed thumbnail
                   and title selection via platform_hints
```

---

## The Research Backing

We pulled 33,240 rescue listings and analyzed listing quality. Here's what the data shows:

| Finding | What it means |
|---|---|
| Eye contact photos → shorter time to adoption | A great photo is the difference between a scroll-past and a heartbeat |
| 100+ word descriptions outperform shorter ones | The 70,733-dog study shows specific adjectives change outcomes — "eager," "clever," "gentle" win; "dominant," "trainable," "energetic" lose |
| Word choice predicts adoption speed | "Energetic" signals high maintenance. "Lively" signals joy. Same dog. Different outcome. |
| 0 of 25 longest-listed dogs had transport listed | Zero. Transport turns a local dog into a national candidate in one checkbox. |
| Platform data quality | We pulled 33,240 listings. Most hadn't been updated in years — almost certainly because dogs were adopted and nobody removed the listing. The platforms have zero accountability mechanism. |

> *"The dogs are waiting. The data tells us exactly what to do. Best Chance Studio™ is how we do it."*

---

## Want to Go Deeper?

Pull list tasks are self-contained — no commitment, no coordination. Ship something and walk away. That's a completely valid way to contribute.

But if you ship something and can't stop thinking about what comes next — there are deeper ways to get involved. We're building something that matters, and we're looking for people who feel that.

→ KipMeierhofer@gmail.com

> *"A platform that runs itself, guided by and for the needs of rescues, and connects every dog to the family that's already looking for them."*

---

## Why Open Source — And Where It Goes

The Best Chance Studio™ rubric is a starting hypothesis — grounded in peer-reviewed research, refined by real rescue experience. The goal is for the community to improve it over time: better scoring dimensions, sharper coaching rules, new signal types. Every contribution makes the tools more useful for every rescue that uses them.

The tools are MIT licensed. Fork them, deploy them, use them standalone. Any rescue anywhere can run Best Chance Studio™ without connecting to the platform.

The `platform_hints` layer is an open standard — we define it, anyone can implement it. Any platform that tracks adoption outcomes can provide `platform_hints` to the APIs and reach full high bar capability. Wag On Home provides the richest implementation because we track what happens after every adoption. But the standard is open. The data that flows through it belongs to whoever collects it.

Your contribution compounds. A dimension you help define today gets refined by every adoption that follows.

The goal is simple: our open APIs become the Linux of the rescue world.

---

## The Pipeline

Every tool is a step in one story, and each step is independently useful:

```
AI Director improves the capture
  → Photo Curation selects the best stills
    → Video Coaching analyzes what was captured
      → Story Builder produces the coached story + coaching packet
        → Video Production makes the highlight reel
          → Dog goes home
```

See the full Story Builder spec → [`docs/story-builder.md`](docs/story-builder.md)

See the shared platform_hints schema → [`docs/platform-hints-schema.md`](docs/platform-hints-schema.md)

---

## Two Ways In

### Grab something from the pull list
No application. No commitment. Just pick a task, build it, and ship something real.

Every item has a dog on the other side of it. A Best Chance Studio™ scoring tool that ships means the next coordinator evaluates her 40 dogs faster. That's not abstract.

→ [Browse open issues](../../issues)

### Go deeper
If you can't stop thinking about what comes next after shipping something — let's talk.

One lead engineer role. Own the architecture. Design the foundation. Guide every technical decision from the ground up. Equity. The real conversation.

→ KipMeierhofer@gmail.com

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to claim a task, what "done" looks like, code style, and how to submit.

---

## The People

**Kip Meierhofer** — Co-founder. 25 years IT (Northwestern Mutual — developer, systems architect, business architect). 7 dogs. ~100 fosters/year. This isn't a concept.

**Michele Meierhofer** — Co-founder. Marketing. Brand. The voice.

**Beth Aversa** — Founding Rescue Advocate. Blues City Animal Rescue, Memphis.

---

*Wag On Home™ · Best Chance Studio™ · The Sniff Test™*

*[wag-on-home.com](https://wag-on-home.com) · KipMeierhofer@gmail.com*

---

## Get in Touch

- **Questions on a task** → comment on the issue
- **Everything else** → KipMeierhofer@gmail.com
- **Community** → use [GitHub Discussions](https://github.com/mei0872/best-chance-studio/discussions) to ask questions, share ideas, or introduce yourself

