import typer
from btmenu.settings import settings

app = typer.Typer()


@app.callback()
def main(
    json: bool = typer.Option(False, "--json", help="JSON format"),
    debug: bool = typer.Option(False, "--debug", help="Enable debug mode"),
):
    settings.DEBUG = debug
    settings.JSON = json
