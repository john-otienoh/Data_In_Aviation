-- =============================================================================
-- DAY 3 SQL ANSWERS — INNER JOIN · LEFT JOIN · MULTI-TABLE QUERIES
-- =============================================================================
-- Schema  :
--   flights  (flight_id, origin, destination, airline, duration_mins, date)
--   airports (iata_code, airport_name, city, country, continent)
--   airlines (iata_code, airline_name, country_of_origin, alliance)
-- Datasets: flights.csv, airports_w1.csv, airlines_w1.csv
-- Topics  : INNER JOIN, LEFT JOIN, double airport join, NULL detection,
--           filtering after joining, sorting and aliases across tables
-- =============================================================================
-- TABLE ALIAS CONVENTION (use these consistently in every join query):
--   f   = flights
--   dep = airports joined on origin   (departure airport)
--   arr = airports joined on destination (arrival airport)
--   al  = airlines
-- =============================================================================


-- =============================================================================
-- SECTION 1: BASIC INNER JOIN — TWO TABLES (Q1–Q8)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1. Join flights to airports — show full airport name for origin
-- -----------------------------------------------------------------------------
-- WHY: INNER JOIN (= JOIN) connects two tables on a matching column.
--      Only rows with a match in BOTH tables are returned.
--      f.origin must equal dep.iata_code for the row to appear.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS "Departure Airport",
       dep.city           AS "City",
       f.destination,
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin = dep.iata_code
ORDER BY f.date;

-- WARNING: If any flight has an origin code not in airports, that flight
-- silently disappears. Use LEFT JOIN if you want all flights to appear.


-- -----------------------------------------------------------------------------
-- Q2. Join flights to airports — show destination city name
-- -----------------------------------------------------------------------------
-- WHY: The join is on destination this time, not origin.
--      Read the question carefully to identify which column to match on.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       arr.city           AS "Destination City",
       arr.country        AS "Destination Country",
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY f.date;


-- -----------------------------------------------------------------------------
-- Q3. Join flights to airlines — show airline's country of origin
-- -----------------------------------------------------------------------------
-- WHY: flights.airline matches airlines.iata_code (both are IATA codes).
--      This brings airline details into the flight result.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       f.destination,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS "Airline Home Country",
       f.duration_mins
FROM flights f
JOIN airlines al ON f.airline = al.iata_code
ORDER BY al.country_of_origin, f.date;


-- -----------------------------------------------------------------------------
-- Q4. Show each flight with full departure airport name and country
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS "Departure Airport",
       dep.country        AS "Country",
       f.destination,
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin = dep.iata_code
ORDER BY dep.country, f.date;


-- -----------------------------------------------------------------------------
-- Q5. Show each flight with full arrival airport name and continent
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       arr.airport_name   AS "Arrival Airport",
       arr.continent      AS "Arrival Continent",
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY arr.continent, f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q6. Show each flight with its airline alliance
-- -----------------------------------------------------------------------------
-- WHY: The alliance column lives in airlines, not flights.
--      Joining through the airline code brings it into the flight result.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       f.origin,
       f.destination,
       f.duration_mins
FROM flights f
JOIN airlines al ON f.airline = al.iata_code
ORDER BY al.alliance, al.airline_name;


-- -----------------------------------------------------------------------------
-- Q7. Show airline name, origin, destination, and duration only
-- -----------------------------------------------------------------------------
SELECT al.airline_name    AS "Airline",
       f.origin,
       f.destination,
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airlines al ON f.airline = al.iata_code
ORDER BY al.airline_name, f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q8. Show only flights where the origin airport is in Kenya
-- -----------------------------------------------------------------------------
-- WHY: After joining, WHERE can filter on any column from any joined table.
--      dep.country = 'Kenya' filters to Kenyan departure airports only.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS "Departure Airport",
       dep.city           AS "City",
       dep.country        AS "Country",
       f.destination,
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.country = 'Kenya'
ORDER BY f.date;


