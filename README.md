# plugin-refs

The remote-repo fetch backend for OpenCharly — the swappable download seam every
`@github` remote-candy fetch reaches.

`plugin-refs` owns the pluggable backend that turns a `(repoPath, version)` into a
populated local cache tree. The host keeps the fetch orchestration (local-override
resolution, cache-hit short-circuit, the post-fetch schema auto-migration via
`command:migrate`); this plugin owns only the download. It is a **compiled-in**
plugin candy (in the embedded `compiled_plugins:`), a separate Go module that
imports only the SDK — never charly core — so it composes the shared
`sdk/kit` git primitives (`GitResolveRef`/`GitClone`/`DownloadRepo`).

## What it provides

| Capability | Surface |
|---|---|
| `refs:refs` | the default refs downloader (`kit.RefsDownloader`) — fetches a remote repo via git into the repo cache |

Because the host dispatches every remote-repo fetch through the registered refs
provider, an alternative refs plugin can serve a different backend (OCI- or
S3-hosted candies) by registering a different `RefsDownloader`.

## How to use it

It is transparent to users: every `@github.com/<org>/<repo>/candy/<name>:<ref>`
candy ref resolved at config load goes through this backend. No authored
configuration is required.

## Layout

- `candy/plugin-refs/` — the plugin module: `plugin.go` (the provider +
  `NewMeta()`), `schema/refs.cue`, `go.mod` / `go.sum`.
- `charly.yml` — the root project manifest (`discover: candy`).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.

## Related

- Owning skill: `/charly-internals:plugin` — the plugin/provider model this
  backend follows. This candy carries no `skill:` entity of its own; the gap is
  tracked in
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- `/charly-internals:git-workflow` — the `@github` pin/landing discipline.
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI.
