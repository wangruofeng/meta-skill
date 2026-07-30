---
name: rf-skill-installer
description: "输入 GitHub skill 仓库 URL，生成 npx skills add 安装命令。涉及'安装 skill'/'skill 安装'时路由至此。"
version: 1.1.0
---

# Skill 安装命令生成器

## Boundary

- **Owns**: GitHub skill 仓库 URL → `npx skills add` 命令生成
- **Excludes**: 实际执行安装命令、skill 开发
- **Outputs**: 安装命令（供用户复制执行）

## 工作流程

### 1. 解析 URL

| URL 格式 | 解析结果 |
|----------|----------|
| `https://github.com/owner/repo` | `owner/repo` |
| `https://github.com/owner/repo/blob/main/README.md` | `owner/repo` |
| `https://github.com/owner/repo/tree/main/skills/my-skill` | `owner/repo` + `--skill my-skill` |
| `owner/repo` | 直接使用 |

### 2. 生成安装命令（全部列出）

```bash
# 项目级安装
npx skills add <owner/repo>

# 全局安装（所有项目可用）
npx skills add <owner/repo> -g

# 安装到 Claude Code（推荐）
npx skills add <owner/repo> -g -a claude-code -y

# 查看可用 skills
npx skills add <owner/repo> --list
```

### 3. 检查 README 额外步骤

检查是否有：`npm install` / `.env` / `API_KEY` / `python` / `pip` 等额外配置需求。

**Gate G1**: 告知用户是否有额外安装步骤。

## Quality Gates

| Gate | Step | Check |
|------|------|-------|
| G1 | 命令生成后 | 提示用户是否有额外依赖/配置 |

## 禁止事项

1. 禁止实际执行安装命令
2. 禁止对非 GitHub URL 生成命令