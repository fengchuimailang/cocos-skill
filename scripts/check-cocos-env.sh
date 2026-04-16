#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-.}"

if ! command -v cocos >/dev/null 2>&1; then
  echo "cocos CLI not found in PATH" >&2
  exit 1
fi

echo "project_root=${PROJECT_ROOT}"
echo "node_bin=$(command -v node || echo missing)"
echo "npm_bin=$(command -v npm || echo missing)"
echo "npx_bin=$(command -v npx || echo missing)"
echo "esbuild_bin=$(command -v esbuild || echo missing)"
echo "cocos_bin=$(command -v cocos)"

COCOS_VERSION_OUTPUT="$(cocos --version 2>&1 || true)"
COCOS_VERSION_OUTPUT="$(printf '%s' "${COCOS_VERSION_OUTPUT}" | tr '\n' ' ' | sed 's/[[:space:]]\\+/ /g' | sed 's/^ //; s/ $//')"

if [ -n "${COCOS_VERSION_OUTPUT}" ]; then
  echo "cocos_version=${COCOS_VERSION_OUTPUT}"
else
  echo "cocos_version=unavailable"
fi

if [ -f "${PROJECT_ROOT}/package.json" ]; then
  echo "package_json=${PROJECT_ROOT}/package.json"
  node -e "const fs=require('fs'); const path=require('path'); const pkg=JSON.parse(fs.readFileSync(path.resolve(process.argv[1]), 'utf8')); console.log('creator_version=' + (pkg.creator?.version ?? 'unknown')); console.log('package_type=' + (pkg.type ?? 'unset'));" "${PROJECT_ROOT}/package.json"
else
  echo "package_json=missing"
fi

for path in assets settings tsconfig.json; do
  if [ -e "${PROJECT_ROOT}/${path}" ]; then
    echo "exists_${path}=yes"
  else
    echo "exists_${path}=no"
  fi
done

if [ -d "${PROJECT_ROOT}/build-templates" ]; then
  echo "exists_build_templates=yes"
else
  echo "exists_build_templates=no"
fi

if [ -d "${PROJECT_ROOT}/extensions" ]; then
  echo "exists_extensions=yes"
else
  echo "exists_extensions=no"
fi

echo "platform_hint=prefer_explicit_platform_web-mobile_web-desktop_android_ios"
