-- =============================================================================
-- DAY 1 SQL ANSWERS — SELECT · WHERE · ORDER BY · ALIASES
-- =============================================================================
-- Schema  : flights (flight_id, origin, destination, airline, duration_mins, date)
-- Dataset : flights.csv  — 100 rows
-- Topics  : SELECT, WHERE, ORDER BY, aliases, AND/OR/NOT, IN, BETWEEN
-- =============================================================================


-- =============================================================================
-- SECTION 1: BASIC RETRIEVAL (Q1–Q8)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1. Retrieve every flight in the dataset
-- -----------------------------------------------------------------------------
-- WHY: SELECT * returns every column; FROM flights names the table.
--      The semicolon ends the statement.
--      Use SELECT * only for quick exploration — always name columns in scripts.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights;

-- ALTERNATIVE — name every column explicitly (production standard):
-- SELECT flight_id, origin, destination, airline, duration_mins, date
-- FROM flights;


-- -----------------------------------------------------------------------------
-- Q2. Show only the flight ID, origin, and destination for all flights
-- -----------------------------------------------------------------------------
-- WHY: Listing only the columns you need is called a "projection".
--      It reduces the data sent across the network and documents intent.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination
FROM flights;


-- -----------------------------------------------------------------------------
-- Q3. Display all flights and rename columns to readable names
-- -----------------------------------------------------------------------------
-- WHY: AS assigns a display alias. Aliases with spaces need double quotes.
--      The underlying column name in the table does not change.
-- -----------------------------------------------------------------------------
SELECT flight_id      AS "Flight ID",
       origin         AS "Origin",
       destination    AS "Destination",
       airline        AS "Airline",
       duration_mins  AS "Flight Duration",
       date           AS "Date"
FROM flights;

-- ALTERNATIVE — AS keyword is optional in PostgreSQL:
-- SELECT flight_id "Flight ID", duration_mins "Flight Duration"
-- FROM flights;
-- (Including AS is recommended for clarity.)


-- -----------------------------------------------------------------------------
-- Q4. Show all columns for flight FL045
-- -----------------------------------------------------------------------------
-- WHY: WHERE filters rows to only those where the condition is TRUE.
--      String values must be in single quotes.
--      flight_id is VARCHAR so 'FL045' uses single quotes.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE flight_id = 'FL045';


-- -----------------------------------------------------------------------------
-- Q5. Retrieve all flights operated by Kenya Airways (airline code: KQ)
-- -----------------------------------------------------------------------------
-- WHY: The airline column stores 2-letter IATA codes.
--      Filtering WHERE airline = 'KQ' returns every Kenya Airways flight.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline = 'KQ';

-- ALTERNATIVE — after joining airlines table (Day 3 approach):
-- SELECT f.*
-- FROM flights f
-- JOIN airlines al ON f.airline = al.iata_code
-- WHERE al.airline_name = 'Kenya Airways';


-- -----------------------------------------------------------------------------
-- Q6. Show all flights departing from Nairobi (NBO)
-- -----------------------------------------------------------------------------
-- WHY: The origin column holds the 3-letter IATA departure airport code.
--      'NBO' = Jomo Kenyatta International Airport, Nairobi.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin = 'NBO';


-- -----------------------------------------------------------------------------
-- Q7. Show all flights arriving in Dubai (DXB)
-- -----------------------------------------------------------------------------
-- WHY: destination column = the arrival airport code.
--      Read the question carefully — "arriving" means destination, not origin.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE destination = 'DXB';


-- -----------------------------------------------------------------------------
-- Q8. Retrieve all flights on the date 2024-01-15
-- -----------------------------------------------------------------------------
-- WHY: PostgreSQL DATE columns compare against ISO string literals 'YYYY-MM-DD'.
--      Never use locale-specific formats like '15/01/2024' in SQL.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE date = '2024-01-15';


-- =============================================================================
-- SECTION 2: FILTERING WITH WHERE (Q9–Q18)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q9. Find all flights longer than 500 minutes
-- -----------------------------------------------------------------------------
-- WHY: Numeric comparisons use standard operators: > < >= <= = !=
--      No quotes around numeric values.
--      500 minutes ≈ 8 hours 20 minutes — ultra-long-haul territory.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE duration_mins > 500;

