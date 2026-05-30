from typing import Literal
import asyncio
import typer

router = typer.Typer()


@router.command()
def power(state: Literal["on", "off"] = typer.Argument()) -> None:
    asyncio.run(_adapter(state))


async def _adapter(state: Literal["on", "off"]):

    from btmenu.core.adapter import BtMenuAdapterClient

    client = BtMenuAdapterClient()
    info = await client.toggle_power(state)
    typer.echo(info)
