from btmenu.core.base import BtMenuBaseDBusClient


class BtMenuAdapterClient(BtMenuBaseDBusClient):
    async def get_adapter_details(self) -> dict:
        proxy = await self.get_proxy()

        adapter = proxy.get_interface(
            "org.freedesktop.DBus.Properties",
        )

        device_name = await adapter.call_get("org.bluez.Adapter1", "Address")
        return {
            "result": device_name.value,
        }
