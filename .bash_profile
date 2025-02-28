PATH="$PATH:$HOME/.scripts/screenshot/"
PATH="$PATH:$HOME/.scripts/pdf/"
PATH="$PATH:$HOME/.scripts/notify/"
PATH="$PATH:$HOME/.scripts/dmenu/"
PATH="$PATH:$HOME/go/bin/"
#
# source "$HOME/.bashrc"
# . "$HOME/.cargo/env"
#
# # Created by `pipx` on 2024-08-01 08:54:45
# export PATH="$PATH:/home/l466l/.local/bin"
#
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	exec startx
fi

[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
