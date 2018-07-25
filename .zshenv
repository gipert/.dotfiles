export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export MAKEFLAGS="-j20"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:/usr/lib64"
export EDITOR="vim"
export TERM="xterm-256color-italic"

[[ -f ~/.zshenv_bis ]] && source ~/.zshenv_bis
