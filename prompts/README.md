# BCS Prompts

*Last updated: March 10, 2026*

> The prompts are the logic layer. They encode the research, the rubric, and the coaching methodology in a form any AI model can run.

---

## What This Is

BCS is an AI orchestration system. The prompts in this directory are the working logic behind each scoring and coaching API — the instructions that tell the AI what to look for, how to score it, and what coaching to give back.

They are open source for the same reason the spec is open source: a standard the community can see, critique, and improve is more trustworthy than a black box.

---

## Two Ways to Use These Prompts

### No code required — paste and go
Copy any prompt directly into ChatGPT, Claude, or Gemini. Add your dog's description, photos, or video frames as context. You'll get a scored output immediately.

This is the fastest way to experiment. No API, no setup, no account beyond the AI tool you already use.

### As the logic layer inside a BCS API
Each prompt is designed to be the system prompt (or instruction block) for its corresponding BCS API endpoint. An engineer building `/bcs/score` drops the scoring prompt in as the instruction set. The API contract in the spec defines the input/output shape; the prompt defines what the AI does with it.

---

## Prompts in This Directory

| File | What it scores | Corresponding API |
|------|---------------|-------------------|
| [video-scoring.md](video-scoring.md) | Video quality across 6 dimensions | `/bcs/score` (video component), `/video/coach` |

More prompts coming as the community builds them. If you write one — open a PR.

---

## How to Contribute a Prompt

1. Build it — test it against real rescue content, not hypotheticals
2. Document what it's for, what AI models you tested it on, and what you observed
3. Open a PR — include at least one before/after example showing it working

Prompts that improve based on real adoption outcome data are the highest-value contributions. If you have outcome data that backs a rubric change, bring it.

→ [CONTRIBUTING.md](../CONTRIBUTING.md) · [Discussions](https://github.com/mei0872/best-chance-studio/discussions)

---

*Best Chance Studio™ — the methodology belongs to the rescue community.*
