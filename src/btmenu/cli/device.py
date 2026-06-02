import asyncio
import typer

router = typer.Typer()


@router.command()
def list() -> None:
    asyncio.run(_list_devices())


@router.command()
def info(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def connect(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def disconnect(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def pair(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def trust(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def untrust(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


@router.command()
def remove(mac_addr: str = typer.Argument(...)) -> None:
    typer.echo(f"Not impleted: MAC {mac_addr}")


async def _list_devices():

    from btmenu.core.device import BtMenuDeviceClient

    client = BtMenuDeviceClient()
    info = await client.list_devices()
    typer.echo(info)