-- ALTERNATIVE using >= for 501:
-- WHERE duration_mins >= 501
-- (Identical result for integers; > 500 is clearer in intent.)


-- -----------------------------------------------------------------------------
-- Q10. Find all flights shorter than 120 minutes
-- -----------------------------------------------------------------------------
-- WHY: Captures short-hop regional routes — NBO-MBA, NBO-EBB etc.
--      These flights require the fastest aircraft turnarounds at the gate.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE duration_mins < 120;


-- -----------------------------------------------------------------------------
-- Q11. Find all flights that are exactly 510 minutes long
-- -----------------------------------------------------------------------------
-- WHY: = for exact equality on numeric columns.
--      Useful for finding all flights assigned a specific schedule slot.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE duration_mins = 510;


-- -----------------------------------------------------------------------------
-- Q12. Retrieve all flights that are NOT operated by Emirates (EK)
-- -----------------------------------------------------------------------------
-- WHY: != means "not equal to". <> is an older synonym — both work in PostgreSQL.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline != 'EK';

-- ALTERNATIVE using NOT keyword:
-- WHERE NOT airline = 'EK'


-- -----------------------------------------------------------------------------
-- Q13. Find all flights departing from London Heathrow (LHR)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin = 'LHR';


-- -----------------------------------------------------------------------------
-- Q14. Find all flights arriving in Nairobi (NBO)
-- -----------------------------------------------------------------------------
-- WHY: "Arriving" = destination column. NBO receives inbound flights.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE destination = 'NBO';


-- -----------------------------------------------------------------------------
-- Q15. Retrieve all flights operated by British Airways (BA)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline = 'BA';


-- -----------------------------------------------------------------------------
-- Q16. Find all flights departing from Singapore (SIN)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin = 'SIN';


-- -----------------------------------------------------------------------------
-- Q17. Show all flights arriving in Sydney (SYD)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE destination = 'SYD';


-- -----------------------------------------------------------------------------
-- Q18. Find all flights in February 2024
-- -----------------------------------------------------------------------------
-- WHY: BETWEEN is inclusive on both ends.
--      Feb 2024 = 2024-02-01 to 2024-02-29 (2024 is a leap year).
--      Alternative uses EXTRACT to pull the month number from the date.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE date BETWEEN '2024-02-01' AND '2024-02-29';

-- ALTERNATIVE using EXTRACT:
-- WHERE EXTRACT(YEAR FROM date) = 2024
--   AND EXTRACT(MONTH FROM date) = 2

-- ALTERNATIVE using date_trunc:
-- WHERE DATE_TRUNC('month', date) = '2024-02-01'


-- =============================================================================
-- SECTION 3: COMBINING CONDITIONS — AND / OR / NOT (Q19–Q28)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q19. Find all Kenya Airways flights departing from Nairobi
-- -----------------------------------------------------------------------------
-- WHY: AND requires BOTH conditions to be TRUE simultaneously.
--      AND is a narrowing filter — each AND reduces the result set.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline = 'KQ'
  AND origin  = 'NBO';


-- -----------------------------------------------------------------------------
-- Q20. Find all flights departing from either London (LHR) or Paris (CDG)
-- -----------------------------------------------------------------------------
-- WHY: OR returns rows where AT LEAST ONE condition is true.
--      OR is a widening filter — each OR expands the result set.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin = 'LHR'
   OR origin = 'CDG';

-- ALTERNATIVE using IN — cleaner when checking same column against multiple values:
-- WHERE origin IN ('LHR', 'CDG')


-- -----------------------------------------------------------------------------
-- Q21. Find all Emirates flights longer than 400 minutes
-- -----------------------------------------------------------------------------
-- WHY: Combining a string filter (airline) with a numeric filter (duration)
--      using AND. Both must be true for the row to appear.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline       = 'EK'
  AND duration_mins > 400;


-- -----------------------------------------------------------------------------
-- Q22. Find all flights shorter than 100 minutes OR longer than 700 minutes
-- -----------------------------------------------------------------------------
-- WHY: OR across conditions on the same column captures two extremes.
--      Result = regional hops + ultra-long-haul routes.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE duration_mins < 100
   OR duration_mins > 700;

