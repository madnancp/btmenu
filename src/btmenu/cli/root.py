import typer
from btmenu.settings import settings
from btmenu.cli.devices import router as device_router
from btmenu.cli.adapter import router as adapter_router

app = typer.Typer()


app.add_typer(device_router, name="")
app.add_typer(adapter_router, name="adapter")


@app.callback()
def main(
    json: bool = typer.Option(False, "--json", help="JSON format"),
    debug: bool = typer.Option(False, "--debug", help="Enable debug mode"),
):
    settings.DEBUG = debug
    settings.JSON = json
