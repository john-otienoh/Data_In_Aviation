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