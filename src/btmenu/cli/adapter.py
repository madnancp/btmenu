import asyncio
import typer

router = typer.Typer()


@router.command()
def adapter() -> None:
    asyncio.run(_adapter())


async def _adapter():

    from btmenu.core.adapter import BtMenuAdapterClient

    client = BtMenuAdapterClient()
    info = await client.get_adapter_details()
    typer.echo(info)
