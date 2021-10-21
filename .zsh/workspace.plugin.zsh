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

monitor_setup() {
    case "$1" in
        office)
            xrandr --output eDP1 --auto --output HDMI1 --auto --scale 2x2 --right-of eDP1
            killall polybar
            MONITOR=HDMI1 polybar thinkpad & disown
            MONITOR=eDP1 polybar thinkpad & disown
            bspc monitor HDMI1 -d I II III IV V VI VII VIII IX X XI XII
            bspc monitor eDP1 -d external
            ;;
        mirror)
            xrandr --output "$2" --auto --scale 2x2 --same-as eDP1
            bspc config bottom_padding -240
            ;;
        default | *)
            ext_monitors=$(xrandr --query | grep '\bconnected\b' | awk '{print $1}' | grep -v 'eDP1')
            while IFS= read -r m; do
                xrandr --output $m --off
            done <<< "$ext_monitors"
            killall polybar
            MONITOR=eDP1 polybar thinkpad & disown
            bspc monitor eDP1 -d I II III IV V VI VII VIII IX X XI XII
            ;;
    esac
}

rand_wallpaper() {
    if command -v feh > /dev/null && [ -d ~/pictures/wallpapers ]; then
        img=$(ls ~/pictures/wallpapers/ | grep -E '.(png|jpe?g)'  | sort -R | tail -n 1)
        feh --bg-tile "$HOME/pictures/wallpapers/$img"
    fi
}
