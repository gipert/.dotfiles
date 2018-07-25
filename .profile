# MPD daemon start (if no other user instance exists)
[ ! -s ~/.config/mpd/pid -a `command -v mpd` ] && mpd