-- ALTERNATIVE — NOT BETWEEN (inclusive, so adjust by 1):
-- WHERE duration_mins NOT BETWEEN 100 AND 700
-- Note: NOT BETWEEN 100 AND 700 excludes 100 and 700 themselves.
-- For exact match with above: NOT BETWEEN 100 AND 700 misses values
-- equal to 100 or 700 — use the OR version for precise control.


-- -----------------------------------------------------------------------------
-- Q23. Find all Delta Air Lines flights arriving in Atlanta (ATL)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline     = 'DL'
  AND destination = 'ATL';


-- -----------------------------------------------------------------------------
-- Q24. Find all flights departing from Nairobi that are longer than 300 minutes
-- -----------------------------------------------------------------------------
-- WHY: Kenya Airways' medium and long-haul routes from NBO.
--      Useful for identifying routes requiring larger aircraft.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin       = 'NBO'
  AND duration_mins > 300;


-- -----------------------------------------------------------------------------
-- Q25. Find all flights NOT from Nairobi AND NOT arriving in Dubai
-- -----------------------------------------------------------------------------
-- WHY: Both exclusions must be true simultaneously — double negation using AND.
--      A flight from NBO is excluded even if it does not go to DXB.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin      != 'NBO'
  AND destination != 'DXB';

-- ALTERNATIVE using NOT with OR (De Morgan's law):
-- WHERE NOT (origin = 'NBO' OR destination = 'DXB')
-- Both produce identical results. The != AND form is more readable.


-- -----------------------------------------------------------------------------
-- Q26. Find all American Airlines flights going to Los Angeles (LAX)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline     = 'AA'
  AND destination = 'LAX';


-- -----------------------------------------------------------------------------
-- Q27. Find all British Airways flights shorter than 100 minutes
-- -----------------------------------------------------------------------------
-- WHY: BA operates the LHR-CDG shuttle which is ~75–80 minutes.
--      Short BA flights indicate European shuttle operations.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline      = 'BA'
  AND duration_mins < 100;


-- -----------------------------------------------------------------------------
-- Q28. Find all flights arriving in London (LHR) longer than 300 minutes (5 hrs)
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE destination  = 'LHR'
  AND duration_mins > 300;


-- =============================================================================
-- SECTION 4: SORTING WITH ORDER BY (Q29–Q36)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q29. List all flights sorted by duration — shortest to longest
-- -----------------------------------------------------------------------------
-- WHY: ASC is the default sort direction — smallest value first.
--      Writing ASC explicitly makes intent clear.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q30. List all flights sorted by duration — longest to shortest
-- -----------------------------------------------------------------------------
-- WHY: DESC = descending — largest value first.
--      Use this for "top N" style reports.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
ORDER BY duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q31. List all flights sorted by date — earliest to most recent
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q32. List all flights sorted alphabetically by airline IATA code
-- -----------------------------------------------------------------------------
-- WHY: ORDER BY on a VARCHAR column sorts lexicographically (A→Z).
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
ORDER BY airline ASC;


-- -----------------------------------------------------------------------------
-- Q33. Show all flights from Nairobi, sorted by duration
-- -----------------------------------------------------------------------------
-- WHY: Combining WHERE filter + ORDER BY sort.
--      ORDER BY always comes AFTER WHERE — this sequence is mandatory.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE origin = 'NBO'
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q34. Show all Kenya Airways flights sorted by date
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE airline = 'KQ'
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q35. List all flights sorted by origin airport alphabetically
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
ORDER BY origin ASC;


-- -----------------------------------------------------------------------------
-- Q36. Show all flights over 400 minutes, sorted from longest to shortest
-- -----------------------------------------------------------------------------
-- WHY: WHERE filters first, then ORDER BY sorts the remaining rows.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE duration_mins > 400
ORDER BY duration_mins DESC;


-- =============================================================================
-- SECTION 5: REAL-WORLD BUSINESS QUESTIONS (Q37–Q50)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q37. Route Planning: Flights on the Nairobi to London route
-- -----------------------------------------------------------------------------
-- WHY: NBO→LHR is Kenya Airways' flagship long-haul route.
--      Identifies both KQ and any competing BA service on this route.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)",
       date           AS "Date"
FROM flights
WHERE origin      = 'NBO'
  AND destination = 'LHR'
ORDER BY date;


