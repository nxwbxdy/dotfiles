export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export XDG_CONFIG_HOME="$HOME/.config"
#export MANPAGER='nvim +Man!'
export MANPAGER='less'

bind '"\C-f":vi-fWord'
bind '"\C-b":vi-bWord'
# bind -p

export _JAVA_AWT_WM_NONREPARENTING=1

alias nv="nvim"
alias n="nnn"
[ -f /home/l466l/builds/nnn/misc/quitcd/quitcd.bash_sh_zsh ] && . /home/l466l/builds/nnn/misc/quitcd/quitcd.bash_sh_zsh
export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview;a:-!ani-cli*'
# n() {
# 	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
# 	nnn "$@"
# 	if [ -f "$NNN_TMPFILE" ]; then
# 		. "$NNN_TMPFILE"
# 		rm -f "$NNN_TMPFILE"
# 	fi
# }


if [[ -f "$HOME/.ps1.sh" ]]; then
	. "$HOME/.ps1.sh"
fi

# open last saved dir
# if [[ -f "$HOME/.predir" ]]; then
# 	cd $(tail -n1 "$HOME/.predir") > /dev/null 2>&1
# fi

# # Save the current directory to a history file
# sd() {
#     # Append the current working directory (pwd) to the history file at $HOME/.predir
#     pwd >> "$HOME/.predir"
#     # Use Perl to remove duplicate entries while maintaining the order
#     perl -e '
#         my $file = shift; 
#         open my $fh, "<", $file or die "Cannot open $file: $!"; 
#         my @lines = <$fh>; 
#         close $fh; 
#         open my $out, ">", $file or die "Cannot write to $file: $!"; 
#         my %seen; 
#         print $out reverse grep { !$seen{$_}++ } reverse @lines; 
#         close $out;
#     ' "$HOME/.predir"
# }
#
# # Retrieve a directory from history and change to it
# gd() {
#     # Check if the history file exists
#     if [[ -f "$HOME/.predir" ]]; then
#         # Use fzf (fuzzy finder) to interactively select a directory from the history
#         selected_dir=$(cat "$HOME/.predir" | fzf -i)
#         # If a directory is selected (not empty), change to that directory
#         if [[ -n "$selected_dir" ]]; then
#             cd "$selected_dir" && sd # Change to the selected directory and call sd to save it to the history
#         fi
#     fi
# }

# find dir
# fid(){
# 	cd $(find -maxdepth 3 -type d | fzf -i)
# }

alias sshnvas="ssh 87.106.94.178"
alias sshdns="ssh nws3-dnssec.sin-lab.at"
alias ftk=". /home/l466l/Documents/FHH/SEM3/FTK/ftkv/bin/activate"

py() {
  local filename="${1%.py}.py"

  # Check if filename is provided
  if [[ -z "$filename" ]]; then
    echo "Error: No filename provided."
    return 1
  fi

  # Create the file
  touch "${filename}"
  if [[ $? -ne 0 ]]; then
    echo "Error: Could not create file $filename."
    return 1
  fi

  # Change permissions
  chmod +x "$filename"
  if [[ $? -ne 0 ]]; then
    echo "Error: Could not change permissions on $filename."
    return 1
  fi

  # Write content to the file
  echo -ne "#! /usr/bin/env python\n\n" > "$filename"
  if [[ $? -ne 0 ]]; then
    echo "Error: Could not write to $filename."
    return 1
  fi

  echo "Python file '$filename' created!"
  return 0
}

#NG!pE@rE8dEGjUXhfuLWXF4v^E@
PATH="$PATH:$HOME/.scripts/screenshot/"
PATH="$PATH:$HOME/.scripts/pdf/"
PATH="$PATH:$HOME/go/bin/"

function svol () {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "${1}%"
}

function ivol () {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "${1}%+"
}

function dvol () {
	wpctl set-volume @DEFAULT_AUDIO_SINK@ "${1}%-"
}

function tvol () {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
}

function mvol () {
	wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
}

function gvol () {
	wpctl get-volume @DEFAULT_AUDIO_SINK@
}

mcd() {
    if [ $# -ne 1 ]; then
        echo "Usage: mcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1" || return 1
}

mkn() {
    if [ $# -ne 1 ]; then
        echo "Usage: mknumdir <filename>"
        return 1
    fi

    local filename="$1"
    local base="${filename%.*}"
    local ext="${filename##*.}"

    # Validate filename has an extension
    if [[ "$base" == "$filename" ]]; then
        echo "Error: Filename must contain an extension"
        return 1
    fi

    # Find highest existing number
    local max_num=$(find . -maxdepth 1 -type d -name '[0-9][0-9][0-9]_*' -printf '%f\n' | 
                   awk -F_ '{print $1}' | 
                   while read -r num; do printf "%d\n" "$((10#$num))"; done | 
                   sort -nr | 
                   head -n1)


    # Calculate next number
    local next_num=$(( ${max_num:- -1} + 1 ))  # Handle no existing dirs case
    local seq_num=$(printf "%03d" "$next_num")

    # Create directory and file
    local dirname="${seq_num}_${base}"
    mkdir -p "$dirname" && touch "$dirname/$filename" && cd "$dirname" || return 1
}

eval "$(ssh-agent -s)" &>/dev/null
