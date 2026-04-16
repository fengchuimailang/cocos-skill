# Cocos CLI

Use this reference when a task should be handled with the local `cocos` CLI instead of guessing Creator behavior.

## Available commands on this machine

Local binary:

```bash
cocos
```

Top-level help currently exposes:

```text
build
create
make
run
start-mcp-server
```

## Command patterns

### Build

```bash
cocos build -j <project-root> -p <platform> [-c <build-config>] [--sdkPath <path>] [--ndkPath <path>]
```

Use for:

- producing `web-desktop` or `web-mobile` builds
- validating that Creator can consume the project end-to-end
- Android builds when SDK/NDK paths are available

Notes:

- `-j` is required for the project path
- `-p` should be explicit, such as `web-mobile`, `web-desktop`, `android`, or `ios`
- if the team keeps build config files, prefer `-c` over ad hoc flags
- run `scripts/check-cocos-env.sh <project-root>` first when Node, `cocos`, or project metadata may be mismatched

### Run

```bash
cocos run -p <platform> -d <build-output-dir>
```

Use for:

- running a previously built target
- follow-up execution after a successful CLI build

Notes:

- this command expects build output, not just the source project
- use it after `cocos build`, not as a replacement for build

### Start MCP server

```bash
cocos start-mcp-server -j <project-root> [-p <port>]
```

Use for:

- starting the Cocos MCP bridge for tool-assisted workflows
- exposing a local project to MCP-aware agents or integrations

Default port:

```text
9527
```

### Create / Make

Use `cocos create` for new projects and `cocos make` for native project generation when the task is project bootstrapping rather than editing an existing game.

## Decision rule

- Use `cocos` CLI for project lifecycle operations.
- Use shell reads and targeted file edits for script, prefab, and scene changes.
- Use lightweight bundling validation when full Creator compilation is blocked by environment issues.
- Prefer reporting missing local prerequisites over guessing that Creator can build anyway.
