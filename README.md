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

## Additional Considerations

To keep specific snippets from the original `.bashrc`, consider adding them to
`~/.bash.d/00-defaults.sh`.

The `.gitconfig` file includes an additional `~/.gitconfig.local`. This was
added to keep sensitive information like email addresses from being made
public, e.g. in repositories like this. Just remove the `[include]` statement
if that is not required.
