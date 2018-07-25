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

xset r rate 300 40
xset m 1/1 0
xrandr --output DP-2 --mode 1920x1080 --pos 0x1920    --rotate right \
       --output DP-1 --mode 1920x1080 --pos 1080x2300 --rotate normal
feh --bg-tile ~/pictures/dark_exa_@2X.png

xautolock -detectsleep \
    -time 5 -notify 20 \
    -notifier "notify-send -t 18000 -u critical 'Lock' 'Locking screen in 20 seconds.'" \
    -locker "/bin/xlock -mode worm -count 5" &

lsyncd ~/.config/lsyncd.conf

# select wm/de with: startx ~/.xinitrc session
session=${1:-i3}

# patch to make i3 run rofi
export PATH="/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

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
