# Third Skills

本目录包含来自第三方生态的 agent skills，每个 skill 提供特定领域的专业能力。

这里的 skill 仅用于备份和说明，按照推荐通过下发指令安装官方最新的版本。

## 目录

| Skill | 说明 | 安装指令 |
|-------|------|----------|
| **[find-skills](./find-skills/)** | 帮助用户发现和安装 agent skills。当用户询问"如何做 X""查找 X 相关的 skill"或希望扩展 agent 能力时，通过 `npx skills` CLI 搜索开放的 skills 生态，验证 skill 质量（安装量、来源信誉、GitHub stars），并推荐最合适的 skill。 | `npx skills add https://github.com/vercel-labs/skills --skill find-skills` |
| **[skill-creator](./skill-creator/)** | 创建、改进和评估 agent skills 的完整工作台。支持从零起草 skill、编写测试用例、并行运行评估、基准性能分析、迭代优化 skill 描述以提升触发准确率。包含 grader、comparator、analyzer 等专用子代理，以及 eval-viewer 可视化评审工具。 | `npx skills add https://github.com/anthropics/skills --skill skill-creator` |
| **[yao-meta-skill](./yao-meta-skill/)** | 从工作流、提示词、对话记录、文档或笔记中创建、重构、评估和打包 agent skills。采用结构化设计方法论，支持 Scaffold（探索）、Production（团队复用）、Library（共享基础设施）三种模式，提供意图对话、参考扫描、产物设计、提示工程、系统思维等核心方法论。 | `npx skills add https://github.com/yaojingang/yao-meta-skill --skill yao-meta-skill` |
