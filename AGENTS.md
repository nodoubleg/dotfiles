# Codex note: this file gives the agent needed repo context so Codex can follow my personal dotfile workflow without guessing.
# Repository Guidelines
This repo exists purely for my own dotfiles sync—`.zshrc`, `.vimrc`, SpaceVim configs, LaunchAgent plists, and any other config I am comfortable pushing to GitHub. No team standards or review gates; these notes just remind future-me how things are laid out.

## Project Structure & Module Organization
Dotfiles stay at repo root so they can be symlinked straight into `$HOME`. Shell helpers (`clonemebro.sh`, `linkmebro.sh`) sit next to hidden configs like `.SpaceVim.d/`, `.vimrc.local`, and `init.toml`. GUI exports (Alfred, iTerm2, Moom) live as plist/json dumps, while fonts and binaries rest under `shameless_blobs/` to quarantine bulk assets.

## Build, Test, and Development Commands
- `./linkmebro.sh` — nukes/recreates symlinks, reclones SpaceVim, and copies LaunchAgents; run after tweaking tracked dotfiles.
- `./clonemebro.sh` — prints the bootstrap checklist for new boxes; update it whenever dependencies move.
- `zsh -n .zshrc` / `zsh -fic "source .zshrc"` — sanity check before pushing a risky shell tweak.
- `nvim --headless +"source init.vim" +q` — confirms Vim configs still load.

## Coding Style & Naming Conventions
It’s the wild west, but a few habits help: scripts default to Bash shebangs, two-space indents, and `set -euo pipefail` when destructive. File names mirror the destination dotfile (`.gvimrc`, `.vimrc.before.local`) so `linkmebro.sh` stays predictable. macOS-specific tweaks belong behind `uname` guards or in dedicated plists.

## Testing Guidelines
No formal suite—just run whatever manual checks feel right. `shellcheck` catches obvious script mistakes, `:checkhealth` in Neovim spots plugin regressions, and re-importing plist/json files ensures macOS tools still accept them. When touching fonts or binaries, open the target app once to confirm it sees the new assets.

## Commit & Pull Request Guidelines
Commit however I like; terse lower-case subjects match existing history but nothing enforces it. I usually push straight to `main` without PRs, and if one ever appears it only needs a line explaining the change (“update Moom presets”, “swap SpaceVim theme”) so future-me remembers why. No issue links or reviews needed—ship when it works locally.

## Personal Workflow Tips
After pulling on a new host: run `./linkmebro.sh`, launch iTerm2 once to import profiles, and open Neovim so SpaceVim finishes installing. Keep sensitive data out of the repo; layer secrets via `~/.sensitive_include` as referenced in `.zshrc`. When macOS `defaults` calls fail (missing app, etc.), just comment the line instead of over-engineering guards.
