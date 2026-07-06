# meta-skill

> 给 AI agent 的思维方法 skill 集合——用第一性原理生成，用对抗式审查验证。

[English](README.en.md) · 中文

---

## 根本问题

AI agent 默认有两个稳定的毛病：

1. **答完就完** — 给答案就停，不追问本质。结果能用一堆工具，却说不出它们各自为什么存在。
2. **确认偏误** — 顺向审查倾向说「没问题」，看不见边界和恶意路径里的真缺陷。

这两个毛病，分别对应思考里最难补的两块：**没想清楚** 和 **没找漏洞**。

## 核心原理

思考 = 生成 + 验证。两项能力独立、对称、缺一不可。

meta-skill 用两个 skill 把这两项能力显式化：

| skill | 解决什么 | 核心原理 |
| --- | --- | --- |
| [`ruofeng-first-principles`](skills/ruofeng-first-principles/SKILL.md) | 没想清楚 | **答案会变，根本问题稳定**——剥离表象，找到少数正交的根本问题，从根本重建可迁移心智模型 |
| [`ruofeng-adversarial-review`](skills/ruofeng-adversarial-review/SKILL.md) | 没找漏洞 | **顺向审查看不见异常路径的真问题**——强制站到攻击者视角，构造攻击向量，区分真威胁与假阳性 |

**为什么是两个**：只生成不验证 → 方向对但一上线就翻车。只验证不生成 → 能扛打但方向可能一开始就错了。「想对」+「没漏」才是完整的思考。

## 使用场景

### ruofeng-first-principles — 搞懂本质

**原理**：任何领域都由少数正交的根本问题定义。抓住根本问题，新答案出现时自动归类，而不是重新学一遍。

**什么时候用**：
- 转新领域，面对一堆陌生名词想快速建立认知框架
- 遇到复杂模糊的问题，想找到本质
- 想把文章/书的底层逻辑提炼出来

**触发方式**：`/ruofeng-first-principles`，或提到「第一性原理」「本质」「为什么」「根本」「拆解」「从零理解」

**示例**：
```
/ruofeng-first-principles React + Vite + TanStack Query + Jotai + UnoCSS，我刚转 Web
```
> 输出：核心洞察 → 根本问题表 → 逐个拆解（第一性答案/方案分化）→ 心智模型 + 速读法

### ruofeng-adversarial-review — 找漏洞

**原理**：正常路径上的顺向审查天然有盲区。只有强制立场对立、主动构造攻击向量，才能逼出藏在异常路径里的真问题。

**什么时候用**：
- 代码上线前找 bug
- 文章/方案的逻辑挑刺
- 商业方案的反驳、决策的风险排查
- 系统健壮性测试

**触发方式**：`/ruofeng-adversarial-review`，或提到「审查」「找漏洞」「挑刺」「有没有问题」「扛得住」「边界情况」「压力测试」

**多 agent 模式**：对重要对象说「开启多 agent 对抗审查」，并发 N 个 agent 各扮演不同攻击者（恶意用户/竞争对手/找并发 bug 的），盲区不重叠，比单 agent 严得多。

**示例**：
```
/ruofeng-adversarial-review 审查这个信源抓取模块的健壮性（附 src/）
```
> 输出：破坏目标 → 确认的威胁（致命/严重/一般，含破绽/证据/加固）→ 排除的假阳性 → 加固优先级

### ruofeng-sync-skills — 跨环境同步

工具型 skill，不参与生成-验证闭环。通过软链接把 `.claude/skills/` 同步到其他 agent 目录，一次同步所有环境可用。

**触发方式**：`/ruofeng-sync-skills`，或提到「同步 skills」「软链接 skill」

### ruofeng-skill-installer — 生成安装命令

工具型 skill，输入 GitHub skill 仓库 URL，自动解析并生成 `npx skills add` 安装命令，同时检查是否有额外依赖。

**触发方式**：`/ruofeng-skill-installer`，或提到「安装 skill」「skill 安装」

## third-skills — 第三方 skills

精选的第三方生态 skills，详细说明见 [third-skills/README.md](third-skills/README.md)。

| skill | 用途 | 安装 |
|-------|------|------|
| find-skills | 搜索和发现 skills | `npx skills add https://github.com/vercel-labs/skills --skill find-skills` |
| skill-creator | 创建、改进和评估 skills | `npx skills add https://github.com/anthropics/skills --skill skill-creator` |
| yao-meta-skill | 结构化 skill 工程方法论 | `npx skills add https://github.com/yaojingang/yao-meta-skill --skill yao-meta-skill` |

## 安装

skills/ 下的 skill 是纯 prompt（各一个 `SKILL.md`），不依赖外部工具。装到支持 skill 的 agent 即可。

```bash
# 全局（所有项目可用）
cp -r skills/* ~/.claude/skills/

# 单项目
cp -r skills/* <项目>/.claude/skills/
```

third-skills/ 下的第三方 skill 通过 `npx skills add` 安装，具体命令见 [third-skills/README.md](third-skills/README.md)。

## 贡献

欢迎提 issue / PR。各 skill 的方法论部分（执行步骤、输出结构、风格要求）是核心，改动请谨慎。

## License

[MIT](LICENSE) © 2026 wangruofeng