-- =============================================================================
-- SECTION 2: JOINING ON BOTH ORIGIN AND DESTINATION (Q9–Q15)
-- =============================================================================
-- KEY PATTERN: Join airports table TWICE using two different aliases.
--   dep = airports for departure (origin)
--   arr = airports for arrival  (destination)
-- This is the most important join pattern in aviation SQL.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q9. Join airports twice — show both departure and arrival city names
-- -----------------------------------------------------------------------------
-- WHY: The same airports table serves two roles simultaneously.
--      Without aliases, PostgreSQL cannot distinguish which instance you mean.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)",
       f.date
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q10. Show full origin city and destination city side by side
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "Origin City",
       arr.city           AS "Destination City",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY dep.city, arr.city;


-- -----------------------------------------------------------------------------
-- Q11. Show origin country and destination country in the same row
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.country        AS "Origin Country",
       arr.country        AS "Destination Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY dep.country, arr.country;


-- -----------------------------------------------------------------------------
-- Q12. Show origin continent and destination continent
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.continent      AS "Origin Continent",
       arr.continent      AS "Arrival Continent",
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY dep.continent, arr.continent;


-- -----------------------------------------------------------------------------
-- Q13. Find all true international flights — different origin and destination countries
-- -----------------------------------------------------------------------------
-- WHY: After joining both airport tables, WHERE can compare columns
--      from dep and arr. dep.country != arr.country = international flight.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.country != arr.country
ORDER BY dep.country;


-- -----------------------------------------------------------------------------
-- Q14. Find all flights where origin and destination are on the same continent
-- -----------------------------------------------------------------------------
-- WHY: Same logic as Q13 but using = instead of != for continent comparison.
--      These are regional/domestic continental flights.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       dep.continent      AS "Continent",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = arr.continent
ORDER BY dep.continent, f.duration_mins;


-- -----------------------------------------------------------------------------
-- Q15. Full route description: "Nairobi, Kenya → London, United Kingdom"
-- -----------------------------------------------------------------------------
-- WHY: The || operator concatenates strings in PostgreSQL.
--      This pattern appears in every airline dashboard and customer-facing system.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city || ', ' || dep.country
       || ' → '
       || arr.city || ', ' || arr.country     AS "Route",
       al.airline_name                         AS "Airline",
       f.duration_mins                         AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY f.duration_mins DESC;


-- =============================================================================
-- SECTION 3: FILTERING AFTER JOINING (Q16–Q25)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q16. After joining, find flights departing from airports in Africa
-- -----------------------------------------------------------------------------
-- WHY: JOIN first to get continent data, then WHERE filters on that column.
--      This avoids hardcoding a list of African airport codes.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Africa'
ORDER BY dep.country, f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q17. Flights arriving into airports in Asia
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE arr.continent = 'Asia'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q18. Flights operated by airlines based in the United Kingdom
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       al.country_of_origin AS "Airline Home",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE al.country_of_origin = 'United Kingdom'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q19. Star Alliance member airline flights
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       dep.city           AS "From",
       arr.city           AS "To",
       f.duration_mins,
       f.date
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.alliance = 'Star Alliance'
ORDER BY f.date;


-- -----------------------------------------------------------------------------
-- Q20. Flights where both origin AND destination are in Africa
-- -----------------------------------------------------------------------------
-- WHY: Both continent conditions must be true simultaneously.
--      This identifies intra-African routes — a key strategic segment.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Africa'
  AND arr.continent = 'Africa'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q21. Flights departing from Kenya, sorted by duration
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS "Departure Airport",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.country = 'Kenya'
ORDER BY f.duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q22. Oneworld alliance flights longer than 400 minutes
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name    AS "Airline",
       dep.city           AS "From",
       arr.city           AS "To",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.alliance      = 'Oneworld'
  AND f.duration_mins  > 400
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q23. Flights from Europe to the Middle East — with full city names
-- -----------------------------------------------------------------------------
-- WHY: Middle East = United Arab Emirates, Saudi Arabia in this dataset.
--      Adjust the country list based on what is in your airports table.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Europe'
  AND arr.country   IN ('United Arab Emirates', 'Saudi Arabia')
ORDER BY f.duration_mins;

-- ALTERNATIVE — if continent = 'Asia' with sub-region logic:
-- WHERE dep.continent = 'Europe'
--   AND arr.country IN ('United Arab Emirates','Saudi Arabia',
--                       'Qatar','Kuwait','Bahrain','Oman','Jordan')


