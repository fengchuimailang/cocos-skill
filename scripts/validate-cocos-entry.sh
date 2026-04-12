#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <entry.ts> [outfile]" >&2
  exit 1
fi

ENTRY="$1"
OUTFILE="${2:-/tmp/$(basename "${ENTRY}" .ts).js}"

npx esbuild "${ENTRY}" \
  --bundle \
  --platform=browser \
  --format=esm \
  --external:cc \
  --outfile="${OUTFILE}"
