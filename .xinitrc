#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
    xrdb -merge "$sysresources"
fi

if [ -f "$sysmodmap" ]; then
    xmodmap "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# wallpaper
[[ `command -v feh` ]] && feh --bg-tile $HOME/pictures/dark_exa_@2X.png

# adjust cursor speed
xset r rate 300 40

# mouse, set acceleration and threshold
# xset mouse 7 1

# select wm/de with: startx ~/.xinitrc session
session=${1:-bspwm}

# this to make xob work
if [[ `command -v xob` ]]; then
    rm -f /tmp/xobpipe
    mkfifo /tmp/xobpipe
    tail -f /tmp/xobpipe | xob &
fi

# start protonmail bridge
[[ `command -v protonmail-bridge` ]] && protonmail-bridge --noninteractive &

if [[ `hostname` == "lxpertoldi" ]]; then

    # start mpd server
    [[ `command -v mpd` ]] && mpd

    # mouse, set speed
    xinput set-prop 14 173 0.3 0.0 0.0 0.0 0.5 0.0 0.0 0.0 1.0

    # set monitors
    xrandr --output DP-2 --mode 1920x1080 --pos 0x1920    --rotate right \
           --output DP-1 --mode 1920x1080 --pos 1080x2300 --rotate normal

    xautolock -detectsleep \
        -time 5 -notify 30 \
        -notifier "notify-send -u normal -i /usr/share/icons/hicolor/48x48/apps/gcr-key-pair.png 'Security Service' 'Locking screen in 20 seconds...'" \
        -locker "/sbin/xtrlock" &
            # -locker "/bin/xlock -mode euler2d -erasedelay 0 -ncolors 200 -echokeys -echokey '*' -lockdelay 10" &
            # -locker "/bin/xlock -mode random -modelist 'bug,coral,euler2d,flame,spline,worm,discrete,space' -ncolors 200 -echokeys -echokey '*'" &

elif [[ `hostname` == "hackintosh" ]]; then

    xrandr --output eDP1 --auto --output HDMI1 --right-of eDP1 --auto
fi

case "$session" in
    bspwm)
        exec bspwm ;;
    awesome)
        exec awesome ;;
    termite|term)
        exec termite --geometry='1920x1080' ;;
    alacritty)
        exec alacritty --dimensions 213 56 ;;
    i3|i3wm)
        exec i3 ;;
    *)
        exec "$session"
esac
