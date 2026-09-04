# dotfiles

Dotfiles for Linux, managed by GNU `stow`.

Please use only if you know what you're doing.

## Installation

This repository uses GNU `stow` for symlinking the scripts and configurations
to the user's home directory.

To install all modules, run `stow bash scripts git`. If `stow` complains about
paths already existing (especially `.bashrc` and `.gitconfig`), you need to
decide how to handle those. In my particular case, I moved them out of the way
(e.g., `mv ~/.bashrc ~/.bashrc.orig`) before running `stow`.

This was only tested on Ubuntu, specifically Ubuntu Server 24.04. Use at your
own risk on any other distribution.

## Upgrading

After adding new files or modifiying any of the existing ones, run
`stow -R bash script git` (or any subset of the targets). This will "restow",
and thereby apply the changes.

## Additional Considerations

To keep specific snippets from the original `.bashrc`, consider adding them to
`~/.bash.d/00-defaults.sh`.

The `.gitconfig` file includes an additional `~/.gitconfig.local`. This was
added to keep sensitive information like email addresses from being made
public, e.g. in repositories like this. Just remove the `[include]` statement
if that is not required.

## Using `pre-commit` hooks

I am using `pre-commit` together with `shellcheck`. `pre-commit` is available
via `apt` on Ubuntu, but it seems to have a lot of additional dependencies.
Instead, I chose to install it via `uv tool`, as I have `uv` available for
Python projects already.

```bash
uv tool install pre-commit
```
