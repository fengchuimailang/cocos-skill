# Project Validation

Use this reference when Creator's own TypeScript environment is incomplete or path-sensitive.

## Common issue

Some Cocos Creator projects generate temp declarations that point to machine-specific paths. In WSL or another mismatched environment, this can make:

```bash
npx tsc -p <project>/tsconfig.json --noEmit
```

fail even when the gameplay and host scripts are structurally correct.

## Preferred fallback

Bundle changed Cocos entrypoints with `cc` externalized:

```bash
npx esbuild <entry.ts> --bundle --platform=browser --format=esm --external:cc --outfile=/tmp/<name>.js
```

Use this for:

- `assets/script/bootstrap/*.ts`
- `assets/script/view/*.ts`
- `assets/script/game/session/*.ts`
- other host-side entry files that import `cc`

If `npx esbuild` is unavailable on the machine, do not silently skip validation. Report the missing tool and fall back to narrower checks such as import-path inspection, local module existence checks, and JSON validation for changed assets.

## What this catches

- broken imports
- syntax errors
- host-side TypeScript mistakes
- unresolved local modules

## What this does not catch

- broken scene wiring
- missing runtime asset references
- invalid prefab JSON semantics beyond JSON parseability
- engine-only type details that require Creator runtime

## Prefab JSON editing rule

When hand-editing `.prefab` or `.scene` JSON:

1. keep edits narrow
2. preserve `__type__` blocks
3. keep every `__id__` pointing at a valid array item
4. parse the JSON after edits with `scripts/validate-cocos-json.sh <asset.json>`
5. prefer prefab skeletonization over full visual authoring by hand

## JSON validation helper

Use `scripts/validate-cocos-json.sh` after any manual `.prefab` or `.scene` edit.

What it checks:

- JSON parseability
- top-level array shape expected by serialized Cocos assets
- `__id__` references that point outside the serialized array

What it does not check:

- semantic engine correctness
- missing UUID assets
- component-field compatibility with the current Creator version

## Practical bias

- Use prefab files for stable hierarchy.
- Use script components for dynamic labels, sprite assignment, and fallback node creation.
- If the editor is available later, treat hand-edited prefab JSON as an intermediate migration step, not as the long-term authoring ideal.
