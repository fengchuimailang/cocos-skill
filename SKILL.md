---
name: cocos-skill
description: Work on Cocos Creator 3.8+ projects that use `cc` TypeScript scripts, `.prefab` or `.scene` assets, `creator.d.ts`, build templates, and the local `cocos` CLI. Use when Codex needs to inspect or edit Cocos project structure, validate host-side TypeScript entrypoints, manipulate prefab or scene JSON carefully, debug Creator environment mismatches, or run `cocos build`, `cocos run`, or `cocos start-mcp-server` for `web-mobile`, `web-desktop`, Android, or iOS workflows.
---

# Cocos Skill

## Version Support

This skill targets **Cocos Creator 3.8+**.

## Overview

Use the local `cocos` CLI first for environment discovery and host-side workflows. Keep gameplay truth in code modules, treat scene and prefab assets as host structure, and validate script changes with a lightweight bundling pass when full Creator type-checking is unavailable.

## Quick Start

1. Identify the project root.
2. Pick the narrowest workflow that matches the task.
3. Read only the reference files needed for that workflow.
4. Run the smallest validating script that can catch the likely failure mode.

## Workflow Selection

| Task shape | Read first | Run first |
| --- | --- | --- |
| Build, run, or MCP bridge work | [references/cocos-cli.md](references/cocos-cli.md) | `scripts/check-cocos-env.sh <project-root>` |
| TypeScript host-side edits or broken imports | [references/project-validation.md](references/project-validation.md) | `scripts/validate-cocos-entry.sh <entry.ts>` |
| `.prefab` or `.scene` JSON edits | [references/project-validation.md](references/project-validation.md) | `scripts/validate-cocos-json.sh <asset.json>` |
| Unclear local Creator setup | [references/cocos-cli.md](references/cocos-cli.md) | `scripts/check-cocos-env.sh <project-root>` |

## Quick Reference

### Scripting

- [Life Cycle Callbacks](references/docs/3.8/en/scripting/life-cycle-callbacks.md) - `onLoad`, `start`, `update`, `onDisable`, `onDestroy`
- [Decorator Reference](references/docs/3.8/en/scripting/decorator.md) - `@ccclass`, `@property`, `@requireComponent`
- [Node/Component Access](references/docs/3.8/en/scripting/access-node-component.md) - `find()`, `getComponent()`
- [Component Basics](references/docs/3.8/en/scripting/component.md) - Creating and using components
- [Scheduler](references/docs/3.8/en/scripting/scheduler.md) - Timers and scheduled callbacks

### Assets

- [Prefab Guide](references/docs/3.8/en/asset/prefab.md) - Create, instantiate, nest prefabs
- [Dynamic Loading](references/docs/3.8/en/asset/dynamic-load-resources.md) - `resources.load()` usage
- [Asset Manager](references/docs/3.8/en/asset/asset-manager.md) - Asset loading and management
- [Bundle System](references/docs/3.8/en/asset/bundle.md) - Remote bundles and on-demand loading
- [Sprite Frame](references/docs/3.8/en/asset/sprite-frame.md) - Sprite frame assets

### UI Components

- [Label](references/docs/3.8/en/ui-system/components/engine/label-layout.md) - Text display
- [Sprite](references/docs/3.8/en/ui-system/components/engine/sliced-sprite.md) - Image display
- [Button](references/docs/3.8/en/ui-system/components/engine/usage-ui.md) - Button interactions
- [Layout](references/docs/3.8/en/ui-system/components/engine/auto-layout.md) - Auto layout
- [Widget Align](references/docs/3.8/en/ui-system/components/engine/widget-align.md) - Widget alignment

### 中文文档

- [脚本系统](references/docs/3.8/zh/scripting/)
- [资源管理](references/docs/3.8/zh/asset/)
- [UI 组件](references/docs/3.8/zh/ui-system/components/engine/)

## Workflow

### Inspect the project

- Confirm there is a Cocos project by checking for `package.json` with a `creator.version`, `assets/`, `settings/`, and `tsconfig.json`.
- Prefer reading `assets/script/`, `assets/resources/`, `assets/scenes/`, `extensions/`, `build-templates/`, and any generated `creator.d.ts` inputs before changing host-side logic.
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
- If `esbuild` is unavailable, fall back to the reference guidance instead of pretending TypeScript validation succeeded.

### Edit prefab and scene assets carefully

- Prefer binding existing prefab child nodes by name from script components.
- When prefabization is in progress, use a hybrid approach: prefab owns stable hierarchy, script owns dynamic content and fallback creation.
- If hand-editing prefab or scene JSON, keep `__id__` references consistent and verify the JSON parses after edits with `scripts/validate-cocos-json.sh`.
- Avoid large asset rewrites when a narrower skeletal prefab gets the migration moving.

## References

- CLI details: [references/cocos-cli.md](references/cocos-cli.md)
- Validation and prefab JSON guidance: [references/project-validation.md](references/project-validation.md)
- Full documentation: `references/docs/3.8/en/`
- 中文文档: `references/docs/3.8/zh/`

## Scripts

- `scripts/check-cocos-env.sh <project-root>` - Check Cocos environment
- `scripts/validate-cocos-entry.sh <entry.ts> [outfile]` - Validate TypeScript entry
- `scripts/validate-cocos-json.sh <asset.json>` - Validate prefab/scene JSON
- `scripts/update-docs.sh <cocos-docs-path> [version]` - Update documentation
- `scripts/validate-docs-links.sh` - Validate documentation links

## Upgrading Documentation

When Cocos Creator releases a new version:

```bash
# Update docs from local cocos-docs repository
./scripts/update-docs.sh /path/to/cocos-docs 3.9

# Validate all links
./scripts/validate-docs-links.sh
```
