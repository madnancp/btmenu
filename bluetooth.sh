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


declare -A DEVICES # key(name) : value(mac addr)

is_bt_on() {
	bluetoothctl show | awk -F': ' '/Powered/ {print $2}' | grep -q "yes"
}

toggle_bt_power() {
	if is_bt_on; then
		bluetoothctl power off
	else
		bluetoothctl power on
	fi
}

pair_device() {
	local device_mac=$1
	$(bluetoothctl pair "$device_mac")
}

toggle_device_connection() {
	local device=$1
	local is_connected=$(bluetoothctl info $1 | awk -F': ' '/Connected/ {print $2}')
	if [ "$is_connected" = "yes" ]; then
		echo "Device $1 already connected, Disconnecting..."
		bluetoothctl disconnect $1
	else
		echo "Device $1 not connected, connecting..."
		bluetoothctl connect $1
	fi
}

list_devices() {
	mapfile -t paired_device_macs < <(
		bluetoothctl devices Paired
	)

	for device in "${paired_device_macs[@]}"; do
		local device_name=$(echo "$device" | awk -F' ' '{$1=$2="";sub(/^ */, "");print}')
		DEVICES[$device_name]=$(echo "$device" | awk -F' ' '{print $2}')
	done
}
