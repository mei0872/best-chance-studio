# BCS Funding Model

*Last updated: March 9, 2026*

---

## How BCS AI Gets Funded

BCS tools are free for rescues. The code is MIT licensed and costs nothing to run. But AI features — scoring, story coaching, video analysis — cost something per session. Our commitment is that cost never lands on a rescue.

We fund it through a community charity pool on Open Collective *(coming soon — opencollective.com/best-chance-studio)*. Foundations, animal welfare donors, and anyone who cares about rescue dogs can contribute. The pool covers AI costs for rescues using BCS tools — on any platform, through any implementation.

---

## For Charities and Foundations

**What your donation does:**
Funds AI compute directly for rescue organizations using BCS tools. Every dollar goes toward scoring sessions, story coaching, and video analysis that helps dogs get adopted faster.

**How your representation works:**
Open Collective handles donor preferences entirely. When you donate, you choose how you're represented — anonymous, named, with your logo, or any combination. BCS implementations never hold or display your identity directly. Your preferences live on Open Collective, managed by you, always under your control.

**What BCS implementations show:**
Any BCS tool drawing from the community pool displays a simple "Community-funded" acknowledgment with a link to the Open Collective page. That's it — no implementation-specific donor displays, no logos embedded in tools without your consent.

**Tax deductibility:**
Open Collective Foundation acts as fiscal sponsor — a 501(c)(3) organization. Donations are tax-deductible in the US. Open Collective issues receipts automatically.

→ Donate on Open Collective *(coming soon — opencollective.com/best-chance-studio)*

---

## For Engineers Building BCS Tools

**The acknowledgment requirement:**
Any BCS implementation that draws from the community charity pool must include a visible "Community-funded" acknowledgment — a single line or badge — linking to `https://opencollective.com/best-chance-studio`. This is the only funding-related requirement the spec imposes.

**What you don't need to build:**
- Donor lists or logos — Open Collective hosts these
- Donor preference management — Open Collective handles it
- Billing or payment flows — the pool handles AI costs transparently

**How to connect to the pool:**
When the pool is live, BCS will publish a simple token-based API for implementations to draw from. An implementation presents a valid rescue identifier, draws AI credits, and calls the AI provider. The pool handles the billing. Details in `docs/ai-credentials.md`.

**If you're building a standalone tool before the pool is live:**
Use the BYOK reference implementation in `docs/ai-credentials.md`. When the pool launches, swap in the pool token. The API shape doesn't change.

---

## Governance

The charity pool is governed transparently through Open Collective:
- All transactions are public
- Fund allocation decisions are logged
- Quarterly impact reports show how pool funds translated into rescue outcomes (dogs scored, sessions run, adoptions tracked by implementors who share data back)

Pool governance follows the same principles as BCS spec governance — community input, maintainer decisions, transparent rationale.

→ [BCS Governance — GOVERNANCE.md](GOVERNANCE.md)
→ Open Collective page *(coming soon — opencollective.com/best-chance-studio)*
