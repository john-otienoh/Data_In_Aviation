"""
Centralized configuration and logging setup.
"""
import logging
import os
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

LOG_DIR = Path("logs")
LOG_DIR.mkdir(exist_ok=True)

_log_file = LOG_DIR / f"flight_sample_{datetime.now().strftime('%Y%m%d')}.log"

logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
    handlers=[
        logging.FileHandler(_log_file),
    ],
)


def get_logger(name: str) -> logging.Logger:
    return logging.getLogger(name)

@dataclass(frozen=True)
class DBConfig:
    host: str = os.getenv("DB_HOST", "localhost")
    port: str = os.getenv("DB_PORT", "5432")
    name: str = os.getenv("DB_NAME", "poetry_data")
    user: str = os.getenv("DB_USER", "postgres")
    password: str = os.getenv("DB_PASSWORD", "")

    def as_dict(self):
        return {
            "host": self.host,
            "port": self.port,
            "dbname": self.name,
            "user": self.user,
            "password": self.password,
        }