-- -----------------------------------------------------------------------------
-- Q38. Short-Haul Identification: Flights under 3 hours (180 minutes)
-- -----------------------------------------------------------------------------
-- WHY: Short-haul is typically defined as under 3 hours.
--      These routes are candidates for narrow-body or turboprop aircraft.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins < 180
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q39. Long-Haul Identification: Ultra-long-haul — over 9 hours (540 minutes)
-- -----------------------------------------------------------------------------
-- WHY: Ultra-long-haul = over 9 hours, requires wide-body and crew rest rules.
--      Routes like SIN-CDG (790 mins) and LHR-SIN (770 mins) appear here.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins > 540
ORDER BY duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q40. Competitor Analysis: Non-KQ flights departing from Nairobi
-- -----------------------------------------------------------------------------
-- WHY: Shows which foreign carriers operate out of NBO — key for
--      understanding competition on Kenya Airways' home turf.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins,
       date
FROM flights
WHERE origin  = 'NBO'
  AND airline != 'KQ'
ORDER BY airline, date;


-- -----------------------------------------------------------------------------
-- Q41. Schedule Review: Flights on the first day of the dataset
-- -----------------------------------------------------------------------------
-- WHY: The dataset starts on 2024-01-03.
--      Useful for verifying data completeness on the opening day.
-- -----------------------------------------------------------------------------
SELECT *
FROM flights
WHERE date = '2024-01-03'
ORDER BY origin;


-- -----------------------------------------------------------------------------
-- Q42. Capacity Planning: All flights arriving into Dubai sorted by date
-- -----------------------------------------------------------------------------
-- WHY: Dubai ground crew need a chronological view of all inbound
--      flights to plan staffing, gates, and baggage resources.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins,
       date
FROM flights
WHERE destination = 'DXB'
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q43. Fleet Utilization: All flights over 8 hours (480 minutes)
-- -----------------------------------------------------------------------------
-- WHY: Flights over 8 hours require wide-body aircraft (B777, A380, B787).
--      Fleet planners use this to confirm appropriate aircraft assignment.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins > 480
ORDER BY duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q44. Regional Operations: Flights under 2 hours — turboprop candidates
-- -----------------------------------------------------------------------------
-- WHY: Flights under 2 hours (120 minutes) are economically viable for
--      turboprop aircraft like the Dash 8 Q400 on thin regional routes.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins < 120
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q45. Codeshare Check: All flights between LHR and DXB in either direction
-- -----------------------------------------------------------------------------
-- WHY: LHR↔DXB is one of the world's busiest city pairs.
--      Finding both directions requires OR logic across origin/destination.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins,
       date
FROM flights
WHERE (origin = 'LHR' AND destination = 'DXB')
   OR (origin = 'DXB' AND destination = 'LHR')
ORDER BY date;

-- ALTERNATIVE using IN (less precise — would also match LHR→LHR):
-- WHERE origin IN ('LHR','DXB') AND destination IN ('LHR','DXB')
-- The explicit OR version is safer and more precise.


-- -----------------------------------------------------------------------------
-- Q46. Revenue Management: All Emirates flights sorted by duration
-- -----------------------------------------------------------------------------
-- WHY: Longer Emirates flights generate more premium cabin and ancillary
--      revenue. Sorting by duration reveals the revenue priority order.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)",
       date
FROM flights
WHERE airline = 'EK'
ORDER BY duration_mins DESC;


-- -----------------------------------------------------------------------------
-- Q47. Hub Analysis: Flights departing FROM or arriving INTO Nairobi
-- -----------------------------------------------------------------------------
-- WHY: The union of departures and arrivals shows NBO's total traffic —
--      both inbound and outbound — for hub capacity planning.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins,
       date
FROM flights
WHERE origin = 'NBO'
   OR destination = 'NBO'
ORDER BY date;


-- -----------------------------------------------------------------------------
-- Q48. Operations Report: Flights for a specific week (Jan 7–14)
-- -----------------------------------------------------------------------------
-- WHY: Weekly operations reports are standard in airline control centres.
--      BETWEEN is inclusive — both boundary dates are included.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       date,
       origin,
       destination,
       airline,
       duration_mins
FROM flights
WHERE date BETWEEN '2024-01-07' AND '2024-01-14'
ORDER BY date, airline;


