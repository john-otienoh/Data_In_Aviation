"""
Aviation Database Management System
A production-ready tool for managing flight data with PostgreSQL.

Usage Examples:
    # Setup database and load data
    python postgres_connection.py --setup --load

    # Query operations
    python postgres_connection.py --list
    python postgres_connection.py --stats

    # Help
    python postgres_connection.py --help
"""

from __future__ import annotations

import argparse
import csv
import logging
import os
import sys
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# CONFIGURATION

class Config:
    """Central configuration management."""
    
    @staticmethod
    def get_env(key: str, default: str = "") -> str:
        """Get environment variable with default."""
        return os.getenv(key, default)
    
    @property
    def log_level(self) -> str:
        return self.get_env("LOG_LEVEL", "INFO")
    
    @property
    def db_host(self) -> str:
        return self.get_env("DB_HOST", "localhost")
    
    @property
    def db_port(self) -> str:
        return self.get_env("DB_PORT", "5432")
    
    @property
    def db_name(self) -> str:
        return self.get_env("DB_NAME", "aviation_data")
    
    @property
    def db_user(self) -> str:
        return self.get_env("DB_USER", "postgres")
    
    @property
    def db_password(self) -> str:
        return self.get_env("DB_PASSWORD", "")
    
    @property
    def csv_file_path(self) -> str:
        return self.get_env("CSV_FILE_PATH", "../data/csv/flights_sample.csv")


config = Config()

# LOGGING SETUP

class LoggerSetup:
    """Configure application logging."""
    
    _initialized = False
    
    @classmethod
    def setup(cls) -> None:
        """Initialize logging configuration."""
        if cls._initialized:
            return
        
        # Create logs directory
        log_dir = Path("logs")
        log_dir.mkdir(exist_ok=True)
        
        # Configure log file
        log_file = log_dir / f"aviation_{datetime.now().strftime('%Y%m%d')}.log"
        
        # Configure logging
        logging.basicConfig(
            level=getattr(logging, config.log_level),
            format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
            handlers=[
                logging.FileHandler(log_file),
                logging.StreamHandler(),  # Also print to console
            ],
        )
        
        cls._initialized = True
    
    @staticmethod
    def get_logger(name: str) -> logging.Logger:
        """Get a named logger."""
        return logging.getLogger(name)


# Initialize logging
LoggerSetup.setup()
logger = LoggerSetup.get_logger(__name__)

# DATABASE SCHEMA

SCHEMA_SQL = """
-- =============================================================
-- Aviation Database Schema
-- =============================================================
-- Run once via setup.py or manually:
--   psql -U postgres -d aviation_data -f schema.sql

-- =============================================================
-- Tables
-- =============================================================

CREATE TABLE IF NOT EXISTS flights (
    id             SERIAL PRIMARY KEY,
    origin         VARCHAR(10)              NOT NULL,
    destination    VARCHAR(10)              NOT NULL,
    airline        VARCHAR(255)             NOT NULL,
    duration_mins  INTEGER,
    date           DATE,
    created_at     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- =============================================================
-- Indexes
-- =============================================================

CREATE INDEX IF NOT EXISTS idx_flights_airline     ON flights (airline);
CREATE INDEX IF NOT EXISTS idx_flights_origin      ON flights (origin);
CREATE INDEX IF NOT EXISTS idx_flights_destination ON flights (destination);
CREATE INDEX IF NOT EXISTS idx_flights_date        ON flights (date);

-- =============================================================
-- Auto-update updated_at on row change
-- =============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_flights_updated_at ON flights;
CREATE TRIGGER trg_flights_updated_at
    BEFORE UPDATE ON flights
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- =============================================================
-- Convenience views
-- =============================================================

CREATE OR REPLACE VIEW flight_details AS
SELECT id, origin, destination, airline, duration_mins, date, created_at
FROM flights
ORDER BY date DESC NULLS LAST;

CREATE OR REPLACE VIEW airline_statistics AS
SELECT
    airline,
    COUNT(*)                    AS flight_count,
    AVG(duration_mins)::int     AS avg_duration_mins,
    MIN(duration_mins)          AS shortest_mins,
    MAX(duration_mins)          AS longest_mins,
    COUNT(DISTINCT origin)      AS unique_origins,
    COUNT(DISTINCT destination) AS unique_destinations
FROM flights
GROUP BY airline
ORDER BY flight_count DESC;

CREATE OR REPLACE VIEW route_statistics AS
SELECT
    origin,
    destination,
    COUNT(*)                AS flight_count,
    AVG(duration_mins)::int AS avg_duration_mins
FROM flights
GROUP BY origin, destination
ORDER BY flight_count DESC;
"""

# DATABASE CONNECTION