-- -----------------------------------------------------------------------------
-- Q24. Flights arriving in a country different from the airline's home country
-- -----------------------------------------------------------------------------
-- WHY: When the airline's country != the destination country,
--      the carrier is operating a foreign inbound route.
--      This reveals foreign carrier penetration into each market.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS "Airline Home",
       dep.city               AS "From City",
       arr.city               AS "To City",
       arr.country            AS "Destination Country",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.country_of_origin != arr.country
ORDER BY arr.country, al.airline_name;


-- -----------------------------------------------------------------------------
-- Q25. Emirates flights arriving into African airports
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.iata_code     = 'EK'
  AND arr.continent    = 'Africa'
ORDER BY f.duration_mins DESC;


-- =============================================================================
-- SECTION 4: LEFT JOIN — CATCHING MISSING DATA (Q26–Q32)
-- =============================================================================
-- KEY PRINCIPLE:
--   LEFT JOIN returns ALL rows from the LEFT table.
--   For rows with no match in the right table, right-side columns = NULL.
--   Filter WHERE right_table.column IS NULL to find unmatched rows.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q26. Find flights whose origin has no matching airport record
-- -----------------------------------------------------------------------------
-- WHY: LEFT JOIN keeps all flights. Where origin does not match any
--      airports.iata_code, all dep.* columns become NULL.
--      IS NULL catches those unmatched flights.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin           AS "Unmatched Origin",
       f.destination,
       f.airline
FROM flights f
LEFT JOIN airports dep ON f.origin = dep.iata_code
WHERE dep.iata_code IS NULL;


-- -----------------------------------------------------------------------------
-- Q27. Find flights whose airline has no matching airline record
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       f.destination,
       f.airline          AS "Unmatched Airline Code"
FROM flights f
LEFT JOIN airlines al ON f.airline = al.iata_code
WHERE al.iata_code IS NULL;


-- -----------------------------------------------------------------------------
-- Q28. Find airports that have NO departing flights in the dataset
-- -----------------------------------------------------------------------------
-- WHY: FROM airports LEFT JOIN flights — airports drives the result.
--      Airports with no flights produce NULL in f.flight_id.
--      This is the classic "find what is missing" LEFT JOIN pattern.
-- -----------------------------------------------------------------------------
SELECT a.iata_code,
       a.airport_name,
       a.city,
       a.country,
       a.continent
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.origin
WHERE f.flight_id IS NULL
ORDER BY a.continent, a.country;


-- -----------------------------------------------------------------------------
-- Q29. Find airports that no flight in the dataset lands at
-- -----------------------------------------------------------------------------
-- WHY: Same pattern as Q28 but LEFT JOIN on destination instead of origin.
-- -----------------------------------------------------------------------------
SELECT a.iata_code,
       a.airport_name,
       a.city,
       a.country
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.destination
WHERE f.flight_id IS NULL
ORDER BY a.country;


-- -----------------------------------------------------------------------------
-- Q30. Find airlines in the airlines table that have no flights recorded
-- -----------------------------------------------------------------------------
SELECT al.iata_code,
       al.airline_name,
       al.country_of_origin,
       al.alliance
FROM airlines al
LEFT JOIN flights f ON al.iata_code = f.airline
WHERE f.flight_id IS NULL
ORDER BY al.airline_name;


-- -----------------------------------------------------------------------------
-- Q31. Show all flights with destination city — NULL where airport not found
-- -----------------------------------------------------------------------------
-- WHY: LEFT JOIN means all 100 flights appear. Flights whose destination
--      is not in airports show NULL for arr.city — visible as a gap.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       f.destination,
       arr.city           AS "Destination City",  -- NULL if no match
       f.airline,
       f.duration_mins
FROM flights f
LEFT JOIN airports arr ON f.destination = arr.iata_code
ORDER BY f.date;


-- -----------------------------------------------------------------------------
-- Q32. Produce a list of airports with no matching flights — data quality gaps
-- -----------------------------------------------------------------------------
-- WHY: Combining LEFT JOIN + IS NULL + clear output = a data quality report.
--      This is the first query a data engineer runs on a new aviation dataset.
-- -----------------------------------------------------------------------------
SELECT a.iata_code          AS "Airport Code",
       a.airport_name       AS "Airport Name",
       a.city               AS "City",
       a.country            AS "Country",
       a.continent          AS "Continent",
       'No flights in dataset' AS "Status"
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.origin
WHERE f.flight_id IS NULL
ORDER BY a.continent, a.country;


