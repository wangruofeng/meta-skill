#!/bin/bash
# init.sh — 初始化项目 skill 目录配置
# 以 .claude/skills 为基准（不存在时自动创建），
# 创建 zcode / codex 等 agent 的项目级 skill 目录，并用软链接共享基准目录中的 skill
set -euo pipefail

# 定位项目根目录：git 仓库根，否则当前目录
if git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  PROJECT_ROOT="$git_root"
else
  PROJECT_ROOT="$PWD"
fi

CLAUDE_SKILLS_REL=".claude/skills"
CLAUDE_SKILLS="$PROJECT_ROOT/$CLAUDE_SKILLS_REL"

DRY_RUN=false
DIRS_ONLY=false
FORCE=false
CUSTOM_TARGETS=false
TARGETS=()

usage() {
  cat <<'EOF'
用法: init.sh [--dry-run] [--dirs-only] [--force] [目标目录 ...]

初始化项目 skill 目录配置，以 .claude/skills 为基准（唯一事实源）：
  1. .claude/skills 不存在时自动创建
  2. 创建各 agent 的项目级 skill 目录（默认 .zcode/skills .codex/skills）
  3. 将基准目录下的 skill 以相对路径软链接到各目标目录

选项:
  --dry-run    预览模式，不做任何修改
  --dirs-only  只创建目录，不建立软链接
  --force      跳过「已初始化」快速检查，强制执行并输出完整报告
  -h, --help   显示帮助

示例:
  init.sh                                # 默认初始化 .zcode/skills .codex/skills（已初始化则跳过）
  init.sh --force                        # 强制重新执行
  init.sh .codex/skills .cursor/skills   # 自定义目标目录
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=true; shift ;;
    --dirs-only) DIRS_ONLY=true; shift ;;
    --force)     FORCE=true; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)           CUSTOM_TARGETS=true; TARGETS+=("$1"); shift ;;
  esac
done

# 默认目标：zcode 与 codex 的项目级 skill 目录
if [[ ${#TARGETS[@]} -eq 0 ]]; then
  TARGETS=(".zcode/skills" ".codex/skills")
fi

# ── 0) 快速跳过：已完整初始化时直接退出 ────────────────────
# 仅默认参数下生效：--dry-run / --dirs-only / --force / 自定义目标均走完整流程
is_initialized() {
  [[ -d "$CLAUDE_SKILLS" ]] || return 1
  local target_rel target_dir skill_dir name
  for target_rel in "${TARGETS[@]}"; do
    [[ "$target_rel" == "$CLAUDE_SKILLS_REL" ]] && continue
    target_dir="$PROJECT_ROOT/$target_rel"
    [[ -d "$target_dir" ]] || return 1
    for skill_dir in "$CLAUDE_SKILLS"/*/; do
      # 基准目录为空时 glob 不展开，这里过滤掉字面量
      [[ -d "$skill_dir" ]] || continue
      name="$(basename "$skill_dir")"
      [[ "$name" == "rf-skills-init" ]] && continue
      [[ -L "$target_dir/$name" ]] || return 1
      [[ "$(readlink "$target_dir/$name")" == "../../$CLAUDE_SKILLS_REL/$name" ]] || return 1
    done
  done
  return 0
}

if ! $DRY_RUN && ! $DIRS_ONLY && ! $FORCE && ! $CUSTOM_TARGETS && is_initialized; then
  echo "✓ skill 目录已初始化，跳过（目标: ${TARGETS[*]}）"
  echo "  强制重新执行并查看详情: skills-init --force"
  exit 0
fi

echo "=== Skill 目录初始化 ==="
echo "项目根: $PROJECT_ROOT"
if $DRY_RUN; then
  echo "模式: 预览（不会实际修改）"
fi
echo

# ── 1) 基准目录 ────────────────────────────────────────────
if [[ -d "$CLAUDE_SKILLS" ]]; then
  echo "✓ 基准目录已存在: $CLAUDE_SKILLS_REL"
else
  echo "＋ 创建基准目录: $CLAUDE_SKILLS_REL"
  $DRY_RUN || mkdir -p "$CLAUDE_SKILLS"
fi

# ── 2) 目标目录 ────────────────────────────────────────────
for target_rel in "${TARGETS[@]}"; do
  # 基准目录自身不能作为目标（会自引用循环）
  if [[ "$target_rel" == "$CLAUDE_SKILLS_REL" ]]; then
    echo "！ 跳过基准目录自身: $target_rel"
    continue
  fi
  if [[ -d "$PROJECT_ROOT/$target_rel" ]]; then
    echo "✓ 目标已存在: $target_rel"
  else
    echo "＋ 创建目标目录: $target_rel"
    $DRY_RUN || mkdir -p "$PROJECT_ROOT/$target_rel"
  fi
done
echo

# ── 3) 软链接基准目录中的 skill ────────────────────────────
if $DIRS_ONLY; then
  echo "（--dirs-only：跳过软链接）"
else
  # 收集基准目录下的 skill（自排除，避免工具自身被链接）
  source_names=()
  for skill_dir in "$CLAUDE_SKILLS"/*/; do
    # 基准目录为空时 glob 不展开，这里过滤掉字面量
    [[ -d "$skill_dir" ]] || continue
    name="$(basename "$skill_dir")"
    [[ "$name" == "rf-skills-init" ]] && continue
    source_names+=("$name")
  done

  if [[ ${#source_names[@]} -eq 0 ]]; then
    echo "基准目录为空，没有可链接的 skill"
    echo "提示: 之后往 .claude/skills/ 添加 skill 后，可运行 rf-sync-skills 同步到各 agent 目录"
  else
    echo "基准 skills (${#source_names[@]}):"
    printf "  %s\n" "${source_names[@]}"
    echo

    for target_rel in "${TARGETS[@]}"; do
      # 基准目录自身已在上面跳过
      [[ "$target_rel" == "$CLAUDE_SKILLS_REL" ]] && continue
      target_dir="$PROJECT_ROOT/$target_rel"
      echo "▶ 链接到: $target_rel"

      # 计数用 x=$((x+1)) 而非 ((x++))：后者在 x=0 时返回非零，
      # 会触发 set -e 提前退出
      added=0
      fixed=0
      skipped=0
      for name in "${source_names[@]}"; do
        link="$target_dir/$name"
        expected_target="../../$CLAUDE_SKILLS_REL/$name"
        if [[ -L "$link" ]]; then
          if [[ "$(readlink "$link")" == "$expected_target" ]]; then
            skipped=$((skipped+1))
          else
            echo "  修复: $name (原指向 $(readlink "$link"))"
            $DRY_RUN || ln -sfn "$expected_target" "$link"
            fixed=$((fixed+1))
          fi
        elif [[ -d "$link" ]]; then
          echo "  跳过: $name (真实目录，不覆盖)"
          skipped=$((skipped+1))
        elif [[ -e "$link" ]]; then
          echo "  跳过: $name (普通文件，不覆盖)"
          skipped=$((skipped+1))
        else
          echo "  链接: $name"
          $DRY_RUN || ln -s "$expected_target" "$link"
          added=$((added+1))
        fi
      done
      echo "  结果: +$added / ~$fixed / =$skipped (新增/修复/已存在)"
      echo
    done
  fi
fi

echo "=== 初始化完成 ==="
