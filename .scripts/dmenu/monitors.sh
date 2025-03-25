#! /usr/bin/env bash

# set -xeo pipefail

# Function to display dmenu selection
choose_from_list() {
	echo -e "$1" | dmenu
}

# Function to select a monitor
select_monitor() {
	monitors=$(xrandr --query | grep -E ' connected( primary)?' | awk '{print $1}')
	[ -z "$monitors" ] && exit 1
	choose_from_list "$(echo -e "$monitors")"
}

# Function to select resolution for a given monitor
select_resolution() {
	local monitor=$1
	resolutions=$(xrandr --query | awk -v mon="$monitor" '$0 ~ mon" connected" {found=1; next} found && $1 ~ /^[0-9]+x[0-9]+/ {print $1}')
	[ -z "$resolutions" ] && exit 1
	choose_from_list "$(echo -e "$resolutions")"
}

# Function to select position
select_position() {
	local positions="left-of\nright-of\nabove\nbelow\nprimary\nsame-as"
	choose_from_list "$positions"
}

# Function to select a reference monitor for positioning
select_reference_monitor() {
	local selected_monitor=$1
	ref_monitors=$(xrandr --query | grep -E " connected( primary)?" | awk '{print $1}' | grep -v "^$selected_monitor$")
	[ -z "$ref_monitors" ] && exit 1
	choose_from_list "$(echo -e "$ref_monitors")"
}

select_brightness() {
	local brightness calculated_brightness
	brightness=$(choose_from_list "10\n20\n30\n40\n50\n60\n70\n80\n90\n100")
	calculated_brightness=$(echo "scale=2; $brightness / 100" | bc -l)
	echo "$calculated_brightness"
}

# Function to apply full setup: monitor, resolution, position
apply_full_setup() {
	local monitor resolution position ref_monitor

	monitor=$(select_monitor)
	[ -z "$monitor" ] && exit 1

	resolution=$(select_resolution "$monitor")
	[ -z "$resolution" ] && exit 1

	position=$(select_position)
	[ -z "$position" ] && exit 1

	ref_monitor=$(select_reference_monitor "$monitor")
	[ -z "$ref_monitor" ] && exit 1

	xrandr --output "$monitor" --mode "$resolution" --"$position" "$ref_monitor"
}

# Function to apply resolution setup
apply_resolution_setup() {
	local monitor resolution

	monitor=$(select_monitor)
	[ -z "$monitor" ] && exit 1

	resolution=$(select_resolution "$monitor")
	[ -z "$resolution" ] && exit 1

	xrandr --output "$monitor" --mode "$resolution"
}

# Function to apply position setup
apply_position_setup() {
	local monitor position ref_monitor

	monitor=$(select_monitor)
	[ -z "$monitor" ] && exit 1

	position=$(select_position)
	[ -z "$position" ] && exit 1

	ref_monitor=$(select_reference_monitor "$monitor")
	[ -z "$ref_monitor" ] && exit 1

	xrandr --output "$monitor" --"$position" "$ref_monitor"
}

# Function to apply position setup
apply_brightness_setup() {
	local monitor brightness

	monitor=$(select_monitor)
	[ -z "$monitor" ] && exit 1

	brightness=$(select_brightness)
	[ -z "$brightness" ] && exit 1

	xrandr --output "$monitor" --brightness "$brightness"
}

# Main menu
OPTS="full\nresolution\nposition\nbrightness"

ACTION=$(choose_from_list "$OPTS")

case "$ACTION" in
"full") apply_full_setup ;;
"resolution") apply_resolution_setup ;;
"position") apply_position_setup ;;
"brightness") apply_brightness_setup ;;
*) exit 1 ;;
esac
