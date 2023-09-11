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

    # FIXME: bspc monitor -r does not work!

    local scale=1
    if [[ "$1" == "--scale" ]]; then
        scale=$2
        shift 2
    fi

    local builtin_s='eDP1'
    local external_s=${2:-HDMI1}

    # don't do anything if the built-in monitor is not connected
    is_monitor_connected ${builtin_s} || return 1

    # kill all bars
    polybar-msg cmd quit

    case "$1" in

        office)
            local main_s='DP2' # DP2 | DVI-I-2-2
            local vert_s='HDMI1'

            # turn on built-in and kill all the others
            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            # bspc monitor any -r
            bspc monitor ${builtin_s} -d external

            if is_monitor_connected ${main_s}; then
                xrandr --output ${main_s} --auto --mode 3840x2160 --right-of ${builtin_s}
                MONITOR=${main_s} polybar thinkpad & disown
                bspc monitor ${main_s} -d I II III IV V VI VII VIII IX X XI XII
            fi

            if is_monitor_connected ${vert_s}; then
                xrandr --output ${vert_s} --auto --scale 1.5 --rotate left --right-of ${main_s}
                MONITOR=${vert_s} polybar vertical & disown
                bspc monitor ${vert_s} -d vertical
            fi

            xbacklight -set 80
            setxkbmap us
            # xset r rate 300 40
            ;;

        external)
            is_monitor_connected ${external_s} || return 1

            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            # bspc monitor any -r
            bspc monitor ${builtin_s} -d external

            xrandr --output ${external_s} --auto --scale $scale --right-of ${builtin_s}
            MONITOR=${external_s} polybar thinkpad & disown
            bspc monitor ${external_s} -d I II III IV V VI VII VIII IX X XI XII
            ;;

        mirror)
            is_monitor_connected ${external_s} || return 1

            xrandr --output ${builtin_s} --auto
            xrandr --output ${external_s} --auto --scale $scale --same-as ${builtin_s}

            MONITOR=${builtin_s} polybar thinkpad & disown
            # bspc monitor any -r
            bspc monitor ${builtin_s} -d I II III IV V VI VII VIII IX X XI XII
            ;;

        movie)
            is_monitor_connected ${external_s} || return 1

            xrandr --auto --output ${external_s} --primary --auto --scale $scale
            MONITOR=${external_s} polybar thinkpad & disown
            # bspc monitor any -r
            bspc monitor ${external_s} -d I II III IV V VI VII VIII IX X XI XII

            xrandr --output ${builtin_s} --off
            ;;

        home)
            monitor_setup --scale 2 movie

            pacmd set-default-sink 3
            setxkbmap us
            # xset r rate 300 40
            ;;

        default | *)

            # shut all monitors off
            while IFS= read -r m; do
                echo "INFO: shutting off $m"
                xrandr --output $m --off
                bspc monitor $m -r
            done <<< "$(get_connected_monitors)"

            # switch builtin display on
            xrandr --output ${builtin_s} --auto
            MONITOR=${builtin_s} polybar thinkpad & disown
            # bspc monitor any -r
            bspc monitor ${builtin_s} -d I II III IV V VI VII VIII IX X XI XII

            setxkbmap de
            # xset r rate 300 40
            ;;
    esac
}

rand_wallpaper() {
    if command -v feh > /dev/null && [ -d ~/pictures/wallpapers ]; then
        img=$(ls ~/pictures/wallpapers/ | grep -E '.(png|jpe?g)'  | sort -R | tail -n 1)
        feh --bg-tile "$HOME/pictures/wallpapers/$img"
    fi
}
