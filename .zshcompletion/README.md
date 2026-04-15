Custom zsh completion functions live here.

Add one file per command, typically named with a leading underscore, for example:

- `_kubectl`
- `_terraform`
- `_mytool`

`linkmebro.sh` symlinks this directory to `~/.zshcompletion`, and `.zshrc`
already prepends that path to `fpath` before `compinit` runs.
