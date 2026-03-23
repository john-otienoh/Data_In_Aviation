"""
Aviation Database — single-file SQLite edition.

Usage:
    python aviation.py load  [CSV_PATH]          # load a CSV file
    python aviation.py list  [--limit N]          # list all flights
    python aviation.py stats                      # show statistics
"""
import argparse
import csv
import logging
import os
import sqlite3
import sys
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Any, Generator, Optional

from dotenv import load_dotenv
from rich.console import Console
from rich.panel import Panel
from rich.table import Table

# =============================================================================
# Configuration
# =============================================================================

load_dotenv()

DB_PATH      = Path(os.getenv("DB_PATH",       "../data/db/aviation_data.db"))
CSV_DEFAULT  = Path(os.getenv("CSV_FILE_PATH", "../data/csv/flights_sample.csv"))

# =============================================================================
# Logging — file + stdout so the terminal is never silent
# =============================================================================

_LOG_DIR = Path("logs")
_LOG_DIR.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
    handlers=[
        logging.FileHandler(_LOG_DIR / f"aviation_{datetime.now().strftime('%Y%m%d')}.log"),
    ],
)

logger = logging.getLogger(__name__)

# =============================================================================
# Schema
# =============================================================================

_SCHEMA = """
CREATE TABLE IF NOT EXISTS flights (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    origin        TEXT    NOT NULL,
    destination   TEXT    NOT NULL,
    airline       TEXT    NOT NULL,
    duration_mins INTEGER,
    date          TEXT,
    created_at    TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%S', 'now'))
);

CREATE INDEX IF NOT EXISTS idx_flights_airline     ON flights (airline);
CREATE INDEX IF NOT EXISTS idx_flights_origin      ON flights (origin);
CREATE INDEX IF NOT EXISTS idx_flights_destination ON flights (destination);
CREATE INDEX IF NOT EXISTS idx_flights_date        ON flights (date);
"""

# =============================================================================
# Database
# =============================================================================

