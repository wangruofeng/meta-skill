# meta-skill

> **Two thinking skills for AI agents: generate from first principles, verify by adversarial review.**
> 给 AI agent 的两个思维方法 skill——用第一性原理生成，用对抗式审查验证。

[English](#english) · 中文

---

## 为什么需要 meta-skill（根本问题）

AI agent 很强，但默认有两个稳定的毛病：

1. **答完就完**——给个答案就停，不追问「这东西本质上在解决什么问题」。结果是会用一堆库/工具，却说不清它们各自为什么存在。
2. **确认偏误**——检查方案/代码/文章时，天然倾向说「看起来没问题」，因为顺向走正常路径看不见真实缺陷。真正危险的 bug 和逻辑漏洞，几乎都藏在极端输入、边界情况、恶意使用里。

这两个毛病，分别对应思考里最难补的两块：**没想清楚** 和 **没找漏洞**。

meta-skill 给出两个 skill，各治一个，组成一个闭环：

| skill | 治什么毛病 | 一句话 | 做什么 |
| --- | --- | --- | --- |
| [`first-principles`](skills/first-principles/SKILL.md) | 答完就完、不追问本质 | 把事物拆到不可再分 | 剥离表象 → 找到少数正交的「根本问题」→ 从根本重建可迁移心智模型 |
| [`adversarial-review`](skills/adversarial-review/SKILL.md) | 确认偏误、看不见漏洞 | 站到对立面搞垮它 | 强制站到攻击者视角，主动构造攻击向量，区分真威胁与假阳性 |

**为什么是两个，不是一个**：生成和验证是对称的，缺一不可——

- 只用 `first-principles` 不做 `adversarial-review` → 方向对，但健壮性差，上线即翻车。
- 只用 `adversarial-review` 不做 `first-principles` → 能扛打，但方向可能一开始就错了。

「想得对」+「没漏掉」，才是完整的思考。

## 安装

两个 skill 都是纯 prompt（各一个 `SKILL.md`），不依赖任何外部工具或 API。装到 Claude Code（或任何支持 skill 的 agent）即可。

**方式一：全局（所有项目可用）**

```bash
cp -r skills/* ~/.claude/skills/
```

**方式二：项目内（只在某个项目可用）**

```bash
cp -r skills/* <你的项目>/.claude/skills/
```

装好后，在 Claude Code 里直接用 `/first-principles` 或 `/adversarial-review` 触发；也会根据你的措辞自动触发（见下）。

## 怎么用

### `/first-principles` — 第一性原理

**什么时候触发**：你想真正「搞懂」一个东西的本质，而不是表面用法——刚转一个新领域、面对一堆陌生库名、遇到复杂模糊的问题、想把一篇文章/书的底层逻辑提炼出来。

**触发词**：第一性原理 / 本质 / 为什么 / 根本 / 底层逻辑 / 拆解 / 从零理解 / 心智模型。

**示例**：

```
/first-principles React + Vite + TanStack Query + Jotai + UnoCSS，我刚转 Web 不熟
```

输出骨架：核心洞察 → N 个根本问题表（通俗说法 + 现有答案 + 常用度）→ 逐个拆解（第一性答案 / 方案分化取舍）→ 心智模型 + 速读法 → 边界与不确定。完整示例见 [`examples/web-tech-stack.md`](examples/web-tech-stack.md)。

### `/adversarial-review` — 对抗式审查

**什么时候触发**：你想确认一个东西「真的没毛病」「能扛得住」——代码上线前的 bug 狩猎、文章/方案的逻辑挑刺、商业方案的反驳、决策的风险排查、系统健壮性测试。

**触发词**：审查 / Review / 找漏洞 / 挑刺 / 有没有问题 / 扛得住 / 边界情况 / 反例 / 攻击 / 压力测试 / 能不能上线。

**多 agent 用法（重要）**：对抗式审查的威力和「对抗密度」正相关。对重要对象，说「**开启多 agent 对抗审查**」，会并发起 N 个 agent，每个扮演不同攻击者（找并发的 / 恶意用户 / 竞争对手……），最后汇总去重按严重度排序。不同视角盲区不重叠，比单 agent 顺查严得多。

**示例**：

```
/adversarial-review 审查这个信源抓取模块的健壮性（附 src/ 目录）
```

输出骨架：破坏目标 → 攻击总结 → 确认的威胁（🔴致命 / 🟡严重 / 🟢一般，含破绽/证据/后果/加固）→ 排除的假阳性 → 未覆盖的攻击面 → 加固优先级。

## 设计哲学

**meta-skill 的核心信念**：思考是两项独立的能力——**生成**（从根本事实出发想出一个对的方案）和**验证**（证明它能扛住真实世界的攻击和意外）。多数 AI 工具只强化「生成」，很少认真做「验证」。

这两个 skill 把这两项能力显式化、可触发、可复用：

- `first-principles` 的内核：**答案会变，根本问题稳定**。抓住根本问题，新答案出现时你能自动归类，而不是重新学一遍。
- `adversarial-review` 的内核：**顺向审查看不见异常路径里的真问题**，强制立场对立才能逼出它们；并诚实区分「真威胁」和「假阳性」，宁可少而准，不要多而虚。

两个 skill 互相点名对方为「配套」——这不是巧合，是设计：一个负责想对，一个负责没漏。合起来是完整的「生成 → 验证」闭环。

## 贡献

欢迎提 issue / PR：补充新示例、改进攻击维度、增加语言版本。这两个 skill 的方法论部分（执行步骤、输出结构、风格要求）是核心，改动请谨慎；对运行环境的引用请保持通用，不要绑定某个特定的笔记库或命令集。

## License

[MIT](LICENSE) © 2026 wangruofeng

---

<a name="english"></a>
## English (brief)

**meta-skill** is a pair of thinking-method skills for AI agents:

- **`first-principles`** — decompose anything into orthogonal fundamental questions, then rebuild transferable mental models. For when you want to *understand*, not memorize.
- **`adversarial-review`** — force an adversarial stance, actively construct attack vectors, and separate real threats from false positives. For when you need to *verify* it actually holds up.

Generate from first principles, verify by adversarial review — a complete think-it-through loop. See [`skills/`](skills/) for the prompts and [`examples/web-tech-stack.md`](examples/web-tech-stack.md) for sample output. MIT licensed.