class DatabaseConnection:
    """Database connection manager with context manager support."""
    
    def __init__(self) -> None:
        """Initialize connection parameters."""
        self._conn = None
        self._cursor = None
    
    def _connection_params(self) -> Dict[str, str]:
        """Get database connection parameters."""
        return {
            "host": config.db_host,
            "port": config.db_port,
            "dbname": config.db_name,
            "user": config.db_user,
            "password": config.db_password,
        }
    
    def connect(self) -> None:
        """Establish database connection."""
        self._conn = psycopg2.connect(**self._connection_params())
        self._conn.autocommit = True
        self._cursor = self._conn.cursor(cursor_factory=RealDictCursor)
        logger.info("Connected to database '%s'", config.db_name)
    
    def close(self) -> None:
        """Close database connection."""
        if self._cursor:
            self._cursor.close()
        if self._conn:
            self._conn.close()
            logger.debug("Database connection closed")
    
    def __enter__(self) -> "DatabaseConnection":
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        self.close()
        if exc_type:
            logger.error("Exception in context: %s: %s", exc_type.__name__, exc_val)
    
    def execute(self, query: str, params: Tuple = (), fetch: bool = True) -> List[Dict]:
        """Execute SQL query and return results."""
        if not self._conn:
            self.connect()
        
        self._cursor.execute(query, params)
        return list(self._cursor.fetchall()) if fetch else []
    
    # Database Setup Methods
    
    def create_database(self) -> bool:
        """Create database if it doesn't exist."""
        try:
            # Connect to default postgres database
            conn = psycopg2.connect(
                host=config.db_host,
                port=config.db_port,
                user=config.db_user,
                password=config.db_password,
                dbname="aviation_data"
            )
            conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            
            with conn.cursor() as cur:
                cur.execute("SELECT 1 FROM pg_database WHERE datname = %s", (config.db_name,))
                if cur.fetchone():
                    logger.info("Database '%s' already exists", config.db_name)
                else:
                    cur.execute(f'CREATE DATABASE "{config.db_name}"')
                    logger.info("Database '%s' created", config.db_name)
            
            conn.close()
            return True
        except Exception as e:
            logger.error("Failed to create database: %s", e)
            return False
    
    def create_schema(self) -> bool:
        """Create database schema."""
        try:
            self.execute(SCHEMA_SQL, fetch=False)
            logger.info("Database schema created successfully")
            return True
        except Exception as e:
            logger.error("Failed to create schema: %s", e)
            return False
        
    # Data Loading Methods
    
    def load_csv(self, csv_path: str, table: str = "flights") -> Tuple[int, int]:
        """
        Load CSV data into database.
        
        Returns:
            Tuple of (rows_inserted, rows_failed)
        """
        file_path = Path(csv_path)
        if not file_path.exists():
            logger.error("CSV file not found: %s", csv_path)
            return 0, 0
        
        try:
            with file_path.open(newline="", encoding="utf-8") as f:
                reader = csv.DictReader(f)
                rows = list(reader)
            
            if not rows:
                logger.warning("CSV file is empty: %s", csv_path)
                return 0, 0
            
            columns = list(rows[0].keys())
            placeholders = ", ".join(["%s"] * len(columns))
            column_names = ", ".join(columns)
            query = f"INSERT INTO {table} ({column_names}) VALUES ({placeholders})"
            
            # Prepare values
            values = []
            for row in rows:
                row_values = []
                for col in columns:
                    val = row.get(col, "")
                    # Convert empty strings to None for numeric fields
                    if val == "" and col in ["duration_mins"]:
                        val = None
                    row_values.append(val)
                values.append(tuple(row_values))
            
            # Bulk insert
            self._cursor.executemany(query, values)
            logger.info("Loaded %d rows from '%s' into '%s'", len(values), file_path.name, table)
            return len(values), 0
            
        except Exception as e:
            logger.error("Failed to load CSV: %s", e)
            return 0, len(rows) if 'rows' in locals() else 0
    
    # Query Methods
    
    def get_all_flights(self, limit: Optional[int] = None) -> List[Dict]:
        """Get all flights."""
        query = """
            SELECT id, origin, destination, airline,
                   duration_mins, date
            FROM flights 
            ORDER BY date DESC, id
        """
        if limit:
            query += f" LIMIT {limit}"
        return self.execute(query)
    
    def get_statistics(self) -> Dict[str, Any]:
        """Get database statistics."""
        # Main statistics
        stats = self.execute("""
            SELECT
                COUNT(*) AS total_flights,
                COUNT(DISTINCT airline) AS total_airlines,
                COUNT(DISTINCT origin) AS total_origins,
                COUNT(DISTINCT destination) AS total_destinations,
                COALESCE(AVG(duration_mins), 0)::INT AS avg_duration,
                COALESCE(MIN(duration_mins), 0) AS min_duration,
                COALESCE(MAX(duration_mins), 0) AS max_duration,
                MIN(date) AS earliest_date,
                MAX(date) AS latest_date
            FROM flights
        """)
        
        result = dict(stats[0]) if stats else {}
        
        return result

