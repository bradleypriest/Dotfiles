export ZSH="$HOME/.oh-my-zsh"
export EDITOR=code

ZSH_THEME="robbyrussell"
plugins=(git mise)

# Keep local tools available after mise-managed runtimes.
typeset -U path fpath
path=(${path:#$HOME/.local/bin})
path+=("$HOME/.local/bin")

# Register installed completions before Oh My Zsh runs compinit.
if [[ -d "$HOME/.local/share/zsh/site-functions" ]]; then
  fpath=("$HOME/.local/share/zsh/site-functions" $fpath)
fi

source "$ZSH/oh-my-zsh.sh"

export BUNDLE_MAJOR_DEPRECATIONS=1

if [[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi
