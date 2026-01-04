#!/usr/bin/env bash
#
# btmenu - Bluetooth menu controller
#
# _|          _|
# _|_|_|    _|_|_|_|  _|_|_|  _|_|      _|_|    _|_|_|    _|    _|
# _|    _|    _|      _|    _|    _|  _|_|_|_|  _|    _|  _|    _|
# _|    _|    _|      _|    _|    _|  _|        _|    _|  _|    _|
# _|_|_|        _|_|  _|    _|    _|    _|_|_|  _|    _|    _|_|_|
#
#
# Author: Adnan Muhammed <etc.adnan@gmail.com>
# License: MIT
# Repo: https://github.com/madnancp/btmenu


is_power_on() {
	local power_status=$(bluetoothctl show | awk -F': ' '/Powered/ {print $2}')
	if [[ $power_status == "yes" ]]; then
		exit 0
	else
		exit 1
	fi
}

pair_device() {
	local device_mac=$1
	$(bluetoothctl pair "$device_mac")
}


list_paired_devices() {
	mapfile -t paired_device_macs < <(
		bluetoothctl devices Paired | awk '{print $2}'
		)

	for mac in "${paired_device_macs[@]}"; do
		device_name=$(bluetoothctl info "$mac" | awk -F': ' '/Name/ {print $2}')
		printf '%s\n' "$device_name"
	done
	echo
}

if  is_power_on; then
	printf "Scan\nList Paired\nBack" | wofi --show dmenu -i
else
	printf "Power On\nBack" | wofi --show dmenu -i
fi


