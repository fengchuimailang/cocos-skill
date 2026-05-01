#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$HOME/.config/opencode/skills/cocos-skill"
SKILL_FILE="${SKILL_DIR}/SKILL.md"

echo "Validating documentation links in SKILL.md..."
echo ""

# 提取所有相对链接
links=$(grep -oE '\[.*?\]\(references/docs/[^)]+\)' "${SKILL_FILE}" | grep -oE 'references/docs/[^)]+' || true)

if [ -z "${links}" ]; then
  echo "No documentation links found in SKILL.md"
  exit 0
fi

broken=0
valid=0

for link in ${links}; do
  # 移除可能的锚点
  clean_link="${link%%#*}"
  target="${SKILL_DIR}/${clean_link}"
  
  if [ ! -e "${target}" ]; then
    echo "✗ BROKEN: ${link}" >&2
    broken=$((broken + 1))
  else
    echo "✓ OK: ${link}"
    valid=$((valid + 1))
  fi
done

echo ""
echo "Summary:"
echo "  Valid links: ${valid}"
echo "  Broken links: ${broken}"

# 检查 docs 目录结构
echo ""
echo "Documentation structure:"
if [ -d "${SKILL_DIR}/references/docs" ]; then
  for version_dir in "${SKILL_DIR}/references/docs"/*/; do
    if [ -d "${version_dir}" ]; then
      version=$(basename "${version_dir}")
      echo "  ${version}:"
      
      for lang in en zh; do
        if [ -d "${version_dir}${lang}" ]; then
          file_count=$(find "${version_dir}${lang}" -name "*.md" | wc -l)
          echo "    ${lang}: ${file_count} markdown files"
        fi
      done
    fi
  done
else
  echo "  No docs directory found"
fi

if [ ${broken} -gt 0 ]; then
  echo ""
  echo "Found ${broken} broken links. Please fix them." >&2
  exit 1
else
  echo ""
  echo "All links are valid!"
fi
