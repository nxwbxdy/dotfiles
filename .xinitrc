xset s 180 &
xss-lock slock &
#dwmstatus 2>&1 >/dev/null &
dunst &
/usr/lib/xfce-polkit/xfce-polkit &
pactl set-sink-mute 0 true &
sh ~/builds/status/status.sh &
export _JAVA_AWT_WM_NONREPARENTING=1
exec dwm
