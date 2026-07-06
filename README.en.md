# meta-skill

> A collection of thinking skills for AI agents — generate from first principles, verify by adversarial review.

[中文](README.md) · English

---

## The Root Problem

AI agents share two stable failure modes by default:

1. **"Answer and stop"** — they hand you an answer without asking what problem it's *actually* solving. You end up using tools without understanding why each exists.
2. **Confirmation bias** — linear review leans toward "looks fine", blind to real defects hiding in edge cases and malicious paths.

These map to the two hardest gaps in thinking: **not thinking it through**, and **not finding the holes**.

## Core Principles

Thinking = generation + verification. Two independent, symmetric abilities — neither works alone.

meta-skill makes both explicit with two skills:

| skill | solves what | core principle |
| --- | --- | --- |
| [`ruofeng-first-principles`](skills/ruofeng-first-principles/SKILL.md) | not thinking it through | **Answers change, fundamental questions are stable** — strip away the surface, find the few orthogonal root questions, rebuild transferable mental models from them |
| [`ruofeng-adversarial-review`](skills/ruofeng-adversarial-review/SKILL.md) | not finding the holes | **Linear review can't see real problems on abnormal paths** — force an attacker's stance, construct attack vectors, separate real threats from false positives |

**Why two, not one**: generation without verification → right direction but breaks on launch. Verification without generation → robust but direction may be wrong from the start. "Think it right" + "don't miss anything" is complete thinking.

## Use Cases

### ruofeng-first-principles — Understand the essence

**Principle**: every domain is defined by a few orthogonal fundamental questions. Grasp them, and you automatically categorize new answers instead of re-learning from scratch.

**When to use**:
- Entering a new field, facing unfamiliar terms, wanting to build a mental framework fast
- Tackling a complex, fuzzy problem and wanting to find its essence
- Distilling the underlying logic of an article or book

**Trigger**: `/ruofeng-first-principles`, or phrases like "first principles", "essence", "why", "fundamental", "decompose", "from scratch"

**Example**:
```
/ruofeng-first-principles React + Vite + TanStack Query + Jotai + UnoCSS, I'm new to web
```
> Output: core insight → fundamental questions table → per-question breakdown (first-principles answer / tradeoffs) → mental model + speed-reading method

### ruofeng-adversarial-review — Find the holes

**Principle**: linear review along the happy path has inherent blind spots. Only forced opposition and active attack construction can flush out the real problems hiding in abnormal paths.

**When to use**:
- Bug hunting before a release
- Logic-picking an article or proposal
- Rebutting a business case, risk-checking a decision
- Stress-testing system robustness

**Trigger**: `/ruofeng-adversarial-review`, or phrases like "review", "find holes", "edge cases", "stress test", "ready to ship?"

**Multi-agent mode**: for critical targets, say "turn on multi-agent adversarial review". N agents spawn concurrently, each playing a different attacker (malicious user / competitor / concurrency hunter). Non-overlapping blind spots — far stricter than single-agent linear pass.

**Example**:
```
/ruofeng-adversarial-review review the robustness of this feed-fetcher module (src/ attached)
```
> Output: break goal → confirmed threats (fatal/serious/minor, with flaw/evidence/hardening) → ruled-out false positives → hardening priority

### ruofeng-sync-skills — Cross-environment sync

A tooling skill outside the generate-verify loop. Syncs `.claude/skills/` to other agent directories via symlinks — one sync, every environment updated.

**Trigger**: `/ruofeng-sync-skills`, or "sync skills", "symlink skills"

### ruofeng-skill-installer — Generate install commands

A tooling skill. Given a GitHub skill repo URL, parses it and generates `npx skills add` install commands, checking for extra dependencies along the way.

**Trigger**: `/ruofeng-skill-installer`, or "install skill", "skill install"

## third-skills — Third-party skills

Curated third-party ecosystem skills. See [third-skills/README.md](third-skills/README.md) for details.

| skill | purpose | install |
|-------|---------|---------|
| find-skills | Discover and search for skills | `npx skills add https://github.com/vercel-labs/skills --skill find-skills` |
| skill-creator | Create, improve, and evaluate skills | `npx skills add https://github.com/anthropics/skills --skill skill-creator` |
| yao-meta-skill | Structured skill engineering methodology | `npx skills add https://github.com/yaojingang/yao-meta-skill --skill yao-meta-skill` |

## Installation

Skills under skills/ are pure prompts (one `SKILL.md` each), no external dependencies. Drop into any agent that supports skills.

```bash
# globally (all projects)
cp -r skills/* ~/.claude/skills/

# single project
cp -r skills/* <project>/.claude/skills/
```

Third-party skills under third-skills/ are installed via `npx skills add`. See [third-skills/README.md](third-skills/README.md) for exact commands.

## Contributing

Issues and PRs welcome. Each skill's methodology (steps, output structure, style) is the core — change with care.

## License

[MIT](LICENSE) © 2026 wangruofeng
