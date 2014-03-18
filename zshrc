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
plugins=(bundler brew git powder rake textmate z heroku)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/Applications/Postgres.app/Contents/MacOS/bin:/usr/bin:/bin:/usr/sbin:/usr/local/share/npm/bin:/usr/X11/bin:/sbin:~/bin
export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules:$NODE_PATH

export SSL_CERT_FILE=/usr/local/etc/cacert.pem

function create_pull_request() {
  repo=$(printf '%s\n' "${PWD##*/}")
  branch=$(git symbolic-ref HEAD | cut -d'/' -f3)
  if [ "$1" != "" ]
  then
    title=$(echo "$1")
  else
    title=$(git log -1 --pretty=%B | head -1)
  fi
  hub pull-request -m "$title" -b $repo:develop -h $repo:$branch
}

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

function deploy() {
  git checkout master
  git merge develop
  git push origin master
  git push heroku master
}
