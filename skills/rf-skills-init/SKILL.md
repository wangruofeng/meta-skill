---
name: rf-skills-init
description: "初始化项目的 skill 目录配置：以 .claude/skills 为基准（不存在时自动创建），创建 .zcode/skills 和 .codex/skills，并把基准目录下的 skill 软链接到各 agent 目录。当用户在新项目搭建 skill 环境、说「初始化 skill 目录」「配置 zcode / codex 的 skill」「项目还没有 .claude/skills」「让 zcode 和 codex 也能用项目 skill」时使用"
version: 0.2.0
---

# Skill 目录初始化

一键初始化项目的多 agent skill 目录结构。以 `.claude/skills/` 为基准（唯一事实源，skill 只在这里维护），为 zcode 和 codex 创建项目级 skill 目录并建立相对路径软链接——一次初始化，多环境即时可用。

## 安装为全局命令（可选）

一键安装 `skills-init` 命令（alias），之后可在任意项目目录直接初始化；已初始化的项目自动跳过：

> 下面脚本路径中的 `{baseDir}` 指本 SKILL.md 所在目录（即本 skill 目录），运行时替换为实际路径。

```bash
bash {baseDir}/scripts/install.sh              # 安装/更新
bash {baseDir}/scripts/install.sh --uninstall  # 卸载
```

- 存在 `~/.zshrc`（或登录 shell 为 zsh）→ 写入 `~/.zshrc`；否则写入 `~/.bash_profile`
- 重复执行幂等：自动更新指向路径，不产生重复条目
- 安装后执行 `source` 配置文件（或新开终端）生效

## 使用

在 Claude 中直接触发 `/rf-skills-init`（在需要初始化的项目目录下），或运行脚本：

```bash
# 快捷命令（安装 alias 后，推荐）
skills-init                # 已初始化的项目自动跳过
skills-init --force        # 跳过检查，强制执行并输出完整报告

# 完整初始化：创建目录 + 软链接
bash {baseDir}/scripts/init.sh

# 预览模式，不做任何修改
bash {baseDir}/scripts/init.sh --dry-run

# 只创建目录，不建软链接
bash {baseDir}/scripts/init.sh --dirs-only

# 自定义目标目录
bash {baseDir}/scripts/init.sh .codex/skills .cursor/skills
```

脚本可从项目任意子目录运行，会自动定位 git 仓库根目录（非 git 项目则用当前目录）。

## 行为

按顺序执行三步：

1. **基准目录**：`.claude/skills/` 不存在时创建；已存在则保留不动
2. **目标目录**：创建 `.zcode/skills` 和 `.codex/skills`（已存在则跳过）
3. **软链接**：把基准目录下每个 skill 以相对路径 `../../.claude/skills/<name>` 链接到各目标目录（跨机器可用）

安全约束：

- **快速跳过**：默认参数下检测到已完整初始化（目录齐备、所有链接正确）时输出一行提示直接退出；`--force` 强制走完整流程
- **幂等**：重复运行安全——已正确的链接跳过，指向错误的自动修复
- **不覆盖真实内容**：目标中同名真实目录或普通文件跳过并警告，绝不覆盖
- **自排除**：不链接 `rf-skills-init` 自身
- **基准不可作目标**：`.claude/skills` 被指定为目标时跳过，避免自引用循环
- 基准目录为空时只建目录不建链接，并提示后续同步方式

## 与 rf-sync-skills 的分工

| Skill | 职责 | 时机 |
|---|---|---|
| `rf-skills-init` | 建目录 + 建立初始软链接 | 新项目一次性初始化 |
| `rf-sync-skills` | 新增/删除 skill 后重新同步、清理断连链接 | 日常维护 |

初始化之后往 `.claude/skills/` 添加新 skill 时，运行 `rf-sync-skills` 同步到各 agent 目录。

## 输出示例

```
=== Skill 目录初始化 ===
项目根: /path/to/project

＋ 创建基准目录: .claude/skills
＋ 创建目标目录: .zcode/skills
＋ 创建目标目录: .codex/skills

基准 skills (2):
  rf-first-principles
  my-skill

▶ 链接到: .zcode/skills
  链接: rf-first-principles
  链接: my-skill
  结果: +2 / ~0 / =0 (新增/修复/已存在)

▶ 链接到: .codex/skills
  链接: rf-first-principles
  链接: my-skill
  结果: +2 / ~0 / =0 (新增/修复/已存在)

=== 初始化完成 ===
```
