export NVM_DIR="$HOME/.nvm"
# Lazy-load nvm — only runs when you first call nvm/node/npm
nvm() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; nvm "$@"; }
node() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@"; }
npm() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@"; }
npx() { unset -f nvm node npm npx; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@"; }

# Lazy-load Google Cloud SDK — only runs when you first call gcloud
gcloud() {
  unset -f gcloud
  [ -f '/Users/braxtonhall/google-cloud-sdk/path.zsh.inc' ] && . '/Users/braxtonhall/google-cloud-sdk/path.zsh.inc'
  [ -f '/Users/braxtonhall/google-cloud-sdk/completion.zsh.inc' ] && . '/Users/braxtonhall/google-cloud-sdk/completion.zsh.inc'
  \gcloud "$@"
}

alias remote='ssh braxtonh@remote.cs.ubc.ca'
alias ytmp3='youtube-dl --extract-audio --audio-format mp3'

# for i in *.MPG; do ffmpeg -i "$i" "${i%.*}.mp4"; done
# for i in *.mp4; do ffmpeg -i "$i" -vf scale=-1:144 -c:v libx264 -crf 18 
# -preset veryslow -c:a copy "${i%.*}_144.mp4"; done

#export VISUAL=/usr/bin/nvim
#ewrap
#"alacritty --command /usr/bin/nvim $*"
#export EDITOR=/usr/bin/nvim

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle :compinstall filename '/home/braxtonhall/.zshrc'

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
bindkey -v
# End of lines configured by zsh-newuser-install

# Use pure theme
autoload -U promptinit
promptinit
prompt pure
# This is required so that pinentry works for the GPG agent
# See https://github.com/sindresorhus/pure/issues/489
# See https://github.com/sindresorhus/pure/issues/366
#prompt_pure_async_tasks() {}

# See https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
zvm_after_init() {
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
}

export PATH="${PATH}:${HOME}/bin"

export PATH="$HOME/.local/bin:$PATH"

# Lazy-load ghcup — only runs when you first call ghcup
ghcup() { unset -f ghcup; [ -f "/Users/braxtonhall/.ghcup/env" ] && . "/Users/braxtonhall/.ghcup/env"; \ghcup "$@"; }
# opencode
export PATH=/Users/braxtonhall/.opencode/bin:$PATH

# Dotfiles bare git repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
