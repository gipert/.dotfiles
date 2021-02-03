rdocs() {
    if [[ "$1" == "TMath" ]]; then
        $BROWSER https://root.cern.ch/doc/v622/namespace$1.html
    else
        $BROWSER https://root.cern.ch/doc/v622/class$1.html
    fi
}

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
    if echo "$@" | \grep -Eq '^gerda-lngs*'; then
        command sshpass -f $HOME/.sshpass ssh -F "`_get_ssh_config`" "$@"
    else
        command ssh -F "`_get_ssh_config`" "$@"
    fi
}

rsync() {
    if echo "$@" | \grep -Eq 'gerda-lngs'; then
        command rsync -h --progress --rsh="sshpass -f $HOME/.sshpass ssh -F '`_get_ssh_config`'" "$@"
    else
        command rsync -h --progress --rsh="ssh -F '`_get_ssh_config`'" "$@"
    fi
}

mvim() {
    sed "s|Plug 'Valloric/YouCompleteMe'|\" Plug 'Valloric/YouCompleteMe'|g" ~/.vimrc > /tmp/minimal-vimrc
    vim -u /tmp/minimal-vimrc "$@"
}

docker2sing() {
    docker run \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v $PWD:/output \
        --privileged -t --rm \
        singularityware/docker2singularity --name "image" $1 && \
    sudo chown `whoami`:`id -gn` "image.simg" && \
    mv image.simg $2
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

music() {
    if [[ `hostname` == "hackintosh" ]]; then
        if [[ "$1" == "--enable" ]]; then

            if ! ssh -q -O check gate-infn; then
                echo "INFO: setting up proxy..."
                ssh -fN gate-infn
            fi

            if ! ps aux | grep sshfs | grep -q /home/gipert/music; then
                echo "INFO: mounting remote music library..."
                sshfs gipert@localhost:/data/pertoldi/music ~/music -p 9093 -o idmap=user,ro
            fi

            if ! ps aux | grep -q ' [m]pd'; then
                echo "INFO: starting MPD server..."
                mpd
            fi

            if ! ps aux | grep polybar | grep -q music; then
                echo "INFO: enabling music bar..."
                bspc config -m eDP1 bottom_padding 29 && \
                polybar music &> ~/.config/polybar/music.log & disown && \
                echo $! > ~/.config/polybar/polybar.pid
            fi

        elif [[ "$1" == "--disable" ]]; then
            echo "INFO: killing the MPD server..."
            mpd --kill
            echo "INFO: removing the music bar..."
            kill -s TERM `cat ~/.config/polybar/polybar.pid`
            bspc config bottom_padding -7
            rm -f ~/.config/polybar/polybar.pid
            echo "INFO: unmounting music library..."
            fusermount3 -u ~/music
        else
            echo "ERROR: unsupported option '$1'"
        fi
    else
        echo "ERROR: works only on 'hackintosh'"
    fi
}

# duplicate_monitor <screen> <position>
duplicate_monitor() {
    xrandr --output eDP1 --auto --output $1 --$2 eDP1 --auto
    bspc monitor $1 -d external
    pkill -xf 'polybar hackintosh_ext'
    MONITOR=$1 polybar hackintosh_ext & disown
}

# vim: syntax=sh
