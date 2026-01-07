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

log_info() {
	echo "[INFO]: $*" >&2
}

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

is_device_connected() {
	bluetoothctl info $1 | awk -F': ' '/Connected/ {print $2}'
}

connect_bt_device() {
	bluetoothctl connect $1
}

disconnect_bt_device() {
	bluetoothctl disconnect $1
}

forget_bt_device() {
        bluetoothctl remove $1
}

toggle_device_connection() {
	local device=$1
	if [ "$(is_device_connected $device)" = "yes" ]; then
		echo "Device $device already connected, Disconnecting..."
		disconnect_bt_device "$device"
	else
		echo "Device $device not connected, connecting..."
		connect_bt_device "$device"
	fi
}

list_devices() {
	log_info "list_devices() called"

	mapfile -t paired_device_macs < <(
		bluetoothctl devices Paired
	)

	log_info "Raw paired devices:"
	for d in "${paired_device_macs[@]}"; do
		log_info "  $d"
	done

	DEVICES=()

	for device in "${paired_device_macs[@]}"; do
		local device_name=$(echo "$device" | awk -F' ' '{$1=$2="";sub(/^ */, "");print}')
		local mac=$(echo "$device" | awk -F' ' '{print $2}')
		DEVICES["$device_name"]="$mac"
		log_info "Mapped: [$device_name] -> [$mac]"
	done

	log_info "Final device keys: ${!DEVICES[*]}"
}
