from dbus_next.aio.message_bus import MessageBus
from dbus_next.aio.proxy_object import ProxyObject
from dbus_next.constants import BusType


class BtMenuBaseDBusClient:
    async def get_proxy(self, path: str = "/org/bluez/hci0") -> ProxyObject:
        self.bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
        introspection = await self.bus.introspect(
            "org.bluez",
            "/org/bluez/hci0",
        )

        return self.bus.get_proxy_object(
            "org.bluez",
            path,
            introspection,
        )
