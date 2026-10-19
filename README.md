# Dotfiles

Mise manages Git, zsh, Ruby, mise, and VS Code settings in this repository.
Keep the checkout at `~/.dotfiles`, outside Dropbox, so apps can use the settings
without reading Dropbox.

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

Mise copies the files declared in `mise.toml` into your home directory. Back up existing files before applying.
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
git add gitconfig gitattributes gitignore_global zshrc zprofile gemrc irbrc railsrc mise vscode
git commit -m "Update configuration"
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

## Shell configuration

The zsh configuration expects an existing [Oh My Zsh](https://ohmyz.sh/)
installation at `~/.oh-my-zsh`. It uses the `robbyrussell` theme and the built-in
Git and mise plugins. Homebrew is loaded from `/opt/homebrew` for Apple Silicon
Macs, and `code` is the default editor.

Local CLI tools remain available from `~/.local/bin` after mise-managed runtimes.
Completions installed in `~/.local/share/zsh/site-functions` are registered before
Oh My Zsh initializes completion. The Tailscale app alias is added when installed.
Start a new terminal after applying shell changes.

## Ruby configuration

Ruby versions are managed by mise. IRB uses its default settings, with an
`enable_logging!` helper to send Active Record SQL logs to the console.
The old gem-loading helpers and Pry/Hirb customization have been removed.

`gemrc` disables documentation generation during gem installation. `railsrc`
uses PostgreSQL for new apps, skips automatic bundle installation, and skips
Jbuilder, Thruster, and Kamal setup.

Mise removes `~/.pryrc` and `~/.rvmrc` when applying the configuration.

## Mise and VS Code settings

`mise/config.toml` is copied to `~/.config/mise/config.toml`. It contains global
runtime choices and mise options. The repository's root `mise.toml` declares
which dotfiles to install.

`vscode/settings.json` is copied to
`~/Library/Application Support/Code/User/settings.json` on macOS. It contains
editor preferences and Ruby LSP settings. VS Code can update its installed copy,
so capture changes with `mise dot add --changed --no-apply` before applying the
repository version again.

## Older configuration

Alfred, Sublime Text, iTerm, HexColorPicker, and Inconsolata files have been
removed. Their committed versions remain available in Git history. Mise also
removes the old HexColorPicker installation from `~/Library/ColorPickers`.

Legacy Ember, Vim, and IMDB workflow files have also been removed. Mise removes
the broken `~/.ember-cli` link.

The old `bootstrap.rb` command runs mise for the declared configuration files.
