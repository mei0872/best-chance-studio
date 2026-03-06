# Best Chance Studio™

*Last updated: March 6, 2026*

Every day a rescue dog waits is a day the tools failed them.
We're building tools that get dogs adopted.

---

## The One Metric

**Dogs going home in under 13 days.**

The industry average is 4–6 months.
The talent to move dogs faster already exists inside every rescue organization.
It just needs better coaching, better tools, and a platform that turns a midnight foster into someone who can change a dog's outcome.

One metric. Everything is downstream of it.

---

## The Problem

These platforms are digital dumping grounds.

A rescue creates a listing. The platform accepts it. No quality bar. No freshness enforcement. No coaching, no feedback, no follow-up. The platform gets its traffic whether the dog goes home or not.

Here's what a typical listing looks like:

> *"DOB: 1/22/2016. He is a very sweet boy, loves people; wants to be a lap dog. He is gentle, well mannered, house/leash trained, obeys basic commands."*

Fifty-five words. No name with personality behind it. No story. No voice. No chance.

One coaching session changes that. A specific detail that only this dog has. Three photos with eye contact. A note that says he can come to you. That's not a hope — that's what the research shows.

---

## What Best Chance Studio™ Is

Best Chance Studio™ is an open source set of coaching tools that give every rescue dog their best possible story.

**Not a database. Not a platform. A tool.**

Give it what you have — one photo and three sentences, or a full video session and a storyline — and get the best story back. The tool meets you where you are. It assumes heart. It never requires a production team.

Every tool in the pipeline is a discrete, independently callable API. Each one makes the next one better. Each one stands on its own.

```
/bcs/score         → scores the full listing (story + photos + video) — 0 to 20
/photos/curate     → selects + orders the strongest photos from raw uploads
/story/build       → produces the full coached story and coaching packet
/video/direct      → real-time AI coaching during live capture
/video/coach       → analyzes footage post-capture; returns improvement notes
/video/produce     → produces the highlight reel (cuts, music, pacing)
/video/export      → YouTube-ready output (format, thumbnail, title, tags)
```

The high bar: an AI Director live on your phone during the shoot — telling you where to stand, what angle, when you've got the shot. A production engine that cuts the garbage, finds the magic, adds music. YouTube-ready output, automatically. The dog's best possible presentation without a production team.

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

> *"The dogs are waiting. The data tells us exactly what to do. BCS is how we do it."*

---

## The Aligned Incentive

Your equity grows when dogs go home. Not as a side effect — as the mechanism.

The platform generates revenue by getting dogs adopted. The better it works, the more dogs go home, the more revenue flows, the more your equity is worth. Long term, that revenue funds rescue wish lists automatically — no humans in the loop.

You're not building a company that does good on the side.
You're building infrastructure that redistributes value back to the mission indefinitely.

> *"A platform that runs itself, guided by and for the needs of rescues, and connects every dog to the family that's already looking for them."*

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

Every item has a dog on the other side of it. A BCS scoring tool that ships means the next coordinator evaluates her 40 dogs faster. That's not abstract.

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

