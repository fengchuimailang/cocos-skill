#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <cocos-docs-path> [version]" >&2
  echo "example: $0 /path/to/cocos-docs 3.9" >&2
  exit 1
fi

DOCS_PATH="$1"
VERSION="${2:-3.8}"
SKILL_DIR="$HOME/.config/opencode/skills/cocos-skill"
DOCS_DIR="${SKILL_DIR}/references/docs"

# 检查源路径
if [ ! -d "${DOCS_PATH}/versions/${VERSION}/en" ]; then
  echo "Error: ${DOCS_PATH}/versions/${VERSION}/en not found" >&2
  exit 1
fi

SOURCE_EN="${DOCS_PATH}/versions/${VERSION}/en"
SOURCE_ZH="${DOCS_PATH}/versions/${VERSION}/zh"

echo "Updating docs from Cocos Creator ${VERSION}..."

# 创建目标目录
mkdir -p "${DOCS_DIR}/${VERSION}/en/scripting"
mkdir -p "${DOCS_DIR}/${VERSION}/en/asset"
mkdir -p "${DOCS_DIR}/${VERSION}/en/ui-system/components/engine"
mkdir -p "${DOCS_DIR}/${VERSION}/zh/scripting"
mkdir -p "${DOCS_DIR}/${VERSION}/zh/asset"
mkdir -p "${DOCS_DIR}/${VERSION}/zh/ui-system/components/engine"

# 复制英文文档
echo "Copying English docs..."
for file in life-cycle-callbacks.md decorator.md access-node-component.md component.md scheduler.md basic.md basic-node-api.md coding-setup.md create-destroy.md external-scripts.md language-support.md load-assets.md log.md reference-class.md scene-managing.md script-basics.md setup.md tsconfig.md usage.md; do
  if [ -f "${SOURCE_EN}/scripting/${file}" ]; then
    cp "${SOURCE_EN}/scripting/${file}" "${DOCS_DIR}/${VERSION}/en/scripting/"
    echo "  ✓ en/scripting/${file}"
  fi
done

# 复制英文图片
for png in "${SOURCE_EN}/scripting/"*.png; do
  if [ -f "${png}" ]; then
    cp "${png}" "${DOCS_DIR}/${VERSION}/en/scripting/"
  fi
done

for file in prefab.md dynamic-load-resources.md asset-manager.md bundle.md sprite-frame.md atlas.md audio.md font.md material.md meta.md scene.md script.md texture.md; do
  if [ -f "${SOURCE_EN}/asset/${file}" ]; then
    cp "${SOURCE_EN}/asset/${file}" "${DOCS_DIR}/${VERSION}/en/asset/"
    echo "  ✓ en/asset/${file}"
  fi
done

# 复制英文资源图片
for png in "${SOURCE_EN}/asset/"*.png; do
  if [ -f "${png}" ]; then
    cp "${png}" "${DOCS_DIR}/${VERSION}/en/asset/"
  fi
done

# 复制 UI 组件文档
if [ -d "${SOURCE_EN}/ui-system/components/engine" ]; then
  for file in "${SOURCE_EN}/ui-system/components/engine/"*.md; do
    if [ -f "${file}" ]; then
      cp "${file}" "${DOCS_DIR}/${VERSION}/en/ui-system/components/engine/"
      echo "  ✓ en/ui-system/components/engine/$(basename "${file}")"
    fi
  done
fi

# 复制中文文档
echo "Copying Chinese docs..."
if [ -d "${SOURCE_ZH}" ]; then
  for file in life-cycle-callbacks.md decorator.md access-node-component.md component.md scheduler.md basic.md basic-node-api.md coding-setup.md create-destroy.md external-scripts.md language-support.md load-assets.md log.md reference-class.md scene-managing.md script-basics.md setup.md tsconfig.md usage.md; do
    if [ -f "${SOURCE_ZH}/scripting/${file}" ]; then
      cp "${SOURCE_ZH}/scripting/${file}" "${DOCS_DIR}/${VERSION}/zh/scripting/"
      echo "  ✓ zh/scripting/${file}"
    fi
  done

  # 复制中文图片
  for png in "${SOURCE_ZH}/scripting/"*.png; do
    if [ -f "${png}" ]; then
      cp "${png}" "${DOCS_DIR}/${VERSION}/zh/scripting/"
    fi
  done

  for file in prefab.md dynamic-load-resources.md asset-manager.md bundle.md sprite-frame.md atlas.md audio.md font.md material.md meta.md scene.md script.md texture.md; do
    if [ -f "${SOURCE_ZH}/asset/${file}" ]; then
      cp "${SOURCE_ZH}/asset/${file}" "${DOCS_DIR}/${VERSION}/zh/asset/"
      echo "  ✓ zh/asset/${file}"
    fi
  done

  # 复制中文资源图片
  for png in "${SOURCE_ZH}/asset/"*.png; do
    if [ -f "${png}" ]; then
      cp "${png}" "${DOCS_DIR}/${VERSION}/zh/asset/"
    fi
  done

  # 复制中文 UI 组件文档
  if [ -d "${SOURCE_ZH}/ui-system/components/engine" ]; then
    for file in "${SOURCE_ZH}/ui-system/components/engine/"*.md; do
      if [ -f "${file}" ]; then
        cp "${file}" "${DOCS_DIR}/${VERSION}/zh/ui-system/components/engine/"
        echo "  ✓ zh/ui-system/components/engine/$(basename "${file}")"
      fi
    done
  fi
fi

# 更新 SKILL.md 中的版本号
echo "Updating SKILL.md version references..."
sed -i "s|references/docs/[0-9]\+\.[0-9]\+/|references/docs/${VERSION}/|g" "${SKILL_DIR}/SKILL.md"
sed -i "s|Cocos Creator [0-9]\+\.[0-9]\+|Cocos Creator ${VERSION}|g" "${SKILL_DIR}/SKILL.md"

# 统计文件数量
FILE_COUNT=$(find "${DOCS_DIR}/${VERSION}" -type f | wc -l)

echo ""
echo "Done! Updated to Cocos Creator ${VERSION}"
echo "Total files: ${FILE_COUNT}"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/validate-docs-links.sh"
echo "  2. Test the skill with a Cocos project"
