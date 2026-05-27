# btmenu

A Bluetooth menu controller for Wayland, built on `bluetoothctl` and `wofi`.

```
_|          _|
_|_|_|    _|_|_|_|  _|_|_|  _|_|      _|_|    _|_|_|    _|    _|
_|    _|    _|      _|    _|    _|  _|_|_|_|  _|    _|  _|    _|
_|    _|    _|      _|    _|    _|  _|        _|    _|  _|    _|
_|_|_|        _|_|  _|    _|    _|    _|_|_|  _|    _|    _|_|_|
```

## Features

- Toggle Bluetooth on/off
- Scan for nearby devices
- Connect, disconnect, pair, trust, forget devices
- View all connected devices with battery percentage
- View device type with icon (phone, headset, keyboard, etc.)
- View this device's Bluetooth name and MAC
- Clean, user-friendly wofi menu UI

## Dependencies

| Package | Purpose |
|---|---|
| `bluez` | Bluetooth stack |
| `bluez-utils` | `bluetoothctl` CLI |
| `wofi` | Wayland menu (dmenu replacement) |
| `libnotify` | `notify-send` notifications |

## Installation

<!-- ### AUR (recommended) -->
<!---->
<!-- ```bash -->
<!-- yay -S btmenu -->
<!-- # or -->
<!-- paru -S btmenu -->
<!-- ``` -->

### Manual

```bash
git clone https://github.com/madnancp/btmenu
cd btmenu
install -Dm755 btmenu ~/.local/bin/btmenu
install -Dm644 bluetooth.sh ~/.local/lib/btmenu/bluetooth.sh
```

> If installing manually, btmenu looks for `bluetooth.sh` relative to its own location first,
> then falls back to `/usr/lib/btmenu/bluetooth.sh`.

## Usage

```bash
btmenu
```

Bind it to a key in your Hyprland config:

```
bind = $mod, B, exec, btmenu
```

## Configuration

| Environment variable | Default | Description |
|---|---|---|
| `BTMENU_WIDTH` | `420` | Wofi window width |
| `BTMENU_HEIGHT` | `340` | Wofi window height |
| `BTMENU_DEBUG` | `0` | Set to `1` for debug logs on stderr |

## Notes

- Battery percentage requires BlueZ ≥ 5.48 and device support.
- Device type icons require a Nerd Font (recommended: JetBrainsMono Nerd Font).

## License

MIT © Adnan Muhammed
