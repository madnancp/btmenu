import json
from btmenu.constants import PowerState
from btmenu.core.base import BtMenuBaseDBusClient
from dbus_next import Variant


class BtMenuAdapterClient(BtMenuBaseDBusClient):
    async def get_info(self) -> str:
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

    async def set_power(self, state: PowerState):
        proxy = await self.get_proxy()

        adapter = proxy.get_interface(
            "org.freedesktop.DBus.Properties",
        )

        await adapter.call_set(
            "org.bluez.Adapter1",
            "Powered",
            Variant("b", True if state == PowerState.ON else False),
        )
        return state
