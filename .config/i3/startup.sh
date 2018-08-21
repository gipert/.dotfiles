i3-msg 'workspace 8:VIII; append_layout /home/pertoldi/.config/i3/layouts/workspace-8.json'
i3-msg 'workspace 9:IX; append_layout /home/pertoldi/.config/i3/layouts/workspace-9.json'
i3-msg 'workspace 10:X; append_layout /home/pertoldi/.config/i3/layouts/workspace-10.json'
#i3-msg 'workspace 1:I;  append_layout /home/pertoldi/.config/i3/layouts/workspace-1.json'
i3-msg 'workspace 1:I'

st -n htop -e htop &
st -n vtop -e vtop --theme gruvbox &
st -n ncmpcpp -e ncmpcpp &
st -n vis -e vis &

#nohup st -n st-256color &

vivaldi --new-window github.com/gipert &
sleep 0.5

Telegram &
vivaldi --new-window web.whatsapp.com &
