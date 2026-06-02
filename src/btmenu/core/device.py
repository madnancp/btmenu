import json
from btmenu.core.base import BtMenuBaseDBusClient


class BtMenuDeviceClient(BtMenuBaseDBusClient):
    async def list_devices(self) -> str:
        proxy = await self.get_proxy(path="/")

        adapter = proxy.get_interface("org.freedesktop.DBus.ObjectManager")

        objects = await adapter.call_get_managed_objects()

        devices = []

        for path, interfaces in objects.items():
            if "org.bluez.Device1" not in interfaces:
                continue

            props = interfaces["org.bluez.Device1"]

            devices.append(
                {
                    "path": path,
                    "address": props["Address"].value,
                    "name": props["Alias"].value,
                    "connected": props["Connected"].value,
                    "paired": props["Paired"].value,
                    "trusted": props["Trusted"].value,
                }
            )

        json_str = json.dumps(devices, indent=4)
        return json_str
