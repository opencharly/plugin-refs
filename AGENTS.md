# AGENTS.md — plugin-refs

Standalone plugin repo for the remote-repo fetch backend (`refs:refs`). The
plugin is a Go module at `candy/plugin-refs/` (module path
`github.com/opencharly/plugin-refs/candy/plugin-refs`); the root `charly.yml`
only declares `discover: candy` so the repo is a project and its candy is
scanned.

Canonical files:

- `candy/plugin-refs/charly.yml` — the `plugin-refs:` candy entity (`plugin:`
  block, `plan:` check).
- `candy/plugin-refs/plugin.go` — the refs downloader implementation
  (`kit.RefsDownloader.Download`) + `NewMeta()`.
- `candy/plugin-refs/schema/refs.cue` — the self-contained input schema.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-internals:plugin` — the plugin authoring reference: the `plugin:`
  block, the unified Provider model, the per-plugin CUE-schema contract,
  placement. Load before touching the provider or schema.
- `/charly-internals:git-workflow` — the `@github` pin/fetch discipline and
  before any git/PR action.

## Build / validate / test

- `go build ./...` in `candy/plugin-refs/` — compile the plugin module.
- `go test ./...` in `candy/plugin-refs/` — the plugin's Go tests
  (`schema_serve_test.go`).
- `charly box validate` at the repo root — the structural check (the candy +
  `plugin:` block, CUE schema).
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate.
- There is no dedicated live bed: the git fetch backend is exercised by every
  remote `@github` ref resolution at config load.

## Modify this repo

- Edit the `plugin-refs:` candy entity, the Go source, and `schema/refs.cue`
  **together** — the schema is the single source for the generated types.
- The plugin is **compiled-in** (listed in the embedded `compiled_plugins:`); it
  imports only the SDK, never charly core.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
