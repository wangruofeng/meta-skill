# meta-skill

> **A collection of thinking skills for AI agents — generate from first principles, verify by adversarial review, and more.**

[中文](README.md) · English

---

## Why meta-skill (the fundamental problem)

AI agents are powerful, but they share two stable failure modes by default:

1. **"Answer and stop"** — they hand you an answer and move on without ever asking "what problem is this *actually* solving?". You end up using a pile of libraries and tools without being able to explain why each one exists.
2. **Confirmation bias** — when reviewing a plan / piece of code / article, they naturally lean toward "looks fine", because checking along the happy path can't see real defects. The truly dangerous bugs and logic gaps almost always hide in extreme inputs, edge cases, and malicious use.

These two failure modes map to the two hardest gaps in thinking: **not thinking it through**, and **not finding the holes**.

meta-skill is a growing set of skills that each close one of these gaps. It currently includes two, forming a generate → verify loop:

| skill | closes which gap | in one line | what it does |
| --- | --- | --- | --- |
| [`first-principles`](skills/first-principles/SKILL.md) | "answer and stop", no root questioning | decompose to the indivisible | strip away the surface → find a few orthogonal "fundamental questions" → rebuild transferable mental models |
| [`adversarial-review`](skills/adversarial-review/SKILL.md) | confirmation bias, can't see holes | stand on the other side and break it | force an attacker's stance, actively construct attack vectors, separate real threats from false positives |

**Why these two, as a pair**: generation and verification are symmetric and both essential —

- Only `first-principles` without `adversarial-review` → right direction, but fragile; breaks on launch.
- Only `adversarial-review` without `first-principles` → robust, but the direction might be wrong from the start.

"Think it right" + "don't miss anything" is what complete thinking means.

## Installation

Both skills are pure prompts (one `SKILL.md` each), with no external tools or APIs. Drop them into Claude Code (or any agent that supports skills).

**Option 1: globally (available in all projects)**

```bash
cp -r skills/* ~/.claude/skills/
```

**Option 2: in a single project**

```bash
cp -r skills/* <your-project>/.claude/skills/
```

Once installed, trigger with `/first-principles` or `/adversarial-review` in Claude Code; they also auto-trigger based on your phrasing (see below).

## Usage

### `/first-principles` — first-principles thinking

**When to trigger**: when you want to genuinely *understand* the essence of something rather than its surface usage — entering a new field, facing a pile of unfamiliar library names, tackling a complex fuzzy problem, or distilling the underlying logic of an article or book.

**Trigger words**: first principles / essence / why / fundamental / underlying logic / decompose / from scratch / mental model.

**Example**:

```
/first-principles React + Vite + TanStack Query + Jotai + UnoCSS, I'm new to web
```

Output skeleton: core insight → table of N fundamental questions (plain wording + current answer + frequency) → per-question breakdown (first-principles answer / tradeoff divergence) → mental model + speed-reading method → boundaries & uncertainty. Full example at [`examples/web-tech-stack.md`](examples/web-tech-stack.md).

### `/adversarial-review` — adversarial review

**When to trigger**: when you need to confirm something is *actually fine* and *can hold up* — bug hunting before a release, logic-picking an article or plan, rebutting a business proposal, risk-checking a decision, stress-testing system robustness.

**Trigger words**: review / find holes / nitpick / any issues? / hold up / edge cases / counterexamples / attack / stress test / ready to ship?.

**Multi-agent usage (important)**: the power of adversarial review scales with *adversarial density*. For important targets, say "**turn on multi-agent adversarial review**", and N agents spawn concurrently, each playing a different attacker (concurrency bugs / malicious user / competitor…), then dedupe and rank by severity. Different perspectives have non-overlapping blind spots — far stricter than a single agent's linear pass.

**Example**:

```
/adversarial-review review the robustness of this feed-fetcher module (src/ attached)
```

Output skeleton: break goal → attack summary → confirmed threats (🔴 fatal / 🟡 serious / 🟢 minor, with flaw / evidence / impact / hardening) → ruled-out false positives → uncovered attack surfaces → hardening priority.

## Design philosophy

**The core belief behind meta-skill**: thinking is two independent abilities — **generation** (starting from fundamental facts to arrive at a correct plan) and **verification** (proving it can survive real-world attacks and accidents). Most AI tooling only amplifies "generation"; few take "verification" seriously.

These two skills make both abilities explicit, triggerable, and reusable:

- `first-principles` kernel: **answers change, fundamental questions are stable**. Grasp the fundamental questions and you can automatically categorize new answers as they appear, instead of re-learning from scratch.
- `adversarial-review` kernel: **linear review can't see the real problems on abnormal paths**; only forced opposition can flush them out — and it honestly separates "real threats" from "false positives", preferring few-and-correct over many-and-vague.

The two skills point at each other as "the companion" — not a coincidence, but by design: one is responsible for thinking it right, the other for not missing anything. Together they form a complete generate → verify loop.

## Contributing

Issues and PRs welcome: add new examples, improve attack dimensions, add language versions. The methodology parts of these skills (steps, output structure, style) are the core — change with care. Keep environment references generic; don't tie them to a specific note vault or command set.

## License

[MIT](LICENSE) © 2026 wangruofeng