def _init_db(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(path) as conn:
        conn.executescript(_SCHEMA)
    logger.info("Database ready: %s", path)


@contextmanager
def _db(path: Path = DB_PATH) -> Generator[sqlite3.Connection, None, None]:
    """
    Yield an open SQLite connection with row_factory set so every row is
    accessible as a dict.  Commits on clean exit, rolls back on exception.
    """
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row         
    conn.execute("PRAGMA foreign_keys = ON")
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


# =============================================================================
# CSV loading
# =============================================================================

def _read_csv(path: Path) -> list[dict]:
    """
    Read a CSV and return a list of row dicts.
    Column names come from the header — no hardcoding.
    """
    with path.open(newline="") as fh:
        return list(csv.DictReader(fh))


def _coerce_row(row: dict) -> dict:
    """
    Safely coerce known numeric fields; leave everything else as a string.
    Returns only the columns the flights table expects.
    """
    duration = row.get("duration_mins")
    return {
        "origin":        row.get("origin", "").strip().upper(),
        "destination":   row.get("destination", "").strip().upper(),
        "airline":       row.get("airline", "").strip(),
        "duration_mins": int(duration) if duration and str(duration).strip().isdigit() else None,
        "date":          row.get("date", "").strip() or None,
    }


# =============================================================================
# CRUD operations
# =============================================================================

def load_csv(csv_path: Path) -> tuple[int, int]:
    """
    Bulk-load *csv_path* into the flights table via a single executemany call.
    Returns (inserted, failed).
    """
    if not csv_path.exists():
        logger.error("CSV not found: %s", csv_path)
        return 0, 0

    rows = [_coerce_row(r) for r in _read_csv(csv_path)]
    if not rows:
        logger.warning("CSV is empty: %s", csv_path)
        return 0, 0

    query = """
        INSERT INTO flights (origin, destination, airline, duration_mins, date)
        VALUES (:origin, :destination, :airline, :duration_mins, :date)
    """
    try:
        with _db() as conn:
            conn.executemany(query, rows)
        logger.info("Loaded %d row(s) from '%s'", len(rows), csv_path.name)
        return len(rows), 0
    except Exception as exc:
        logger.error("Failed to load CSV: %s", exc)
        return 0, len(rows)


def get_all_flights() -> list[dict]:
    with _db() as conn:
        rows = conn.execute(
            "SELECT id, origin, destination, airline, duration_mins, date "
            "FROM flights ORDER BY id"
        ).fetchall()
    return [dict(r) for r in rows]


def get_statistics() -> dict[str, Any]:
    with _db() as conn:
        stats = dict(conn.execute("""
            SELECT
                COUNT(*)                      AS total_flights,
                COUNT(DISTINCT airline)       AS total_airlines,
                COUNT(DISTINCT origin)        AS unique_origins,
                COUNT(DISTINCT destination)   AS unique_destinations,
                CAST(AVG(duration_mins) AS INTEGER) AS avg_duration_mins,
                MIN(duration_mins)            AS shortest_mins,
                MAX(duration_mins)            AS longest_mins
            FROM flights
        """).fetchone())

    return stats


# =============================================================================
# CLI display helpers
# =============================================================================

console = Console()


def _flight_table(title: str, flights: list[dict]) -> Table:
    t = Table(title=title, show_lines=False)
    t.add_column("ID",          style="cyan",    no_wrap=True, width=6)
    t.add_column("Origin",      style="green",   width=8)
    t.add_column("Destination", style="green",   width=13)
    t.add_column("Airline",     style="magenta", max_width=26)
    t.add_column("Duration",    style="blue",    justify="right", width=10)
    t.add_column("Date",        style="yellow",  width=12)
    for f in flights:
        t.add_row(
            str(f["id"]),
            f.get("origin")      or "—",
            f.get("destination") or "—",
            f.get("airline")     or "—",
            f"{f['duration_mins']} min" if f.get("duration_mins") else "—",
            f.get("date")        or "—",
        )
    return t


# =============================================================================
# CLI commands
# =============================================================================

def cmd_load(csv_path: Path) -> None:
    inserted, failed = load_csv(csv_path)
    stats = get_statistics()
    console.print(f"[green]Inserted {inserted} row(s), {failed} failed.[/green]")
    console.print(f"[dim]Database now holds {stats.get('total_flights', '?')} flight(s).[/dim]")


def cmd_list(limit: Optional[int]) -> None:
    flights = get_all_flights()
    if not flights:
        console.print("[yellow]No flights in database.[/yellow]")
        return
    subset = flights[:limit] if limit else flights
    console.print(_flight_table(f"All flights ({len(flights)} total)", subset))

def cmd_stats() -> None:
    stats = get_statistics()
    t = Table(title="Aviation Statistics", show_header=False, box=None, padding=(0, 2))
    t.add_column("Metric", style="blue")
    t.add_column("Value",  style="green")
    labels = {
        "total_flights":        "Total flights",
        "total_airlines":       "Total airlines",
        "unique_origins":       "Unique origins",
        "unique_destinations":  "Unique destinations",
        "avg_duration_mins":    "Avg duration (min)",
        "shortest_mins":        "Shortest flight (min)",
        "longest_mins":         "Longest flight (min)",
    }
    for key, label in labels.items():
        if stats.get(key) is not None:
            t.add_row(label, str(stats[key]))
    if stats.get("busiest_airline"):
        t.add_row(
            "Busiest airline",
            f"{stats['busiest_airline']} ({stats['busiest_airline_count']} flights)",
        )
    console.print(t)


# =============================================================================
# CLI wiring
# =============================================================================

def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="aviation.py",
        description="SQLite aviation database CLI.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
examples:
  python aviation.py load data/flights_sample.csv
  python aviation.py list --limit 20
  python aviation.py stats
        """,
    )
    sub = parser.add_subparsers(dest="command", metavar="command")

    ld = sub.add_parser("load",   help="Load a CSV file into the database")
    ld.add_argument("csv_path", nargs="?", type=Path, default=CSV_DEFAULT,
                    help=f"Path to CSV (default: {CSV_DEFAULT})")

    ls = sub.add_parser("list",   help="List all flights")
    ls.add_argument("--limit", type=int, metavar="N")

    sub.add_parser("stats",       help="Show database statistics")

    return parser


def main() -> None:
    _init_db(DB_PATH)       # no-op if already initialised

    parser = _build_parser()
    args   = parser.parse_args()

    dispatch = {
        "load":   lambda: cmd_load(args.csv_path),
        "list":   lambda: cmd_list(args.limit),
        "stats":  cmd_stats,
    }

    action = dispatch.get(args.command)
    if action:
        action()
    else:
        parser.print_help()


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        logger.error("Unhandled error: %s", exc)
        sys.exit(1)