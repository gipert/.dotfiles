#!/bin/bash

apps=(thunderbird telegram-desktop whatsapp-nativefier slack firefox)

for app in ${apps[@]}; do
    if [[ "$app" == "whatsapp-nativefier" ]]; then
        killall WhatsApp &> /dev/null
    else
        killall -I $app &> /dev/null
    fi
    exec $app > /dev/null &
done
