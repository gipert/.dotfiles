shopt -s checkwinsize
function prompt_right() {
  echo -e "[\[\033[03;34m\]$(git branch 2>/dev/null | grep '^*' | sed s/..//)\[\033[00m\]]"
}

function prompt_left() {
  echo -e "\[\033[03;32m\]\h:\[\033[00m\]\W \[\033[01;31m\]$\[\033[00m\]"
}

function prompt() {
  compensate=20
  PS1=$(printf "%*s\r%s " "$(($(tput cols)+${compensate}))" "$(prompt_right)" "$(prompt_left)")
}
PROMPT_COMMAND=prompt

source ~/.alias
