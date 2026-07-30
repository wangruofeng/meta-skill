# meta-skill 项目约定

## 目录结构

```
meta-skill/
├── skills/           ← 自有 skills（可修改）
│   └── rf-*/    ← 命名规范：rf- 前缀
│       └── SKILL.md  ← 必需：YAML frontmatter（name, description）
├── third-skills/     ← 第三方 skills（只读，禁止修改内容）
├── README.md         ← 中文主文档
└── README.en.md      ← 英文文档（与 README.md 保持同步）
```

## 红线

- **third-skills/ 只读**：第三方 skill 内容不可修改，只能改 third-skills/README.md（索引说明）
- **skills/ 命名**：自有 skill 统一用 `rf-` 前缀
- **SKILL.md 格式**：每个 skill 必须有 YAML frontmatter，`name` 和 `description` 为必填字段

## 深入文档

| 文档 | 内容 |
|------|------|
| README.md | 项目概述、所有 skill 的用途与触发方式、安装方法 |
| README.en.md | README.md 的英文版本，结构一致 |
| third-skills/README.md | 第三方 skills 索引（含安装指令） |
| skills/*/SKILL.md | 各 skill 的完整定义与工作流程 |
