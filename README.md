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

```bash
brew install --cask statusbar
brew install --cask no-doze
brew install --cask curio
```

Casks track the latest GitHub release of each app and update via `brew upgrade --cask`.

## Formulae

| Formula | Description |
|---------|-------------|
| [`curator`](https://github.com/alexnodeland/curator) | Local-first knowledge plane: markdown vault + index + MCP for agents |

```bash
brew install alexnodeland/tap/curator
```
