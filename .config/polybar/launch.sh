#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

if [[ `hostname` == "hackintosh" ]]; then
    echo "---" | tee -a /tmp/polybar_hackintosh.log
    polybar hackintosh >> /tmp/polybar_hackintosh.log 2>&1 &
elif [[ `hostname` == "lxpertoldi" ]]; then
    echo "---" | tee -a /tmp/polybar_lxpertoldi_vert.log
    polybar lxpertoldi_vert >> /tmp/polybar_lxpertoldi_vert.log 2>&1 &
    echo "---" | tee -a /tmp/polybar_lxpertoldi_hor.log
    polybar lxpertoldi_hor >> /tmp/polybar_lxpertoldi_hor.log 2>&1 &
    echo "---" | tee -a /tmp/polybar_music.log
    polybar music >> /tmp/polybar_music.log 2>&1 &
fi

echo "Bars launched..."
