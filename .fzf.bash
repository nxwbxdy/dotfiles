# Setup fzf
# ---------
if [[ ! "$PATH" == */home/l466l/builds/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/l466l/builds/fzf/bin"
fi

eval "$(fzf --bash)"

#export FZF_DEFAULT_OPTS="--tmux center,70%,70%,border-native --preview 'bat {}' --info=inline --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down"
export FZF_DEFAULT_OPTS="--tmux center,90%"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -sel clip)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
