# 创建 Skill 规范（目录规范）

> 本规范由 [baoyu-skills](https://github.com/JimLiu/baoyu-skills) 的目录规范迁移改造而来，适配 meta-skill 的形态：`rf-` 前缀、bash 脚本（无 bun/monorepo）、GitHub + `npx skills add` 分发、中文优先。

## 1. 命名与 frontmatter

### name 字段

- **必须 `rf-` 前缀**
- ≤64 字符，仅小写字母 / 数字 / 连字符 `-`
- 禁止包含 `anthropic`、`claude`

### frontmatter 必填与可选字段

| 字段 | 必填 | 说明 |
|---|---|---|
| `name` | ✅ | `rf-` 前缀，见上 |
| `description` | ✅ | 第三人称 + 做什么 + 什么时候用 + 触发词，≤1024 字符 |
| `version` | ✅ | semver；若存在 `manifest.json`，两者必须一致 |
| `argument-hint` | ⬜ | 该 skill 有 `$ARGUMENTS` 输入时填写，提示用户该传什么 |
| `license` | ⬜ | 缺省继承仓库根 `LICENSE`（MIT），一般不必单列 |

### description 写法

- **第三人称**，禁止「我可以帮你…」这类第一人称
- 同时覆盖「做什么」+「什么时候用」，末尾附触发词（中英均可）
- YAML 纯标量优先；含 ASCII 冒号 `:` 或引号时加双引号或 `>-` 折行

```yaml
# 好
description: 站在对立面对代码、方案、文章进行攻击性审查，主动找破绽与反例。用于审查、找漏洞、挑刺等场景。

# 差
description: 我可以帮你审查代码找问题
```

## 2. 目录骨架

```
rf-<name>/
├── SKILL.md            # 必需，唯一入口，正文 <500 行
├── scripts/            # 可选：可执行脚本（.sh / .py / .ts）
├── references/         # 可选：知识与规则（哲学、风格、清单、策略…），仅一层深
├── examples/           # 可选：完整示例输出（统一放这里）
├── agents/             # 可选：interface.yaml 机器可读接口契约
├── evals/              # 可选：触发 / 结构评估脚本
├── reports/            # 可选：产出风险报告（output-risk-profile.md）
└── manifest.json       # 可选：治理元数据
```

各目录职责：

| 目录 | 放什么 | 不放什么 |
|---|---|---|
| `SKILL.md` | 入口：frontmatter + 执行步骤 + 输出结构 | 长篇知识、完整示例（下沉到子目录） |
| `scripts/` | 可执行脚本，自治可移植 | 散在根目录 |
| `references/` | 规则、哲学、风格指南、清单、策略 | 完整示例（放 `examples/`）、报告（放 `reports/`） |
| `examples/` | 完整的输出样例 | 规则性说明 |
| `agents/interface.yaml` | 机器可读契约（见 §4） | — |
| `evals/` | 触发路由 + 目录结构检查脚本 | — |
| `reports/` | 产出风险 / 质量评估报告 | 与 `references/` 混用 |
| `manifest.json` | 治理元数据（见 §4） | — |

### SKILL.md 规模与分层

- 正文 **<500 行**，超出部分下沉到 `references/`
- `references/` 内引用**仅一层深**，避免 agent 递归翻文档
- SKILL.md 内所有相对链接必须指向真实存在的文件（无孤儿文件）

## 3. 脚本约定（可移植性核心）

- 脚本一律放 `scripts/` 子目录，**不散在根目录**
- SKILL.md 引用脚本用 `{baseDir}` 占位符，agent 运行时把 `{baseDir}` 解析为 SKILL.md 实际所在目录——**禁止 `~/.claude/skills/...` 硬编码**（skill 装到哪都能跑）
- 脚本内部用 `BASH_SOURCE` 自定位，不依赖调用方所在目录：

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

SKILL.md 里的写法：

```markdown
```bash
bash {baseDir}/scripts/install.sh              # 安装/更新
bash {baseDir}/scripts/install.sh --uninstall  # 卸载
bash {baseDir}/scripts/init.sh --dry-run
```
```

## 4. 标准文件 schema

### agents/interface.yaml（机器可读接口契约）

供机器/其他 agent 消费的接口描述，字段：

```yaml
name: rf-<name>
description: <一句话能力描述>
inputs:        # 输入字段 → 说明
outputs:       # 输出字段 → 说明
behavior:      # 行为约束列表
exclusions:    # 明确不做的事列表
```

SKILL.md 应在「参考」段链接它。

### manifest.json（治理元数据）

```json
{
  "name": "rf-<name>",
  "version": "与 SKILL.md 严格一致",
  "owner": "wangruofeng",
  "updated_at": "YYYY-MM-DD",
  "review_cadence": "monthly",
  "status": "active",
  "maturity_tier": "production",
  "lifecycle_stage": "production",
  "description": "一句话能力描述",
  "boundary": { "owns": "...", "excludes": ["..."], "outputs": ["..."] }
}
```

**红线**：`manifest.json` 的 `version` 必须与 SKILL.md frontmatter 的 `version` 一致。

### evals/

两类评估脚本：`trigger_eval.py`（正向/负向触发词，验证 description 路由准确）与结构检查（目录与 SKILL.md 引用一致性）。

### reports/output-risk-profile.md

产出风险报告：脚本/流程的失败模式（误删、错误路径、静默退出…）与缓解措施。

## 5. 登记规范

每个 skill 必须同步登记到三处：

1. `README.md`「所有 skill 一览」表 + 安装命令块
2. `README.en.md`（与 README.md 结构一致）
3. 第三方 skill 则登记到 `third-skills/README.md`

## 6. 红线

- `third-skills/` **只读**：第三方 skill 内容不可修改，只改 `third-skills/README.md`
- 自有 skill 统一 `rf-` 前缀
- `version` 与 `manifest.json` 一致
- 文档简体中文优先；README.en.md 与 README.md 同步

## 附：与 baoyu-skills 的差异（改造记录）

| baoyu-skills | meta-skill |
|---|---|
| `baoyu-` 前缀 | `rf-` 前缀 |
| `${BUN_X}` bun/npx 运行时探测 | bash 纯 shell |
| monorepo `packages/*` 共享包 | 无（skill 各自独立） |
| `marketplace.json` + openclaw metadata + npm 发布 | GitHub + `npx skills add` + README 索引 |
| `EXTEND.md` 三层用户偏好 | 不引入（thinking skill 无偏好，tool skill 用参数） |
| — | 增补 `argument-hint`、`agents/interface.yaml`、`manifest.json`、`evals/`、`reports/` |
