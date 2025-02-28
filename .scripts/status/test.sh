#! /usr/bin/env bash

INTERFACE="wlp0s20f3"  # Replace with your Wi-Fi interface

# Initial readings
TX_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
RX_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

sleep 1  # Wait for 1 second

# Read again
TX_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
RX_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

# Calculate differences
TX_DIFF=$((TX_AFTER - TX_BEFORE))
RX_DIFF=$((RX_AFTER - RX_BEFORE))

# Get Wi-Fi signal quality
SIGNAL=$(grep "$INTERFACE" /proc/net/wireless | awk '{print int($3)}')

# Display results
echo "Tx: $TX_DIFF bytes/s, Rx: $RX_DIFF bytes/s, Signal: $SIGNAL%"
