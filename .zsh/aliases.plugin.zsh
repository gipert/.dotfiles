_get_ssh_config() {

    local host=`hostname | cut -f 1 -d.`
    local config="$HOME/.ssh/config"

    for f in \ls ~/.ssh/config.*; do
        local file=`basename "$f"`
        [[ "$file" == "config.common" ]] && continue
        [[ "$file" == "config.$host" ]] && config="$HOME/.ssh/config.$host"
    done

    echo "$config"
}

ssh() {
    if echo "$@" | \grep -Eq '^lngs-gerda*' && command -v sshpass > /dev/null; then
        command sshpass -f $HOME/.sshpass ssh -F "`_get_ssh_config`" "$@"
    else
        command ssh -F "`_get_ssh_config`" "$@"
    fi
}

rsync() {
    if echo "$@" | \grep -Eq 'lngs-gerda' && command -v sshpass > /dev/null; then
        command rsync -h --progress --rsh="sshpass -f $HOME/.sshpass ssh -F '`_get_ssh_config`'" "$@"
    else
        command rsync -h --progress --rsh="ssh -F '`_get_ssh_config`'" "$@"
    fi
}

mvim() {
    sed "s|Plug 'Valloric/YouCompleteMe'|\" Plug 'Valloric/YouCompleteMe'|g" ~/.vimrc > /tmp/minimal-vimrc
    vim -u /tmp/minimal-vimrc "$@"
}

docker() {
    if [[ "$1" == "run" ]]; then
        local mode=":"
        [[ `uname` == "Darwin" ]] && mode=":delegated"
        command docker run -v ${HOME}:${HOME}${mode} -w $PWD --rm -it "${@:2}"
    elif [[ "$1" == "build" ]]; then
        command docker build --rm "${@:2}"
    else
        command docker "$@"
    fi
}

dockerX11() {
    if [[ "$1" == "run" ]]; then
        ip=`ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'`
        xhost +$ip
        docker run -e DISPLAY=$ip:0 -v /tmp/.X11-unix:/tmp/.X11-unix "${@:2}"
        if [[ `command docker ps -a -q` == "" ]]; then
            xhost -$ip
        fi
    else
        docker "$@"
    fi
}

pip() {
    if [[ "$1" == "install" ]]; then
        command pip install --user "${@:2}"
    else
        command pip "${@}"
    fi
}
