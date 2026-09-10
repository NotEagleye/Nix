#!/usr/bin/env bash
#~/.config/i3/scripts/polybar.sh

pkill polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
polybar --config="$HOME/.config/polybar/config.ini" main &
