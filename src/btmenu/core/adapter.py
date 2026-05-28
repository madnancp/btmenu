import json
from btmenu.core.base import BtMenuBaseDBusClient


class BtMenuAdapterClient(BtMenuBaseDBusClient):
    async def get_adapter_details(self) -> str:
        proxy = await self.get_proxy()

        adapter = proxy.get_interface(
            "org.freedesktop.DBus.Properties",
        )

        values = (
            "Address",
            "Name",
            "Alias",
            "Pairable",
            "Powered",
            "Discoverable",
            "Connectable",
            "Version",
            "Discovering",
        )

        device_info = {}

        for each in values:
            value = await adapter.call_get("org.bluez.Adapter1", each)
            device_info[each.lower()] = value.value

        json_str = json.dumps({device_info["name"]: device_info}, indent=4)

        return json_str
