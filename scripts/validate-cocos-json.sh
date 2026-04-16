#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <asset.json>" >&2
  exit 1
fi

ASSET_PATH="$1"

if [ ! -f "${ASSET_PATH}" ]; then
  echo "asset_missing=${ASSET_PATH}" >&2
  exit 1
fi

node -e "const fs=require('fs'); const path=require('path'); const assetPath=path.resolve(process.argv[1]); const text=fs.readFileSync(assetPath, 'utf8'); const data=JSON.parse(text); if(!Array.isArray(data)){ throw new Error('Expected top-level JSON array'); } const missing=[]; data.forEach((item,index)=>{ if(item && typeof item==='object'){ for(const [key,value] of Object.entries(item)){ if(value && typeof value==='object' && Object.keys(value).length===1 && Number.isInteger(value.__id__) && (value.__id__ < 0 || value.__id__ >= data.length)){ missing.push(index + ':' + key + '->' + value.__id__); } } } }); console.log('asset=' + assetPath); console.log('json_parse=ok'); console.log('top_level_items=' + data.length); if(missing.length){ console.log('invalid_ids=' + missing.join(',')); process.exit(2); } console.log('id_bounds=ok');" "${ASSET_PATH}"
