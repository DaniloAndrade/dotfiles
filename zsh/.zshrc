# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if GITHUB_TOKEN=$(security find-generic-password -a "$USER" -s GITHUB_PERSONAL_ACCESS_TOKEN -w 2>/dev/null); then
  export GITHUB_PERSONAL_ACCESS_TOKEN="$GITHUB_TOKEN"
fi

export PATH="$HOME/.local/bin:$PATH"


# Go Setup

export GOPATH=$HOME/go
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Go Setup end

# GPG
export GPG_TTY=$(tty)
#

# Editor padrão (usado por git, yazi, crontab -e, etc.)
export EDITOR=hx
export VISUAL=hx

# `hx` sem argumento, com "." ou com um diretório abre o yazi para escolher
# um arquivo antes de editar. Com um arquivo (ou múltiplos argumentos), passa
# direto pro binário real (git/crontab/etc. sempre chamam $EDITOR com um path
# de arquivo, então nunca disparam esse fallback).
hx() {
  local target="${1:-.}"

  if [ $# -gt 1 ] || { [ $# -eq 1 ] && [ ! -d "$target" ]; }; then
    command hx "$@"
    return
  fi

  local chooser
  chooser=$(mktemp)
  yazi "$target" --chooser-file="$chooser"

  if [ -s "$chooser" ]; then
    command hx "$(cat "$chooser")"
  fi
  rm -f "$chooser"
}


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Pinado em v3.9.0 (release estável mais recente) em vez do HEAD do branch
# default, para não rodar código não revisado no primeiro clone.
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone --branch v3.9.0 --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1 ver'v1.9.1'; zinit light romkatv/powerlevel10k

# Add in zsh plugins (pinados em tags estáveis em vez do HEAD do branch default)
zinit ice ver'0.8.0'; zinit light zsh-users/zsh-syntax-highlighting
zinit ice ver'0.9.0'; zinit light zsh-users/zsh-completions
zinit ice ver'v0.7.1'; zinit light zsh-users/zsh-autosuggestions
zinit ice ver'v1.3.0'; zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

autoload -U compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


#Keybindings
bindkey -e 
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'

# Aliases
alias vim=nvim
alias python=python3

alias ls='eza --color=always --icons=always --group-directories-first'
alias ll='eza -lah --color=always --icons=always --group-directories-first --git'
alias lt='eza --tree --color=always --icons=always --group-directories-first --level=2'
alias c='clear'

# bat
export BAT_THEME="Dracula"
alias cat='bat --pager=never'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# fd + fzf integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(navi widget zsh)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Added by Antigravity
export PATH="${HOME}/.antigravity/antigravity/bin:$PATH"

# direnv
eval "$(direnv hook zsh)"
