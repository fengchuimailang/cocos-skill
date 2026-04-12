#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-.}"

if ! command -v cocos >/dev/null 2>&1; then
  echo "cocos CLI not found in PATH" >&2
  exit 1
fi

echo "project_root=${PROJECT_ROOT}"
echo "cocos_bin=$(command -v cocos)"
echo "cocos_version=$(cocos --version)"

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
