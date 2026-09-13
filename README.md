# dotfiles

Dotfiles for Linux, managed by GNU `stow`.

Please use only if you know what you're doing.

## Installation

This repository uses GNU `stow` for symlinking the scripts and configurations
to the user's home directory. The `deploy.sh` script wraps the `stow` command
and uses the repository as its source directory.

To install all modules, run:

```bash
./deploy.sh
```

If `stow` complains about
paths already existing (especially `.bashrc` and `.gitconfig`), you need to
decide how to handle those. In my particular case, I moved them out of the way
(e.g., `mv ~/.bashrc ~/.bashrc.orig`) before running `./deploy.sh`.

This was only tested on Ubuntu, specifically Ubuntu Server 24.04. Use at your
own risk on any other distribution.

## Upgrading

After adding new files or modifying any of the existing ones, run
`./deploy.sh` to apply the changes again. Alternatively, use the `dot-sync`
function, defined in `bash/.bash.d/90-maintenance.sh`, to pull the latest
changes, run `deploy.sh`, and reload the active shell:

```bash
dot-sync
```

## Additional Considerations

To keep specific snippets from the original `.bashrc`, consider adding them to
`~/.bash.d/00-defaults.sh`.

The `.gitconfig` file includes an additional `~/.gitconfig.local`. This was
added to keep sensitive information like email addresses from being made
public, e.g. in repositories like this. Just remove the `[include]` statement
if that is not required.

## Using `pre-commit` hooks

I am using `pre-commit` together with `shellcheck`. Run it through `uvx` so it
does not need to be installed globally:

```bash
uvx pre-commit install
uvx pre-commit run --all-files
```

To check specific files manually, pass them with `--files`:

```bash
uvx pre-commit run --files path/to/file.sh
```
