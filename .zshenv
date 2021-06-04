# Usage: addpath <path> after|before <var>
addpath() {
    eval v="\$$3"

    if [[ "$v" == "" ]]; then
        eval export $3="$1"
        return
    fi

    case ":$v:" in
        *:"$1":*)
            ;;
        *)
            if [[ "$2" == after ]] ; then
                [[ "${v: -1}" == ':' ]] && eval $3="$v$1" || eval $3="$v:$1"
            elif [[ "$2" == before ]] ; then
                [[ "${v: -1}" == ':' ]] && eval $3="$1$v" || eval $3="$1:$v"
            fi
    esac
    eval export $3
}

if [[ `uname` == Darwin ]]; then
    # check this out:
    # https://unix.stackexchange.com/questions/246751/how-to-know-why-and-where-the-path-env-variable-is-set?

    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export EDITOR="vim"

[ -z "$SINGULARITY_CONTAINER" ] && [ -f ~/.zshenv_bis ] && source ~/.zshenv_bis

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