-- =============================================================================
-- SECTION 5: JOINS WITH SORTING AND ALIASES (Q33–Q37)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q33. Join flights and airports — alias airport name as departure_airport, sort by country
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS departure_airport,
       dep.city,
       dep.country,
       f.destination,
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin = dep.iata_code
ORDER BY dep.country ASC, f.date ASC;


-- -----------------------------------------------------------------------------
-- Q34. Join flights to airlines — label airline country as carrier_country, sort alphabetically
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS carrier_country,
       al.alliance,
       f.origin,
       f.destination,
       f.duration_mins
FROM flights f
JOIN airlines al ON f.airline = al.iata_code
ORDER BY carrier_country ASC, al.airline_name ASC;


-- -----------------------------------------------------------------------------
-- Q35. Double airport join — rename as origin_city and destination_city, sort by duration
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS origin_city,
       arr.city           AS destination_city,
       f.airline,
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q36. African-departure flights sorted by duration descending
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Africa'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q37. Sort by alliance, then by duration within each alliance
-- -----------------------------------------------------------------------------
-- WHY: Multi-column ORDER BY — sort by alliance first, then within
--      ties on alliance, sort by duration. Alliance NULL values sort last.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.alliance        AS "Alliance",
       al.airline_name    AS "Airline",
       dep.city           AS "From",
       arr.city           AS "To",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY al.alliance ASC NULLS LAST, f.duration_mins DESC;


-- =============================================================================
-- SECTION 6: REAL-WORLD BUSINESS QUESTIONS (Q38–Q55)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q38. Network Map: full city-to-city pairs for every route
-- -----------------------------------------------------------------------------
-- WHY: This is the foundation of any airline route map visualisation.
--      City names are far more meaningful to stakeholders than IATA codes.
-- -----------------------------------------------------------------------------
SELECT DISTINCT
       dep.city || ', ' || dep.country    AS "Origin",
       arr.city || ', ' || arr.country    AS "Destination",
       al.airline_name                    AS "Airline"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY "Origin", "Destination";


-- -----------------------------------------------------------------------------
-- Q39. Alliance Reporting: SkyTeam member airline flights
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       dep.city           AS "From",
       arr.city           AS "To",
       f.duration_mins,
       f.date
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.alliance = 'SkyTeam'
ORDER BY al.airline_name, f.date;


-- -----------------------------------------------------------------------------
-- Q40. Hub Dominance: flights from Nairobi with full airport name
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.airport_name   AS "Departure Airport",
       arr.city           AS "To City",
       al.airline_name    AS "Airline",
       f.duration_mins,
       f.date
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE f.origin = 'NBO'
ORDER BY f.date;


-- -----------------------------------------------------------------------------
-- Q41. International Route Audit: flights crossing country borders
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "Origin City",
       dep.country        AS "Origin Country",
       arr.city           AS "Destination City",
       arr.country        AS "Destination Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.country != arr.country
ORDER BY dep.country, arr.country;


-- -----------------------------------------------------------------------------
-- Q42. Continent Traffic Flow: Africa to Middle East flights
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Africa'
  AND arr.country   IN ('United Arab Emirates', 'Saudi Arabia')
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q43. Codeshare Eligibility: Star Alliance flights arriving at Star Alliance hubs
-- -----------------------------------------------------------------------------
-- WHY: Find flights where the operating airline AND the arrival airport's
--      primary airline are both Star Alliance members.
--      NBO (Kenya Airways/SkyTeam), SIN (Singapore Airlines/Star Alliance) etc.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       dep.city           AS "From",
       arr.city           AS "To",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.alliance = 'Star Alliance'
ORDER BY arr.city;


-- -----------------------------------------------------------------------------
-- Q44. Foreign Carrier Analysis: non-Kenyan airlines arriving into Kenya
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS "Airline Country",
       dep.city               AS "From City",
       arr.airport_name       AS "Arrival Airport",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE arr.country              = 'Kenya'
  AND al.country_of_origin     != 'Kenya'
ORDER BY al.airline_name;


