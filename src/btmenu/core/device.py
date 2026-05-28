from btmenu.core.base import BtMenuBaseDBusClient


class BtMenuDeviceClient(BtMenuBaseDBusClient):
    async def get_device_details(self, device_name: str) -> dict:
        proxy = await self.get_proxy(path=f"/org/bluez/hci0/dev_{device_name}")

        adapter = proxy.get_interface(
            "org.freedesktop.DBus.Properties",
        )

        device_name = await adapter.call_get("org.bluez.Device1", "Name")
        return {
            "result": device_name.value,
        }
