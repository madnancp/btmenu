import asyncio
from btmenu.constants import PowerState
import typer

router = typer.Typer()


@router.command()
def on() -> None:
    asyncio.run(set_adapter_power(PowerState.ON))


@router.command()
def off() -> None:
    asyncio.run(set_adapter_power(PowerState.OFF))


@router.command()
def info() -> None:
    asyncio.run(get_adapter_info())


@router.command()
def scan() -> None:
    typer.echo("Not impleted")


async def get_adapter_info():

    from btmenu.core.adapter import BtMenuAdapterClient

    client = BtMenuAdapterClient()
    info = await client.get_info()
    typer.echo(info)


async def set_adapter_power(state: PowerState):

    from btmenu.core.adapter import BtMenuAdapterClient

    client = BtMenuAdapterClient()
    info = await client.set_power(state)
    typer.echo(info)
