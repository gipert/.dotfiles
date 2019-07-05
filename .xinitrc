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

# start mpd server
`command -v mpd` && mpd

xset r rate 300 40

# mouse, set acceleration and threshold
#xset mouse 7 1
# mouse, set speed
xinput set-prop 12 140 0.500000, 0.000000, 0.000000, 0.000000, 0.500000, 0.000000, 0.000000, 0.000000, 1.000000
xrandr --output DP-2 --mode 1920x1080 --pos 0x1920    --rotate right \
       --output DP-1 --mode 1920x1080 --pos 1080x2300 --rotate normal
feh --bg-tile ~/pictures/dark_exa_@2X.png

xautolock -detectsleep \
    -time 5 -notify 30 \
    -notifier "notify-send -u normal -i /usr/share/icons/hicolor/48x48/apps/seahorse.png 'Security Service' 'Locking screen in 20 seconds...'" \
    -locker "/bin/xlock -mode euler2d -erasedelay 0 -ncolors 200 -echokeys -echokey '*' -lockdelay 10" &
    # -locker "/bin/xlock -mode random -modelist 'bug,coral,euler2d,flame,spline,worm,discrete,space' -ncolors 200 -echokeys -echokey '*'" &

# select wm/de with: startx ~/.xinitrc session
session=${1:-i3}

case "$session" in
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
