export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER='nvim +Man!'

export _JAVA_AWT_WM_NONREPARENTING=1

alias nv="nvim"
export PS1='$(RETVAL=$?; [ $RETVAL -ne 0 ] && echo "\[\033[0;31m\][$RETVAL]")[\u@\h \W]\$ \[\033[0m\]'

# open last saved dir
if [[ -f "$HOME/.predir" ]]; then
	cd $(tail -n1 "$HOME/.predir") > /dev/null 2>&1
fi

# Save the current directory to a history file
sd() {
    # Append the current working directory (pwd) to the history file at $HOME/.predir
    pwd >> "$HOME/.predir"
    # Use Perl to remove duplicate entries while maintaining the order
    perl -e '
        my $file = shift; 
        open my $fh, "<", $file or die "Cannot open $file: $!"; 
        my @lines = <$fh>; 
        close $fh; 
        open my $out, ">", $file or die "Cannot write to $file: $!"; 
        my %seen; 
        print $out reverse grep { !$seen{$_}++ } reverse @lines; 
        close $out;
    ' "$HOME/.predir"
}

# Retrieve a directory from history and change to it
gd() {
    # Check if the history file exists
    if [[ -f "$HOME/.predir" ]]; then
        # Use fzf (fuzzy finder) to interactively select a directory from the history
        selected_dir=$(cat "$HOME/.predir" | fzf -i)
        # If a directory is selected (not empty), change to that directory
        if [[ -n "$selected_dir" ]]; then
            cd "$selected_dir" && sd # Change to the selected directory and call sd to save it to the history
        fi
    fi
}

# find dir
fid(){
	cd $(find -maxdepth 3 -type d | fzf -i)
}

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
