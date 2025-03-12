#!/bin/sh
xset s 180 &
xss-lock slock &
dunst &
# /usr/lib/xfce-polkit/xfce-polkit &
pactl set-sink-mute 0 true &
sh ~/.scripts/status/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
xrdb -merge ~/.Xresources
gammastep -l 48.3:14.28 -t 6500:3600 -m randr &

# # Set PATH for custom scripts BEFORE launching dwm
# if [ -d "$HOME/bin" ]; then
#     PATH="$HOME/bin:$PATH"
# fi
#
# if [ -d "$HOME/.local/bin" ]; then
#     PATH="$HOME/.local/bin:$PATH"
# fi
#
# export PATH="$PATH:$HOME/.scripts/screenshot/"
# export PATH="$PATH:$HOME/.scripts/pdf/"
# export PATH="$PATH:$HOME/.scripts/notify/"
# export PATH="$PATH:$HOME/go/bin/"
#
exec dwm