-- -----------------------------------------------------------------------------
-- Q45. Ground Handler Planning: arrivals on 2024-01-15 with full airport details
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.airport_name   AS "Arrival Airport",
       arr.country        AS "Country",
       al.airline_name    AS "Airline",
       f.duration_mins,
       f.date
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE f.date = '2024-01-15'
ORDER BY arr.airport_name;


-- -----------------------------------------------------------------------------
-- Q46. Interline Agreement: flights where airline home ≠ origin AND ≠ destination
-- -----------------------------------------------------------------------------
-- WHY: The carrier is operating a route that connects two countries neither
--      of which is its home market — fully foreign operations.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS "Airline Home",
       dep.city               AS "From City",
       dep.country            AS "From Country",
       arr.city               AS "To City",
       arr.country            AS "To Country",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.country_of_origin != dep.country
  AND al.country_of_origin != arr.country
ORDER BY al.airline_name;


-- -----------------------------------------------------------------------------
-- Q47. Capacity by Continent: flights arriving in Europe sorted by duration
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "To City",
       arr.country        AS "Country",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE arr.continent = 'Europe'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q48. Revenue Route Report: Emirates routes sorted by duration
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "Origin City",
       arr.city           AS "Destination City",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)",
       f.date
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.iata_code = 'EK'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q49. Alliance Gap Analysis: alliance airlines with zero flights
-- -----------------------------------------------------------------------------
-- WHY: LEFT JOIN from airlines to flights. Airlines with no flights
--      produce NULL in f.flight_id. This reveals underrepresented partners.
-- -----------------------------------------------------------------------------
SELECT al.airline_name,
       al.alliance,
       al.country_of_origin
FROM airlines al
LEFT JOIN flights f ON al.iata_code = f.airline
WHERE f.flight_id IS NULL
  AND al.alliance IS NOT NULL
ORDER BY al.alliance, al.airline_name;


-- -----------------------------------------------------------------------------
-- Q50. Airport Utilization: airports with no departing flights
-- -----------------------------------------------------------------------------
SELECT a.iata_code,
       a.airport_name,
       a.city,
       a.country,
       a.continent
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.origin
WHERE f.flight_id IS NULL
ORDER BY a.continent, a.country;


-- -----------------------------------------------------------------------------
-- Q51. Bilateral Air Service: routes that operate in both directions
-- -----------------------------------------------------------------------------
-- WHY: Self-join flights table on swapped origin/destination.
--      f1 is the outbound flight; f2 is the return flight.
--      DISTINCT prevents duplicate route pairs.
-- -----------------------------------------------------------------------------
SELECT DISTINCT
       dep.city           AS "City A",
       arr.city           AS "City B"
FROM flights f1
JOIN flights f2
  ON f1.origin      = f2.destination
 AND f1.destination = f2.origin
JOIN airports dep ON f1.origin      = dep.iata_code
JOIN airports arr ON f1.destination = arr.iata_code
WHERE f1.origin < f1.destination  -- prevents (A,B) AND (B,A) both appearing
ORDER BY "City A";


-- -----------------------------------------------------------------------------
-- Q52. Domestic vs International: rows showing both types (observe not count)
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.country        AS "Origin Country",
       arr.country        AS "Destination Country",
       CASE WHEN dep.country = arr.country
            THEN 'Domestic'
            ELSE 'International'
       END                AS "Flight Type",
       f.duration_mins
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
ORDER BY "Flight Type", f.duration_mins;


-- -----------------------------------------------------------------------------
-- Q53. Turnaround Complexity: short-haul arrivals into major hub airports
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       arr.city           AS "Hub City",
       arr.airport_name   AS "Hub Airport",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE f.duration_mins < 150
  AND f.destination IN ('NBO','LHR','DXB','SIN','JFK','CDG','SYD')
ORDER BY f.duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q54. African Aviation Network: flights with African origin or destination
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.continent      AS "From Continent",
       arr.city           AS "To City",
       arr.continent      AS "To Continent",
       al.airline_name    AS "Airline",
       f.duration_mins,
       f.date
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE dep.continent = 'Africa'
   OR arr.continent = 'Africa'
ORDER BY f.date;


-- -----------------------------------------------------------------------------
-- Q55. Fuel Planning: ultra-long-haul flights with full origin/destination countries
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.country        AS "Origin Country",
       arr.country        AS "Destination Country",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE f.duration_mins > 600
