#!/bin/bash

apps=(thunderbird telegram-desktop whatsapp-nativefier slack firefox)

for app in ${apps[@]}; do
    pkill -f $app
    exec $app &> /dev/null &
done
