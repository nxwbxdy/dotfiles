#! /usr/bin/env bash

# set -xeo pipefail

# Function to display dmenu selection
choose_from_list() {
	echo -e "$1" | dmenu
}

# Function to get a list of sinks
get_sinks() {
	local sink_list selected selected_id

	mapfile -t sinks < <(
		wpctl status |
			sed -nE '
            /^Audio$/,/^Video$/!d
            /Sinks:$/,/^ ├─ /!d
            /[0-9]+\./!d
            /\[[^]]*\]/!d
            s/^[^\*]*(\*?)[^0-9]+([0-9]+)\.\s*([^[]+)\s*(\[.*\])/\1|\2|\3|\4/p'
	)

	# Format the sinks for dmenu
	sink_list=$(for sink in "${sinks[@]}"; do
		IFS='|' read -r asterisk id name vol <<<"$sink"
		if [[ "$asterisk" == "*" ]]; then
			printf "%s\t%s\t%-40s\t%s\n" "$asterisk" "$id" "$name" "$vol"
		else
			printf "%s\t%s\t%-40s\t%s\n" "$asterisk" "$id" "$name" "$vol"
		fi
	done)

	# Use dmenu to select a sink
	selected=$(echo -e "$sink_list" | dmenu -l 10 -p "Select Sink:")

	# Extract the sink ID from the selected line and sanitize it
	selected_id=$(echo "$selected" | awk -F'\t' '{print $2}' | tr -d '[:space:]')
	echo "$selected_id"
}

# Function to select and set a sink as default
select_sink() {
	local selected_id
	selected_id=$(get_sinks)
	if [[ -n "$selected_id" ]]; then
		wpctl set-default "$selected_id"
	else
		echo "No sink selected."
	fi
}

# Function to set volume for the selected sink
set_volume() {
	local selected_id volume calc_volume
	selected_id=$(get_sinks)
	if [[ -n "$selected_id" ]]; then
		# Prompt for volume percentage
		volume=$(echo -e "10\n20\n30\n40\n50\n60\n70\n80\n90\n100" | dmenu -p "Set Volume (%):")

		# Validate input
		if [[ "$volume" =~ ^[0-9]+$ ]] && ((volume >= 0 && volume <= 100)); then
			# Convert percentage to a decimal (e.g., 50 -> 0.50)
			calc_volume=$(echo "scale=2; $volume / 100" | bc -l)

			# Set the volume
			wpctl set-volume "$selected_id" "$calc_volume"
		else
			echo "Invalid volume: $volume. Please enter a number between 0 and 100."
		fi
	else
		echo "No sink selected."
	fi
}

# Function to toggle mute for the selected sink
set_mute() {
	local selected_id
	selected_id=$(get_sinks)
	if [[ -n "$selected_id" ]]; then
		wpctl set-mute "$selected_id" toggle
	else
		echo "No sink selected."
	fi
}

# Main menu
OPTS="select\nvolume\nmute"

ACTION=$(choose_from_list "$OPTS")

case "$ACTION" in
"select") select_sink ;;
"volume") set_volume ;;
"mute") set_mute ;;
*) exit 1 ;;
esac