ORDER BY f.duration_mins DESC;


-- =============================================================================
-- SECTION 7: CHALLENGE QUESTIONS (Q56–Q60)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q56. All three tables joined: origin city, destination city, airline, alliance, duration
-- -----------------------------------------------------------------------------
-- WHY: This is the full aviation join pattern used in every production report.
--      All four table aliases (f, dep, arr, al) are in play simultaneously.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "Origin City",
       arr.city           AS "Destination City",
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       f.duration_mins    AS "Duration (mins)",
       f.date
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q57. Non-African airline flying between two African cities
-- -----------------------------------------------------------------------------
-- WHY: Identifies foreign carriers operating intra-African routes —
--      potential competition for Pan-African carriers like KQ and ET.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       al.airline_name        AS "Airline",
       al.country_of_origin   AS "Airline Home Country",
       dep.city               AS "From City",
       arr.city               AS "To City",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE dep.continent           = 'Africa'
  AND arr.continent           = 'Africa'
  AND al.country_of_origin NOT IN (
      SELECT DISTINCT country FROM airports WHERE continent = 'Africa'
  )
ORDER BY al.airline_name;


-- -----------------------------------------------------------------------------
-- Q58. Oneworld flights from Asia to Europe, with full city names, by duration
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.country        AS "From Country",
       arr.city           AS "To City",
       arr.country        AS "To Country",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE al.alliance     = 'Oneworld'
  AND dep.continent   = 'Asia'
  AND arr.continent   = 'Europe'
ORDER BY f.duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q59. Routes under 200 minutes but between different continents — anomaly check
-- -----------------------------------------------------------------------------
-- WHY: A flight under 200 minutes (3h20m) between different continents is
--      physically suspicious — worth investigating as a possible data error
--      or very unusual geography (e.g. Canary Islands: Europe-Africa boundary).
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       dep.city           AS "From City",
       dep.continent      AS "From Continent",
       arr.city           AS "To City",
       arr.continent      AS "To Continent",
       al.airline_name    AS "Airline",
       f.duration_mins    AS "Duration (mins)"
FROM flights f
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
WHERE f.duration_mins   < 200
  AND dep.continent     != arr.continent
ORDER BY f.duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q60. Full data quality audit: flights missing airport or airline match
-- -----------------------------------------------------------------------------
-- WHY: Three LEFT JOINs simultaneously. Any NULL in dep, arr, or al
--      columns indicates a broken reference — a data quality failure.
--      This is the first query a data engineer runs on any new aviation dataset.
-- -----------------------------------------------------------------------------
SELECT f.flight_id,
       f.origin,
       f.destination,
       f.airline,
       dep.iata_code      AS "Origin Match",     -- NULL = missing
       arr.iata_code      AS "Dest Match",        -- NULL = missing
       al.iata_code       AS "Airline Match",     -- NULL = missing
       CASE
           WHEN dep.iata_code IS NULL     THEN 'Missing Origin Airport'
           WHEN arr.iata_code IS NULL     THEN 'Missing Destination Airport'
           WHEN al.iata_code  IS NULL     THEN 'Missing Airline'
           ELSE 'Clean'
       END                AS "Data Quality Status"
FROM flights f
LEFT JOIN airports dep ON f.origin      = dep.iata_code
LEFT JOIN airports arr ON f.destination = arr.iata_code
LEFT JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY "Data Quality Status", f.flight_id;


-- =============================================================================
-- END OF DAY 3 ANSWERS
-- =============================================================================
-- Key rules to remember from Day 3:
--
--   1. JOIN (INNER JOIN): returns only rows with a match in BOTH tables
--   2. LEFT JOIN: returns ALL rows from the left table; NULLs where no match
--   3. Always alias tables for readability: f, dep, arr, al
--   4. Join airports TWICE (as dep and arr) to get both city names
--   5. Use WHERE after JOIN to filter on any joined column
--   6. IS NULL after LEFT JOIN = "no matching record" = data quality gap
--   7. The || operator concatenates strings for readable route labels
--   8. dep.country != arr.country = international flight
--   9. dep.continent = arr.continent = regional continental flight
--  10. Always prefer LEFT JOIN in data quality checks to avoid silent data loss
-- =============================================================================
