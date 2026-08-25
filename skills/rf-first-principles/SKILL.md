---
name: rf-first-principles
description: 把技术栈、新领域、复杂问题或一段内容拆解到不可再分的根本问题，建立可迁移的心智模型。用于想搞懂事物本质、理清底层逻辑、建立认知框架的场景。
version: 0.1.1
argument-hint: "要解读的主题 / 问题 / 内容（可附 URL 或笔记）"
---

# /rf-first-principles — 第一性原理解读与分析

把事物拆解到不可再分的根本问题，再从根本问题重建理解——建立可迁移的心智模型，而非记忆结论。设计哲学见 [references/philosophy.md](references/philosophy.md)。

## 输入

`$ARGUMENTS`：主题/领域名、一组库/工具名、一个复杂问题、或一段内容（URL/文件路径/粘贴文本）。输入为空时，让用户指定分析对象或补充主题。

## 执行步骤

1. **调动已有上下文（可选）**：从输入提取 3-5 个关键词 → Grep 搜索当前目录已有材料（最多 8 篇），记下已有认知和缺失；无材料则跳过。
2. **识别根本问题（核心）**：追问「这个领域本质上在回答哪几个根本问题？」直到答案自明。通常 3-7 个，彼此正交、合起来覆盖全领域，用「根本问题 = 通俗说法」表述。
3. **重建理解**：对每个根本问题——第一性答案（最朴素思路，不绑定工具）→ 现有方案如何回答 → 方案的分化与取舍。
4. **建立心智模型**：一句话心智模型 → 常用度分级（地基/进阶/冷门）→「N 步看懂任何 X」速读法 → 关键易错点。
5. **标注边界**：区分「事实」（可验证）与「推断」（基于证据），主动指出不确定/有争议的部分；约定俗成的内容不必强行拆解。

## 输出结构

依次输出五个部分：**核心洞察**（一句话）→ **根本问题表**（`| 根本问题 | 通俗说法 | 具体答案 | 常用度 |`，全文骨架，务必先建）→ **逐个拆解** → **心智模型与可迁移判断** → **边界与不确定**。

完整输出示例见 [examples/web-tech-stack.md](examples/web-tech-stack.md)。

## 参考

- 接口契约（机器可读）：[agents/interface.yaml](agents/interface.yaml)
- 风格：通俗优先、重「为什么」轻「是什么」、类比克制、引用已有内容、避免空话 → [references/style-guide.md](references/style-guide.md)
- 讲解完成后主动询问是否存为笔记 → [references/note-saving.md](references/note-saving.md)
- 更多示例 → [examples/decompositions.md](examples/decompositions.md)
- 拆完想验证方案扛不扛得住 → 配套的 `rf-adversarial-review`（验证端，与本 skill 对称）
