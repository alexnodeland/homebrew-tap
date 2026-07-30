# homebrew-tap

Homebrew tap for [alexnodeland](https://github.com/alexnodeland) projects.

```bash
brew tap alexnodeland/tap
```

## Casks

| Cask | Description |
|------|-------------|
| [`statusbar`](https://github.com/alexnodeland/StatusBar) | Monitor status pages from the macOS menu bar — also links the bundled `statusbar` CLI onto your PATH |
| [`no-doze`](https://github.com/alexnodeland/no-doze) | Keep your Mac awake from the menu bar (a free caffeinate wrapper) |
| [`curio`](https://github.com/alexnodeland/curio-rss) | Local-first RSS reader |
| [`tome`](https://github.com/alexnodeland/tome) | Personal library for technical documentation — also links the bundled `tome` CLI onto your PATH |

```bash
brew install --cask statusbar
brew install --cask no-doze
brew install --cask curio
brew install --cask tome
```

Casks are pinned to a version and a checksum, and
[`.github/workflows/bump.yml`](.github/workflows/bump.yml) moves both when the upstream project
publishes a release. `brew upgrade --cask` then picks them up.

> This used to be `version :latest` with `sha256 :no_check`, and the sentence above was not true
> of it: **`brew upgrade` skips `:latest` casks unless you pass `--greedy`**, so an installed app
> would sit at whatever version it was installed at. Pinning also restores the checksum, which for
> unsigned apps is the only integrity check between GitHub's CDN and the machine installing them.

Every app in this tap is **unsigned and un-notarized**, so macOS Gatekeeper blocks the first
launch. Each cask's `caveats` carries the fix.

## Formulae

| Formula | Description |
|---------|-------------|
| [`curator`](https://github.com/alexnodeland/curator) | Local-first knowledge plane: markdown vault + index + MCP for agents |

```bash
brew install alexnodeland/tap/curator
```
