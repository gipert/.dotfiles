i3-msg 'workspace 8:VIII; append_layout /home/pertoldi/.config/i3/layouts/workspace-8.json'
i3-msg 'workspace 9:IX; append_layout /home/pertoldi/.config/i3/layouts/workspace-9.json'
i3-msg 'workspace 10:X; append_layout /home/pertoldi/.config/i3/layouts/workspace-10.json'
i3-msg 'workspace 1:I'

alacritty -t htop -e htop &
alacritty -t vtop -e vtop --theme gruvbox &
alacritty -t ncmpcpp -e ncmpcpp &
alacritty -t vis -e vis &
alacritty -t vis -e vis &
alacritty -t vis -e vis &

google-chrome --new-window &
sleep 0.5

google-chrome --new-window web.whatsapp.com &
Telegram &
sleep 1.0

alacritty &
