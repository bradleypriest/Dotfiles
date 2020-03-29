# Path to your oh-my-zsh configuration.

export ZSH=$HOME/.oh-my-zsh
export EDITOR=subl
# eval "$(hub alias -s)"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(bundler brew git rake z heroku)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/Applications/Postgres.app/Contents/Versions/latest/bin:/usr/bin:/bin:/usr/sbin:/usr/local/share/npm/bin:/usr/X11/bin:/sbin:~/bin

export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules:$NODE_PATH
export CDPATH=$CDPATH:~/Sites

export UNBUNDLED_COMMANDS=foreman

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/bradleypriest/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# Creates a Pull Request from the currently checked out branch
#
# @example
#   create_pull_request
#     # => Creates a PR with the last commit's message as title prefixed with WIP
#   create_pull_request "Shiny new flux capacitor"
#     # => Creates a PR with the provided title
function create_pull_request() {
  # Get branch name
  branch=$(git symbolic-ref HEAD | cut -d'/' -f3 -f4)
  # Check if a title was provided
  if [ "$1" != "" ]
  then
    title=$(echo "$1")
  else
    title=$(git log -1 --pretty=%B)
  fi
  # Target PR to develop branch if exists, otherwise master
  if [ "$(git branch | grep develop)" ]
  then
    target="develop"
  else
    target="master"
  fi
  url=$(hub pull-request -m "$title" -b tradegecko:$target -h tradegecko:$branch)
  echo $url | pbcopy
  open $url
}

# Opens the Compare View on Github for the currently checked-out branch
#
# @example
#   open_compare
#     # => Opens the compare view in your browser
function open_compare() {
  # Get branch name
  branch=$(git symbolic-ref HEAD | cut -d'/' -f3 -f4)
  # Target develop branch if exists, otherwise master
  if [ "$(git branch | grep develop)" ]
  then
    target="develop"
  else
    target="master"
  fi
  hub compare $target...$branch
}

function nom {
  rm -rf node_modules && npm cache clear --force && npm install --production --no-optional
}

# Fuzzy checkout
function gcoo() {
  git branch | grep $1 | xargs -n 1 git checkout
}

# Modified slightly from https://gist.github.com/zeroeth/8013177
function git-branch-status() {
  if [ "$(git branch | grep develop)" ]
  then
    target="develop"
  else
    target="master"
  fi

  git for-each-ref --format="%(refname:short) %(upstream:short)" refs/heads | \
  while read local remote
  do
      if [ -x $remote ]; then
          branches=("$local")
      else
          branches=("$local" "$remote")
      fi;
      for branch in ${branches[@]}; do
          target="$target"
          git rev-list --left-right ${branch}...${target} -- 2>/dev/null >/tmp/git_upstream_status_delta || continue
          LEFT_AHEAD=$(grep -c '^<' /tmp/git_upstream_status_delta)
          RIGHT_AHEAD=$(grep -c '^>' /tmp/git_upstream_status_delta)

      COLOR="MEOW"
      if [ "$LEFT_AHEAD" -eq "0" ]; then
        if [ "$RIGHT_AHEAD" -eq "0" ]; then
          # NOTHING NEW AND EQUAL
          COLOR="\033[0;35m-"
        else
          # NOTHING NEW AND BEHIND
          COLOR="\033[0;33m↓"
        fi;
      else
        if [ "$RIGHT_AHEAD" -eq "0" ]; then
          # NEW AND UP TO DATE
          COLOR="\033[0;32m↑"
        else
          # NEW AND BEHIND
          COLOR="\033[0;31m↕"
        fi;
      fi;
        # printf "$COLOR %-40s (ahead %2d) | (behind %4d) $target\n" $branch $LEFT_AHEAD $RIGHT_AHEAD
        printf "$COLOR %-40s | (behind %5d)\n" $branch $RIGHT_AHEAD
      done
  done | grep -v "^develop" | grep -v "master" | grep -v "origin" | uniq | sort -rsk 4
}

export TRADEGECKO_LOGIN_ID=13
export BUNDLE_MAJOR_DEPRECATIONS=1
export JS_DRIVER=chrome
