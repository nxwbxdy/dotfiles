#! /usr/bin/env bash

set -xeo pipefail

function choose_from_list() {
	echo -e "$1" | dmenu -l 10
}

function get_devices() {
	DEVICES=$(bluetoothctl devices | cut -f2 -d' ' | while read -r uuid; do bluetoothctl info "$uuid"; done | awk '
  /^Device/ { mac=$2; next }
  /^\s+Name/ { name=$0; sub(/^\s+Name: /, "", name); next }
  /^\s+Connected/ { connected=$2; print (connected == "yes" ? "y" : "n"), mac, name }')
	echo "$DEVICES"
}

function get_mac() {
	echo "$@" | awk '{print $2}'
}

function connect_to_mac() {
	bluetoothctl connect "$1"
}

selected_device=$(choose_from_list "$(get_devices)")
mac_addr=$(get_mac "$selected_device")
connect_to_mac "$mac_addr"
