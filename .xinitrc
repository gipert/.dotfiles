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

# elif [[ `hostname` == "lxpertoldi" ]]; then

#     # mouse, set speed
#     xinput set-prop 14 173 0.3 0.0 0.0 0.0 0.5 0.0 0.0 0.0 1.0

#     # set monitors
#     xrandr --output DP2 --mode 1920x1080 --pos 0x1920    --rotate right \
#            --output DP1 --mode 1920x1080 --pos 1080x2300 --rotate normal

#     xautolock -detectsleep \
#         -time 5 -notify 30 \
#         -notifier "notify-send -u normal -i /usr/share/icons/hicolor/48x48/apps/gcr-key-pair.png 'Security Service' 'Locking screen in 20 seconds...'" \
#         -locker "/sbin/xtrlock" &
#             # -locker "/bin/xlock -mode euler2d -erasedelay 0 -ncolors 200 -echokeys -echokey '*' -lockdelay 10" &
#             # -locker "/bin/xlock -mode random -modelist 'bug,coral,euler2d,flame,spline,worm,discrete,space' -ncolors 200 -echokeys -echokey '*'" &

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
