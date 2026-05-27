from dataclasses import dataclass


@dataclass
class Settings:
    DEBUG: bool = False
    JSON: bool = False


settings = Settings()
