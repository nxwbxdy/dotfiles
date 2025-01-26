#!/usr/bin/env bash

# Icons für Batterie und Zeit
Bat_icons=(" " " " " " " " " ")
Bat_charge_icons=("󰢟 " "󰢜 " "󰂆 " "󰂇 " "󰂈 " "󰢝 " "󰂉 " "󰢞 " "󰂊 " "󰂋 " "󰂅 ")
Time_icons=("󱑊 " "󱐿 " "󱑀 " "󱑁 " "󱑂 " "󱑃 " "󱑄 " "󱑅 " "󱑆 " "󱑇 " "󱑈 " "󱑉 ")

# CPU-Tracking initialisieren
Cpu_last=($(head -n1 /proc/stat))
Cpu_last_sum=0
for value in "${Cpu_last[@]:1}"; do
  Cpu_last_sum=$((Cpu_last_sum + value))
done

# Netzwerk-Interface
INTERFACE="wlp0s20f3"  # Ersetze dies mit deinem Wi-Fi-Interface
if [ ! -d "/sys/class/net/$INTERFACE" ]; then
  echo "Fehler: Netzwerk-Interface $INTERFACE nicht gefunden." >&2
  exit 1
fi

TX_BEFORE=$(<"/sys/class/net/$INTERFACE/statistics/tx_bytes")
RX_BEFORE=$(<"/sys/class/net/$INTERFACE/statistics/rx_bytes")

while true; do
  # CPU-Nutzung berechnen
  Cpu_now=($(head -n1 /proc/stat))
  Cpu_sum=0
  for value in "${Cpu_now[@]:1}"; do
    Cpu_sum=$((Cpu_sum + value))
  done
  Cpu_delta=$((Cpu_sum - Cpu_last_sum))
  Cpu_idle=$((Cpu_now[4] - Cpu_last[4]))
  Cpu_used=$((Cpu_delta - Cpu_idle))
  Cpu_usage=$((100 * Cpu_used / Cpu_delta))

  Cpu_last=("${Cpu_now[@]}")
  Cpu_last_sum=$Cpu_sum

  # Batterieinformationen abrufen
  Battery_capacity=$(<"/sys/class/power_supply/BAT0/capacity")
  Battery_status=$(<"/sys/class/power_supply/BAT0/status")

  case $Battery_status in
    "Charging")   Bat_icon=${Bat_charge_icons[$((Battery_capacity / 10))]} ;;
    "Discharging") Bat_icon=${Bat_icons[$((Battery_capacity / 25))]} ;;
    "Full")        Bat_icon=${Bat_icons[4]} ;;
    "Not charging") Bat_icon=" " ;;
    *)             Bat_icon=" " ;;
  esac

  # Netzwerkstatistiken berechnen
  TX_AFTER=$(<"/sys/class/net/$INTERFACE/statistics/tx_bytes")
  RX_AFTER=$(<"/sys/class/net/$INTERFACE/statistics/rx_bytes")
  TX_RATE=$((TX_AFTER - TX_BEFORE))
  RX_RATE=$((RX_AFTER - RX_BEFORE))
  TX_BEFORE=$TX_AFTER
  RX_BEFORE=$RX_AFTER

  # Wi-Fi-Signalstärke abrufen
  SIGNAL=$(awk -v interface="$INTERFACE" '$1 ~ interface {print int($3)}' /proc/net/wireless)

  # Arbeitsspeichernutzung
  Mem_usage=$(free -m | awk '/Mem/ {printf "%.0f", ($3/$2)*100}')

  # Zeit-Icon basierend auf der Stunde
  Hour=$(date "+%I")
  Time_icon=${Time_icons[$((10#$Hour - 1))]}

  # Datum und Zeit
  Date=$(date "+%d.%m")
  Time=$(date "+%H:%M")

  RX_OUT=$(echo "scale=2; $RX_RATE / 1000" | bc)
  TX_OUT=$(echo "scale=2; $TX_RATE / 1000" | bc)

  # Statusbar anzeigen
  xsetroot -name " ${Cpu_usage}%| ${Mem_usage}%| ${RX_OUT}K ${TX_OUT}K 󰤨 ${SIGNAL}%| ${Date} ${Time_icon}${Time}|${Bat_icon}${Battery_capacity}%"

  sleep 1
done
