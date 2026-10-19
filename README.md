# Dotfiles

Mise manages the Git configuration in this repository. Keep the checkout at
`~/.dotfiles`, outside Dropbox, so apps can use Git without reading Dropbox.

## Set up a machine

Install [mise](https://mise.jdx.dev/getting-started.html), then clone the repository
and preview the files mise will copy:

```sh
git clone git@github.com:bradleypriest/Dotfiles.git ~/.dotfiles
cd ~/.dotfiles
mise trust
mise dot diff
mise dot apply --dry-run
mise dot apply
mise dot status
```

Mise copies `gitconfig`, `gitattributes`, and `gitignore_global` into the matching
hidden files in your home directory. Back up existing files before applying.
If mise reports a conflict, compare the files before using `mise dot apply --force`.

For an existing Dropbox setup, back up both each symlink and its contents before
replacing the symlinks. The files Git reads must be ordinary local files.

## Edit and share settings

Edit the sources in this repository, preview the changes, and apply them:

```sh
cd ~/.dotfiles
$EDITOR gitconfig
mise dot diff
mise dot apply
mise dot status
git diff
git add gitconfig gitattributes gitignore_global
git commit -m "Update Git settings"
git push
```

If an app edits one of the installed copies, inspect the changes with
`mise dot diff`. Capture the edits with `mise dot add --changed --no-apply`, then
review `git diff` before committing. Applying without capturing those edits
replaces them with the repository version.

On another machine, pull and apply the changes:

```sh
cd ~/.dotfiles
git pull --ff-only
mise dot diff
mise dot apply
```

The repository is public, so review each commit for private settings. Automatic
history syncing is not enabled.

## Older configuration

The shell, Ruby, editor, and app settings remain in the repository for reference.
Mise currently applies only the three Git files. The old `bootstrap.rb` command
now runs mise for those files, and no longer installs the older configuration.
