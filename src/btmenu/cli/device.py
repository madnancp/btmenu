import asyncio
import typer

router = typer.Typer()


@router.command()
def list() -> None:
    typer.echo("Not impleted")


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


async def _device():

    from btmenu.core.device import BtMenuDeviceClient

    client = BtMenuDeviceClient()
    info = await client.get_device_details(device_name="41_42_07_A0_1E_9B")
    typer.echo(info)
