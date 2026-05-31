import asyncio
import typer

router = typer.Typer()


@router.command()
def device() -> None:
    asyncio.run(_device())


async def _device():

    from btmenu.core.device import BtMenuDeviceClient

    client = BtMenuDeviceClient()
    info = await client.get_device_details(device_name="41_42_07_A0_1E_9B")
    typer.echo(info)
