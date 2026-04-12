---
name: cocos-skill
description: Work on Cocos Creator projects that use scenes, prefabs, `cc` TypeScript scripts, and the local `cocos` CLI. Use when Codex needs to inspect or edit Cocos project structure, migrate gameplay into Cocos host code, validate Cocos TypeScript entrypoints, manipulate prefab/scene JSON carefully, or run `cocos build`, `cocos run`, or `cocos start-mcp-server`.
---

# Cocos Skill

## Overview

Use the local `cocos` CLI first for environment discovery and host-side workflows. Keep gameplay truth in code modules, treat scene and prefab assets as host structure, and validate script changes with a lightweight bundling pass when full Creator type-checking is unavailable.

## Quick Start

1. Identify the project root.
2. Read [references/cocos-cli.md](references/cocos-cli.md) for the available CLI commands and argument patterns.
3. Read [references/project-validation.md](references/project-validation.md) when TypeScript validation or prefab JSON editing is involved.
4. Run `scripts/check-cocos-env.sh <project-root>` before build or run tasks when the local environment is unclear.

## Workflow

### Inspect the project

- Confirm there is a Cocos project by checking for `package.json` with a `creator.version`, `assets/`, `settings/`, and `tsconfig.json`.
- Prefer reading `assets/script/`, `assets/resources/prefabs/`, and `assets/scenes/` before changing host-side logic.
- Keep gameplay rules in plain TypeScript modules where possible. Do not move rule truth into prefab values just because the editor can store them.

### Use the CLI deliberately

- Use `cocos build -j <project> -p <platform>` for explicit build steps.
- Use `cocos run -p <platform> -d <build-dir>` only after there is a build output to run.
- Use `cocos start-mcp-server -j <project>` when a downstream tool or workflow needs the Cocos MCP bridge.
- Prefer explicit project paths and platforms over relying on implicit cwd behavior.

### Validate script changes

- If `tsc` is blocked by Creator-generated absolute paths or editor-only declarations, use `scripts/validate-cocos-entry.sh <entry.ts>` as the default validation path.
- For multiple changed entrypoints, run the validator on each important file instead of assuming one passing bundle covers the whole host layer.
- Treat `package.json` warnings like `"type": "2d"` as environment noise unless they break the bundle.

### Edit prefab and scene assets carefully

- Prefer binding existing prefab child nodes by name from script components.
- When prefabization is in progress, use a hybrid approach: prefab owns stable hierarchy, script owns dynamic content and fallback creation.
- If hand-editing prefab JSON, keep `__id__` references consistent and verify the JSON parses after edits.
- Avoid large asset rewrites when a narrower skeletal prefab gets the migration moving.

## References

- CLI details: [references/cocos-cli.md](references/cocos-cli.md)
- Validation and prefab JSON guidance: [references/project-validation.md](references/project-validation.md)

## Scripts

- `scripts/check-cocos-env.sh <project-root>`
- `scripts/validate-cocos-entry.sh <entry.ts> [outfile]`
