#!/usr/bin/env bash
#
# btmenu - bluetooth.sh
# Bluetooth helper library — sourced by btmenu
#
# Author: Adnan Muhammed <etc.adnan@gmail.com>
# License: MIT
# Repo: https://github.com/madnancp/btmenu

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "bluetooth.sh is a library. Source it, don't run it directly." >&2
    exit 1
fi

readonly BT_TIMEOUT_SCAN=15
readonly BT_TIMEOUT_CONNECT=10

declare -A DEVICE_ICONS=(
    [phone]="󰄜"
    [audio-headset]="󰋋"
    [audio-headphones]="󰋋"
    [audio-card]="󰓃"
    [computer]="󰌢"
    [keyboard]="󰌌"
    [mouse]="󰍽"
    [gaming]="󰊗"
    [unknown]="󰂯"
)

log_info()  { [[ "${BTMENU_DEBUG:-0}" == "1" ]] && echo "[INFO]  $*" >&2; true; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }

check_deps() {
    local missing=()
    local deps=(bluetoothctl wofi notify-send)
    for dep in "${deps[@]}"; do
        command -v "$dep" &>/dev/null || missing+=("$dep")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required dependencies: ${missing[*]}"
        log_error "Install them and try again."
        exit 1
    fi
}

is_bt_on() {
    bluetoothctl show 2>/dev/null \
        | awk -F': ' '/^\s*Powered:/ { print $2; exit }' \
        | grep -q "yes"
}

bt_adapter_exists() {
    bluetoothctl show 2>/dev/null | grep -q "Controller"
}

bt_local_name() {
    bluetoothctl show 2>/dev/null \
        | awk -F': ' '/^\s*Name:/ { print $2; exit }'
}

bt_local_mac() {
    bluetoothctl show 2>/dev/null \
        | awk '/^\s*Controller/ { print $2; exit }'
}

toggle_bt_power() {
    if is_bt_on; then
        log_info "Turning Bluetooth off"
        bluetoothctl power off &>/dev/null
    else
        log_info "Turning Bluetooth on"
        bluetoothctl power on &>/dev/null
    fi
}

is_device_connected() {
    local mac="$1"
    bluetoothctl info "$mac" 2>/dev/null \
        | awk -F': ' '/^\s*Connected:/ { print $2; exit }'
}

is_device_paired() {
    local mac="$1"
    bluetoothctl info "$mac" 2>/dev/null \
        | awk -F': ' '/^\s*Paired:/ { print $2; exit }'
}

is_device_trusted() {
    local mac="$1"
    bluetoothctl info "$mac" 2>/dev/null \
        | awk -F': ' '/^\s*Trusted:/ { print $2; exit }'
}

get_device_type() {
    local mac="$1"
    local icon_key
    icon_key=$(bluetoothctl info "$mac" 2>/dev/null \
        | awk -F': ' '/^\s*Icon:/ { print $2; exit }')
    echo "${icon_key:-unknown}"
}

get_device_battery() {
    local mac="$1"
    local pct
    pct=$(bluetoothctl info "$mac" 2>/dev/null \
        | awk -F'[()%]' '/Battery Percentage/ { print $2; exit }')
    if [[ -n "$pct" ]]; then
        echo "${pct}%"
    fi
}

get_device_icon() {
    local type="$1"
    echo "${DEVICE_ICONS[$type]:-${DEVICE_ICONS[unknown]}}"
}

#
# Device operations 
pair_bt_device() {
    local mac="$1"
    log_info "Pairing $mac"
    bluetoothctl pair "$mac" &>/dev/null
}

trust_bt_device() {
    local mac="$1"
    log_info "Trusting $mac"
    bluetoothctl trust "$mac" &>/dev/null
}

connect_bt_device() {
    local mac="$1"
    log_info "Connecting $mac"
    timeout "$BT_TIMEOUT_CONNECT" bluetoothctl connect "$mac" &>/dev/null
}

disconnect_bt_device() {
    local mac="$1"
    log_info "Disconnecting $mac"
    bluetoothctl disconnect "$mac" &>/dev/null
}

forget_bt_device() {
    local mac="$1"
    log_info "Removing $mac"
    bluetoothctl remove "$mac" &>/dev/null
}

# Device listing 
declare -A DEVICES=()

list_paired_devices() {
    DEVICES=()
    local raw
    while IFS= read -r line; do
        # Each line: "Device AA:BB:CC:DD:EE:FF Device Name"
        local mac name
        mac=$(awk '{print $2}' <<<"$line")
        name=$(awk '{$1=$2=""; sub(/^ +/, ""); print}' <<<"$line")
        [[ -n "$mac" && -n "$name" ]] || continue
        DEVICES["$name"]="$mac"
        log_info "Paired device: [$name] -> [$mac]"
    done < <(bluetoothctl devices Paired 2>/dev/null)
}

list_connected_devices() {
    bluetoothctl devices Connected 2>/dev/null \
        | awk '{print $2}'
}

declare -A SCANNED_DEVICES=()

scan_devices() {
    SCANNED_DEVICES=()
    log_info "Starting ${BT_TIMEOUT_SCAN}s scan"

    local tmp
    tmp=$(mktemp /tmp/btmenu_scan.XXXXXX)

    bluetoothctl --timeout "$BT_TIMEOUT_SCAN" scan on >"$tmp" 2>&1 &
    local scan_pid=$!
    wait "$scan_pid"

    sed -i -r \
        -e 's/\r//g' \
        -e 's/\x1B\[[0-9;]*[mGKHF]//g' \
        "$tmp"

    while IFS= read -r line; do
        [[ "$line" =~ \[NEW\]\ Device\ ([0-9A-Fa-f:]{17})\ (.+) ]] || continue
        local mac="${BASH_REMATCH[1]}"
        local name="${BASH_REMATCH[2]}"

        [[ "$name" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]] && continue
        [[ -z "${name// /}" ]] && continue

        SCANNED_DEVICES["$name"]="$mac"
        log_info "Scanned: [$name] -> [$mac]"
    done <"$tmp"

    rm -f "$tmp"
    log_info "Scan complete. Found ${#SCANNED_DEVICES[@]} devices."
}
