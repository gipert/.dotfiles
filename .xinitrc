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
if command -v feh > /dev/null && [ -d ~/pictures/wallpapers ]; then
    img=$(ls ~/pictures/wallpapers/ | grep -E '.(png|jpe?g)'  | sort -R | tail -n 1)
    feh --bg-tile "$HOME/pictures/wallpapers/$img"
fi

# adjust cursor repeat rate
xset r rate 300 40

# mouse, set acceleration and threshold
xinput set-prop "USB Optical Mouse" "libinput Accel Speed" 1.0 &> /dev/null

# select wm/de with: startx ~/.xinitrc session
session=${1:-bspwm}

# this to make xob work
[[ `command -v xob` ]] && ~/.config/xob/launch.sh &> /dev/null

if [[ `hostname` == "thinkpad" ]]; then

    # needed for rofi-pass to work properly
    setxkbmap de

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
