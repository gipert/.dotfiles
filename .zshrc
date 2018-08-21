zstyle ':completion:*' rehash true
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# OH-MY-ZSH
ZSH="$HOME/.oh-my-zsh"
DEFAULT_USER="pertoldi"
plugins=( \
#         cp \
         git \
         rsync \
         colored-man-pages \
         colorize \
         docker \
         history \
         history-substring-search \
         zsh-navigation-tools \
         sudo \
         zsh-autosuggestions \
         zsh-syntax-highlighting \
         )

if [ -z "$DISPLAY" ]; then
    plugins=("${(@)plugins:#zsh-autosuggestions}")
else
    # powerlevel9k plugin
    ZSH_THEME="powerlevel9k/powerlevel9k"
    [ -f $HOME/.p9krc ] && source $HOME/.p9krc
fi

DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh

# eval dircolors
[ -f $HOME/.dircolors ] && eval "$(dircolors "$HOME/.dircolors")"

# Highlighting
[ -f $HOME/.highlight.zsh ] && source "$HOME/.highlight.zsh"
[ -f $HOME/.alias ] && source $HOME/.alias

# Alternative prompt
if [ -z "$DISPLAY" ]; then
    PROMPT='[%F{red}%B%n%b%f@%M %~]'
    PROMPT+='$(git_prompt_info)'
    PROMPT+=' %(?.%F{cyan}.%F{red})%B%(!.#.$)%b%f '
    ZSH_THEME_GIT_PROMPT_PREFIX=" [%F{yellow}%B"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f]"
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}%B*%b%f"
    ZSH_THEME_GIT_PROMPT_CLEAN=""
    unset TERM  # any value of TERM breaks the prompt in tty :(
fi
