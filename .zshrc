# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# history
HISTFILE="$HOME/.zhistory"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# completion
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES

# install zplug
if [[ ! -f ~/.zplug/init.zsh ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

source ~/.zplug/init.zsh

zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "plugins/extract",           from:oh-my-zsh
zplug "plugins/git",               from:oh-my-zsh
zplug "plugins/sudo",              from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

zplug "b4b4r07/enhancd"
zplug "supercrabtree/k"

os=`echo $(uname) | tr '[:upper:]' '[:lower:]'`
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*${os}*amd64*"

zplug "junegunn/fzf", use:"shell/*.zsh", defer:2

zplug "~/.zsh", from:local

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# keybinds
bindkey -v
bindkey "^A"     vi-beginning-of-line
bindkey '^[[A'   history-substring-search-up
bindkey '^[[B'   history-substring-search-down
bindkey '^[[3~'  delete-char
bindkey '^[3;5~' delete-char
bindkey '\e[3~'  delete-char
bindkey -r '^[' # Alt+key does not trigger vi-cmd-mode anymore

# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# eval dircolors
[[ -f $HOME/.dircolors ]] && eval "$(dircolors "$HOME/.dircolors")"

# highlighting
[[ -f $HOME/.highlight.zsh ]] && source "$HOME/.highlight.zsh"

# aliases
[[ -f $HOME/.alias ]] && source $HOME/.alias

# load powerlevel10k
if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
  [[ ! -f ~/.zsh/p10k-console.zsh ]] || source ~/.zsh/p10k-console.zsh
fi

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=singularity_venv
POWERLEVEL9K_SINGULARITY_VENV_BACKGROUND=blue
