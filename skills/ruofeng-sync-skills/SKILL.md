---
name: ruofeng-sync-skills
description: "通过软链接将 .claude/skills 同步到其他 agent 目录（.codex/skills, .cursor/skills 等），自动创建、更新、清理软链接，保持跨环境 skill 即时同步"
version: 0.3.0
---

# Skill 同步工具

通过软链接将 `.claude/skills/` 下的所有 skill 同步到其他 agent 目录。一次同步，所有环境即时生效。

## 使用

```bash
# 自动扫描并同步（推荐）
/ruofeng-sync-skills

# 预览模式
bash .claude/skills/ruofeng-sync-skills/sync.sh --dry-run

# 自动识别模式
bash .claude/skills/ruofeng-sync-skills/sync.sh

# 手动指定目标
bash .claude/skills/ruofeng-sync-skills/sync.sh .codex/skills .cursor/skills
```

## 行为

- **自动发现目标**：扫描所有 `.* /skills/` 目录
- **相对路径软链接**：`../../.claude/skills/xxx`，跨机器可用
- **自排除**：不同步 `ruofeng-sync-skills` 自身
- **自动清理**：删除指向已不存在 skill 的断连软链接
- **不覆盖真实目录**：检测到真实目录时跳过并警告

详细策略：`references/policy.md`
检查清单：`references/checklist.md`
接口定义：`agents/interface.yaml`
质量评估：`evals/`
风险报告：`reports/`

## 输出示例

```
=== Skill 同步 ===
源目录: .claude/skills/
目标: .codex/skills .cursor/skills

源 skills (5):
  ruofeng-style-blog
  ruofeng-wx-to-md
  ...

▶ 处理目标: .codex/skills
  新增: ruofeng-style-blog
  跳过: ruofeng-wx-to-md
  删除: old-skill (源 skill 已不存在)
  结果: +1 / -1 / =1 (新增/删除/已存在)

=== 同步完成 ===
```
