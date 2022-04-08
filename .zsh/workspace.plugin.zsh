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

get_connected_monitors() {
    xrandr --query | grep '\bconnected\b' | awk '{print $1}' | grep -v '${builtin_s}'
}

is_monitor_connected() {
    for mon in "$@"; do
        if ! xrandr --query | grep ${mon} | grep ' connected ' &> /dev/null; then
            echo "ERROR: monitor ${mon} is not connected"
            return 1;
        fi
    done
}

monitor_setup() {

    local builtin_s='eDP1'
    local external_s=${2:-HDMI1}
    is_monitor_connected ${builtin_s} || return 1

    killall polybar

    case "$1" in

        office)
            local main_s='DP2'
            local vert_s='HDMI1'

            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            bspc monitor ${builtin_s} -d external

            if is_monitor_connected ${main_s}; then
                xrandr --output ${main_s} --auto --mode 3840x2160 --right-of ${builtin_s}
                MONITOR=${main_s} polybar thinkpad & disown
                bspc monitor ${main_s} -d I II III IV V VI VII VIII IX X XI XII
            fi

            if is_monitor_connected ${vert_s}; then
                xrandr --output ${vert_s} --auto --scale 2 --rotate left --right-of ${main_s}
                MONITOR=${vert_s} polybar vertical & disown
                bspc monitor ${vert_s} -d vertical
            fi
            ;;

        external)
            is_monitor_connected ${external_s} || return 1

            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            bspc monitor ${builtin_s} -d external

            xrandr --output ${external_s} --auto --scale 2 --right-of ${builtin_s}
            MONITOR=${external_s} polybar thinkpad & disown
            bspc monitor ${external_s} -d I II III IV V VI VII VIII IX X XI XII
            ;;

        mirror)
            is_monitor_connected ${external_s} || return 1

            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            bspc monitor ${builtin_s} -d I II III IV V VI VII VIII IX X XI XII

            xrandr --output ${external_s} --auto --scale 2 --same-as ${builtin_s}
            # bspc config bottom_padding -240
            ;;

        movie)
            is_monitor_connected ${external_s} || return 1

            xrandr --auto --output ${external_s} --auto --scale 2
            MONITOR=${external_s} polybar thinkpad & disown
            bspc monitor ${external_s} -d I II III IV V VI VII VIII IX X XI XII

            xrandr --output ${builtin_s} --off
            ;;

        default | *)

            # shut all monitors off
            while IFS= read -r m; do
                echo "INFO: shutting off $m"
                xrandr --output $m --off
            done <<< "$(get_connected_monitors)"

            # switch builtin display on
            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            bspc monitor ${builtin_s} -d I II III IV V VI VII VIII IX X XI XII
            ;;
    esac
}

rand_wallpaper() {
    if command -v feh > /dev/null && [ -d ~/pictures/wallpapers ]; then
        img=$(ls ~/pictures/wallpapers/ | grep -E '.(png|jpe?g)'  | sort -R | tail -n 1)
        feh --bg-tile "$HOME/pictures/wallpapers/$img"
    fi
}
