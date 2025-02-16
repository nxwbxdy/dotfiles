#!/bin/bash

# Generate the sinks array with asterisks for default sinks
mapfile -t sinks < <(
  wpctl status \
    | sed -nE '
        /^Audio$/,/^Video$/!d
        /Sinks:$/,/^ ├─ /!d
        /[0-9]+\./!d
        /\[[^]]*\]/!d
        s/^[^\*]*(\*?)[^0-9]+([0-9]+)\.\s*([^[]+)\s*(\[.*\])/\1|\2|\3|\4/p'
)

selected_id=$(for sink in "${sinks[@]}"; do
  IFS='|' read -r asterisk id name vol <<< "$sink"
  if [[ "$asterisk" == "*" ]]; then
    printf "%s\t\033[1;32m%s\033[0m\t%-40s\t%s\n" "$asterisk" "$id" "$name" "$vol"
  else
    printf "%s\t%s\t%-40s\t%s\n" "$asterisk" "$id" "$name" "$vol"
  fi
done | fzf \
  --ansi \
  --delimiter=$'\t' \
  --with-nth=2,3,4 \
  --header="Select Sink (ID is passed)" \
  --preview '' \
  --tmux center,50%,20% \
  | cut -d$'\t' -f2
)

if [[ -n "$selected_id" ]]; then
  wpctl set-default "$selected_id"
else
  echo "No sink selected."
fi