# COMMAND HANDLERS

class FlightCommands:
    """Command handlers for flight operations."""
    
    @staticmethod
    def setup_database() -> bool:
        """Setup database and schema."""
        logger.info("Setting up database...")
        with DatabaseConnection() as db:
            if not db.create_database():
                return False
            if not db.create_schema():
                return False
        logger.info("Database setup complete")
        return True
    
    @staticmethod
    def load_data(csv_path: Optional[str] = None) -> bool:
        """Load data from CSV file."""
        file_path = csv_path or config.csv_file_path
        logger.info("Loading data from: %s", file_path)
        
        with DatabaseConnection() as db:
            inserted, failed = db.load_csv(file_path)
            
            if inserted > 0:
                stats = db.get_statistics()
                logger.info("Success: %d rows inserted", inserted)
                logger.info("Total flights in database: %d", stats.get("total_flights", 0))
                return True
            else:
                logger.error("No data loaded")
                return False
    
    @staticmethod
    def list_flights(limit: Optional[int] = None) -> None:
        """List all flights."""
        with DatabaseConnection() as db:
            flights = db.get_all_flights(limit)
            
            if not flights:
                logger.info("No flights found in database")
                return
            
            logger.info("=" * 80)
            logger.info("FLIGHTS LIST")
            logger.info("=" * 80)
            
            for flight in flights:
                logger.info(
                    "ID: %-4d | %-4s → %-4s | %-20s | %4d min | %s | %s",
                    flight["id"],
                    flight["origin"],
                    flight["destination"],
                    flight["airline"][:20],
                    flight.get("duration_mins", 0),
                    flight["date"],
                    flight.get("status", "Scheduled")
                )
            
            logger.info("=" * 80)
            logger.info("Total: %d flights", len(flights))
    
    
    @staticmethod
    def show_statistics() -> None:
        """Show database statistics."""
        with DatabaseConnection() as db:
            stats = db.get_statistics()
            
            logger.info("=" * 60)
            logger.info("DATABASE STATISTICS")
            logger.info("=" * 60)
            
            # Display stats
            stat_items = [
                ("Total Flights", "total_flights"),
                ("Total Airlines", "total_airlines"),
                ("Unique Origins", "total_origins"),
                ("Unique Destinations", "total_destinations"),
                ("Average Duration (min)", "avg_duration"),
                ("Shortest Flight (min)", "min_duration"),
                ("Longest Flight (min)", "max_duration"),
                ("Earliest Flight", "earliest_date"),
                ("Latest Flight", "latest_date"),
            ]
            
            for label, key in stat_items:
                if key in stats:
                    logger.info("%-25s: %s", label, stats[key])

            
            logger.info("=" * 60)

# MAIN APPLICATION

def create_parser() -> argparse.ArgumentParser:
    """Create command line argument parser."""
    parser = argparse.ArgumentParser(
        description="Aviation Database Management System",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Setup and load data
  python postgres_connection.py --setup --load
  
  # Query operations
  python postgres_connection.py --list --limit 10
  python postgres_connection.py --stats
  
  # Load specific CSV file
  python postgres_connection.py --load data/my_flights.csv
        """
    )
    
    # Actions
    parser.add_argument("--setup", action="store_true", help="Setup database and schema")
    parser.add_argument("--load", nargs="?", const=True, default=False, 
                       help="Load CSV data (optional file path)")
    parser.add_argument("--list", action="store_true", help="List all flights")
    parser.add_argument("--limit", type=int, help="Limit number of flights to show")
    parser.add_argument("--stats", action="store_true", help="Show database statistics")
    
    return parser


def main() -> None:
    """Main application entry point."""
    parser = create_parser()
    args = parser.parse_args()
    
    # Handle --load with optional file path
    load_file = None
    if args.load:
        load_file = args.load if isinstance(args.load, str) else None
    
    # Execute commands
    if args.setup:
        if not FlightCommands.setup_database():
            sys.exit(1)
    
    if load_file or args.load is True:
        if not FlightCommands.load_data(load_file):
            sys.exit(1)
    
    if args.list:
        FlightCommands.list_flights(args.limit)
    
    
    if args.stats:
        FlightCommands.show_statistics()
    
    # Show help if no command provided
    if not any([args.setup, args.load, args.list, args.stats]):
        parser.print_help()
        logger.info("\nTry: python postgres_connection.py --setup --load")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        logger.info("\nOperation cancelled by user")
        sys.exit(0)
    except Exception as e:
        logger.error("Unexpected error: %s", e, exc_info=True)
        sys.exit(1)