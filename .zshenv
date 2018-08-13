if [[ `uname` == Darwin ]]; then
    # check this out:
    # https://unix.stackexchange.com/questions/246751/how-to-know-why-and-where-the-path-env-variable-is-set?

    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:/usr/lib64"
export EDITOR="vim"

[ -f ~/.zshenv_bis ] && source ~/.zshenv_bis