-- -----------------------------------------------------------------------------
-- Q49. Airline Performance View: United Airlines flights sorted by date
-- -----------------------------------------------------------------------------
SELECT flight_id,
       date           AS "Date",
       origin         AS "From",
       destination    AS "To",
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE airline = 'UA'
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q50. Ground Ops Turnaround: Flights under 90 minutes
-- -----------------------------------------------------------------------------
-- WHY: Flights under 90 minutes have the tightest turnaround requirements —
--      often 25–30 minutes at the gate. Ground teams need advance warning.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins < 90
ORDER BY duration_mins ASC;


-- =============================================================================
-- SECTION 6: CHALLENGE QUESTIONS (Q51–Q55)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q51. Flights under 200 mins, NOT Southwest Airlines, sorted by duration
-- -----------------------------------------------------------------------------
-- WHY: Combines a numeric filter, an exclusion filter, and a sort.
--      Southwest (WN) only operates in North America so excluding them
--      from short-haul gives the African/Asian regional short-haul picture.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)"
FROM flights
WHERE duration_mins < 200
  AND airline        != 'WN'
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q52. January 2024 flights from JFK or LAX, sorted by date
-- -----------------------------------------------------------------------------
-- WHY: Identifies all transatlantic/transpacific departures from the two
--      biggest US gateway airports during the sample month.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       date,
       origin,
       destination,
       airline,
       duration_mins
FROM flights
WHERE date   BETWEEN '2024-01-01' AND '2024-01-31'
  AND origin IN ('JFK', 'LAX')
ORDER BY date ASC;

-- ALTERNATIVE without BETWEEN:
-- WHERE EXTRACT(MONTH FROM date) = 1
--   AND EXTRACT(YEAR  FROM date) = 2024
--   AND origin IN ('JFK','LAX')


-- -----------------------------------------------------------------------------
-- Q53. Long-haul flights (>480 mins) by Singapore Airlines or Japan Airlines
-- -----------------------------------------------------------------------------
-- WHY: SQ and JL are premium Asian carriers whose long-haul performance
--      is a benchmark for quality. Both use IATA codes SQ and JL.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS "Duration (mins)",
       date
FROM flights
WHERE duration_mins > 480
  AND airline IN ('SQ', 'JL')
ORDER BY duration_mins DESC;

-- ALTERNATIVE using OR:
-- WHERE duration_mins > 480
--   AND (airline = 'SQ' OR airline = 'JL')
-- IN is cleaner when checking the same column against a list of values.


-- -----------------------------------------------------------------------------
-- Q54. All Qantas flights sorted by duration — alias duration as flight_time
-- -----------------------------------------------------------------------------
-- WHY: The alias requirement tests whether you remember AS syntax.
--      'flight_time' is the alias name used in the output column header.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins  AS flight_time,
       date
FROM flights
WHERE airline = 'QF'
ORDER BY duration_mins ASC;


-- -----------------------------------------------------------------------------
-- Q55. Flights from African airports (NBO, JNB, ADD, ACC, DAR, CMB), by airline
-- -----------------------------------------------------------------------------
-- WHY: CMB is Colombo, Sri Lanka — not Africa. The question includes it
--      but it is worth noting as a data literacy check. The IN list handles
--      multiple values cleanly without chaining OR conditions.
-- -----------------------------------------------------------------------------
SELECT flight_id,
       origin,
       destination,
       airline,
       duration_mins,
       date
FROM flights
WHERE origin IN ('NBO', 'JNB', 'ADD', 'ACC', 'DAR', 'CMB')
ORDER BY airline ASC, date ASC;

-- ALTERNATIVE using OR (more verbose, same result):
-- WHERE origin = 'NBO'
--    OR origin = 'JNB'
--    OR origin = 'ADD'
--    OR origin = 'ACC'
--    OR origin = 'DAR'
--    OR origin = 'CMB'
-- IN is always preferred over chained OR conditions on the same column.


-- =============================================================================
-- END OF DAY 1 ANSWERS
-- =============================================================================
-- Key rules to remember from Day 1:
--   1. Clause order:  SELECT → FROM → WHERE → ORDER BY
--   2. String values: single quotes  'NBO'
--   3. Identifiers:   double quotes  "Flight Duration"
--   4. Numeric values: no quotes     duration_mins > 500
--   5. AND narrows the result; OR widens it
--   6. ORDER BY is always the last clause in a SELECT statement
-- =============================================================================
