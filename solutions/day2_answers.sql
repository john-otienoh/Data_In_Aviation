-- =============================================================================
-- DAY 2 SQL ANSWERS — GROUP BY · COUNT · SUM · AVG · MIN · MAX · HAVING
-- =============================================================================
-- Schema  : flights (flight_id, origin, destination, airline, duration_mins, date)
-- Dataset : flights.csv — 100 rows
-- Topics  : Aggregation functions, GROUP BY, HAVING, filtering before/after grouping
-- Prerequisite: All Day 1 skills (SELECT, WHERE, ORDER BY, aliases)
-- =============================================================================
-- CRITICAL RULE: WHERE filters rows BEFORE grouping.
--                HAVING filters groups AFTER aggregation.
--                You can NEVER use an aggregate function inside WHERE.
-- =============================================================================


-- =============================================================================
-- SECTION 1: COUNT — COUNTING FLIGHTS (Q1–Q14)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1. How many total flights are in the dataset?
-- -----------------------------------------------------------------------------
-- WHY: COUNT(*) counts every row including NULLs. No GROUP BY means
--      the entire table is treated as one group, returning a single number.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Total Flights"
FROM flights;

-- ALTERNATIVE — count a specific column (skips NULLs in that column):
-- SELECT COUNT(flight_id) AS "Total Flights"
-- FROM flights;
-- COUNT(*) is preferred for total row counts. COUNT(column) is used
-- when you specifically want to exclude NULLs from the count.


-- -----------------------------------------------------------------------------
-- Q2. How many flights does each airline operate?
-- -----------------------------------------------------------------------------
-- WHY: GROUP BY collapses all rows with the same airline into one summary row.
--      COUNT(*) then counts how many rows were in each group.
--      Result: one row per airline with its flight count.
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY airline
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q3. How many flights depart from each origin airport?
-- -----------------------------------------------------------------------------
SELECT origin          AS "Origin Airport",
       COUNT(*)        AS "Departures"
FROM flights
GROUP BY origin
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q4. How many flights arrive at each destination airport?
-- -----------------------------------------------------------------------------
SELECT destination     AS "Destination Airport",
       COUNT(*)        AS "Arrivals"
FROM flights
GROUP BY destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q5. How many flights are there per date?
-- -----------------------------------------------------------------------------
-- WHY: GROUP BY date produces one row per calendar day with a flight count.
--      This is the foundation of daily operations reporting.
-- -----------------------------------------------------------------------------
SELECT date            AS "Date",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY date
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q6. How many flights does Kenya Airways operate in total?
-- -----------------------------------------------------------------------------
-- WHY: WHERE filters to KQ rows first, then COUNT(*) counts the filtered set.
--      No GROUP BY needed because we want a single total for one airline.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Kenya Airways Total Flights"
FROM flights
WHERE airline = 'KQ';


-- -----------------------------------------------------------------------------
-- Q7. How many unique airlines are in the dataset?
-- -----------------------------------------------------------------------------
-- WHY: COUNT(DISTINCT column) counts only distinct values, ignoring duplicates.
--      Without DISTINCT, COUNT(*) would return 100 (one per flight row).
-- -----------------------------------------------------------------------------
SELECT COUNT(DISTINCT airline) AS "Unique Airlines"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q8. How many unique origin airports are in the dataset?
-- -----------------------------------------------------------------------------
SELECT COUNT(DISTINCT origin) AS "Unique Origin Airports"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q9. How many flights depart from Nairobi (NBO)?
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Departures from NBO"
FROM flights
WHERE origin = 'NBO';


-- -----------------------------------------------------------------------------
-- Q10. How many flights arrive in Dubai (DXB)?
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS "Arrivals into DXB"
FROM flights
WHERE destination = 'DXB';


-- -----------------------------------------------------------------------------
-- Q11. How many flights does each airline operate, sorted from most to least?
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q12. Which date had the most flights?
-- -----------------------------------------------------------------------------
-- WHY: GROUP BY date then ORDER BY COUNT(*) DESC puts the busiest date first.
--      LIMIT 1 returns only the single top result.
-- -----------------------------------------------------------------------------
SELECT date            AS "Date",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY date
ORDER BY COUNT(*) DESC
LIMIT 1;

-- ALTERNATIVE without LIMIT — shows all dates ranked:
-- SELECT date, COUNT(*) AS "Flights"
-- FROM flights
-- GROUP BY date
-- ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q13. How many flights are there per destination, sorted alphabetically?
-- -----------------------------------------------------------------------------
SELECT destination     AS "Destination",
       COUNT(*)        AS "Arrivals"
FROM flights
GROUP BY destination
ORDER BY destination ASC;


-- -----------------------------------------------------------------------------
-- Q14. How many flights does each airline operate out of Nairobi specifically?
-- -----------------------------------------------------------------------------
-- WHY: WHERE restricts to NBO departures only, then GROUP BY airline
--      shows which airlines operate how many flights from that hub.
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights from NBO"
FROM flights
WHERE origin = 'NBO'
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- =============================================================================
-- SECTION 2: SUM — TOTALLING FLIGHT TIME (Q15–Q23)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q15. Total combined flight duration across all flights
-- -----------------------------------------------------------------------------
-- WHY: SUM adds all values in the column. One row returned because no GROUP BY.
--      Dividing by 60.0 (not 60) forces floating-point division.
-- -----------------------------------------------------------------------------
SELECT SUM(duration_mins)                    AS "Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1)  AS "Total Hours"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q16. Total flying time per airline in minutes
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       SUM(duration_mins)                   AS "Total Minutes"
FROM flights
GROUP BY airline
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q17. Total flying time per airline, sorted from highest to lowest
-- -----------------------------------------------------------------------------
-- WHY: Block hours (total airborne time) is the primary airline cost and
--      revenue driver. Sorting descending shows the busiest airlines first.
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       SUM(duration_mins)                   AS "Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1) AS "Block Hours"
FROM flights
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q18. Total flying time for all flights departing from Nairobi
-- -----------------------------------------------------------------------------
SELECT SUM(duration_mins)                    AS "Total NBO Departure Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1)  AS "Total NBO Block Hours"
FROM flights
WHERE origin = 'NBO';


-- -----------------------------------------------------------------------------
-- Q19. Total flying time per origin airport
-- -----------------------------------------------------------------------------
SELECT origin                                AS "Origin",
       SUM(duration_mins)                   AS "Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1) AS "Block Hours"
FROM flights
GROUP BY origin
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q20. Total flying time for each destination airport
-- -----------------------------------------------------------------------------
SELECT destination                           AS "Destination",
       SUM(duration_mins)                   AS "Total Arrival Minutes"
FROM flights
GROUP BY destination
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q21. Total flying time per date
-- -----------------------------------------------------------------------------
SELECT date                                  AS "Date",
       SUM(duration_mins)                   AS "Total Minutes"
FROM flights
GROUP BY date
ORDER BY date ASC;


-- -----------------------------------------------------------------------------
-- Q22. Total flying time for Kenya Airways across all its routes
-- -----------------------------------------------------------------------------
SELECT SUM(duration_mins)                    AS "KQ Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1)  AS "KQ Block Hours"
FROM flights
WHERE airline = 'KQ';


-- -----------------------------------------------------------------------------
-- Q23. Combined flying time for all flights arriving in London (LHR)
-- -----------------------------------------------------------------------------
SELECT SUM(duration_mins)                    AS "Total Inbound LHR Minutes"
FROM flights
WHERE destination = 'LHR';


-- =============================================================================
-- SECTION 3: AVG — AVERAGE FLIGHT DURATION (Q24–Q32)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q24. Average flight duration across the entire dataset
-- -----------------------------------------------------------------------------
-- WHY: AVG computes the arithmetic mean. ROUND(..., 1) gives one decimal place.
--      AVG automatically ignores NULL values.
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(duration_mins), 1) AS "Avg Duration (mins)"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q25. Average flight duration per airline
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)",
       COUNT(*)                              AS "Flights"
FROM flights
GROUP BY airline
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q26. Which airline has the highest average flight duration?
-- -----------------------------------------------------------------------------
-- WHY: ORDER BY AVG DESC + LIMIT 1 returns the single airline with the
--      longest average flight — indicates a long-haul network specialist.
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
ORDER BY AVG(duration_mins) DESC
LIMIT 1;


-- -----------------------------------------------------------------------------
-- Q27. Which airline has the lowest average flight duration?
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
ORDER BY AVG(duration_mins) ASC
LIMIT 1;


-- -----------------------------------------------------------------------------
-- Q28. Average flight duration per origin airport
-- -----------------------------------------------------------------------------
SELECT origin                                AS "Origin",
       ROUND(AVG(duration_mins), 1)         AS "Avg Departure Duration (mins)"
FROM flights
GROUP BY origin
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q29. Average flight duration for flights arriving in Dubai (DXB)
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(duration_mins), 1) AS "Avg Inbound DXB Duration (mins)"
FROM flights
WHERE destination = 'DXB';


-- -----------------------------------------------------------------------------
-- Q30. Average flight duration per date
-- -----------------------------------------------------------------------------
SELECT date                                  AS "Date",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)"
FROM flights
GROUP BY date
ORDER BY date;


-- -----------------------------------------------------------------------------
-- Q31. Average duration of Kenya Airways flights
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(duration_mins), 1) AS "Kenya Airways Avg Duration (mins)"
FROM flights
WHERE airline = 'KQ';


-- -----------------------------------------------------------------------------
-- Q32. Average duration for NBO departures vs LHR departures (comparison)
-- -----------------------------------------------------------------------------
-- WHY: CASE WHEN inside AVG is a conditional average — one query returns both.
--      This is the "pivot" pattern for side-by-side comparisons.
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(CASE WHEN origin = 'NBO' THEN duration_mins END), 1)
           AS "Avg NBO Departure (mins)",
       ROUND(AVG(CASE WHEN origin = 'LHR' THEN duration_mins END), 1)
           AS "Avg LHR Departure (mins)"
FROM flights;

-- ALTERNATIVE — two separate queries (simpler but requires two runs):
-- SELECT ROUND(AVG(duration_mins),1) FROM flights WHERE origin = 'NBO';
-- SELECT ROUND(AVG(duration_mins),1) FROM flights WHERE origin = 'LHR';


-- =============================================================================
-- SECTION 4: MIN AND MAX — EXTREMES (Q33–Q42)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q33. What is the shortest flight in the entire dataset?
-- -----------------------------------------------------------------------------
-- WHY: MIN returns the smallest value in the column across all rows.
-- -----------------------------------------------------------------------------
SELECT MIN(duration_mins) AS "Shortest Flight (mins)"
FROM flights;

-- ALTERNATIVE — show the full flight record of the shortest flight:
-- SELECT * FROM flights ORDER BY duration_mins ASC LIMIT 1;


-- -----------------------------------------------------------------------------
-- Q34. What is the longest flight in the entire dataset?
-- -----------------------------------------------------------------------------
SELECT MAX(duration_mins) AS "Longest Flight (mins)"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q35. Shortest flight operated by each airline
-- -----------------------------------------------------------------------------
SELECT airline                    AS "Airline",
       MIN(duration_mins)         AS "Shortest Flight (mins)"
FROM flights
GROUP BY airline
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q36. Longest flight operated by each airline
-- -----------------------------------------------------------------------------
SELECT airline                    AS "Airline",
       MAX(duration_mins)         AS "Longest Flight (mins)"
FROM flights
GROUP BY airline
ORDER BY MAX(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q37. Shortest flight departing from each origin airport
-- -----------------------------------------------------------------------------
SELECT origin                     AS "Origin",
       MIN(duration_mins)         AS "Shortest Departure (mins)"
FROM flights
GROUP BY origin
ORDER BY origin;


-- -----------------------------------------------------------------------------
-- Q38. Longest flight arriving at each destination
-- -----------------------------------------------------------------------------
SELECT destination                AS "Destination",
       MAX(duration_mins)         AS "Longest Arrival (mins)"
FROM flights
GROUP BY destination
ORDER BY MAX(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q39. Earliest flight date in the dataset
-- -----------------------------------------------------------------------------
-- WHY: MIN on a DATE column returns the earliest date.
-- -----------------------------------------------------------------------------
SELECT MIN(date) AS "First Flight Date"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q40. Latest flight date in the dataset
-- -----------------------------------------------------------------------------
SELECT MAX(date) AS "Last Flight Date"
FROM flights;


-- -----------------------------------------------------------------------------
-- Q41. Longest Kenya Airways flight
-- -----------------------------------------------------------------------------
SELECT MAX(duration_mins) AS "KQ Longest Flight (mins)"
FROM flights
WHERE airline = 'KQ';


-- -----------------------------------------------------------------------------
-- Q42. Shortest Emirates flight
-- -----------------------------------------------------------------------------
SELECT MIN(duration_mins) AS "EK Shortest Flight (mins)"
FROM flights
WHERE airline = 'EK';


-- =============================================================================
-- SECTION 5: COMBINING AGGREGATIONS (Q43–Q48)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q43. Per airline: total flights, total flying time, and average duration
-- -----------------------------------------------------------------------------
-- WHY: Multiple aggregate functions in one SELECT produce a multi-metric
--      summary per group — the foundation of airline performance reports.
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       COUNT(*)                              AS "Total Flights",
       SUM(duration_mins)                   AS "Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1) AS "Block Hours",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q44. Per origin airport: number of flights and average duration
-- -----------------------------------------------------------------------------
SELECT origin                                AS "Origin",
       COUNT(*)                              AS "Departures",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)"
FROM flights
GROUP BY origin
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q45. Per airline: shortest, longest, and average duration side by side
-- -----------------------------------------------------------------------------
-- WHY: Shows network width — a large difference between MIN and MAX
--      indicates an airline operating both regional and long-haul routes.
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       MIN(duration_mins)                   AS "Shortest (mins)",
       MAX(duration_mins)                   AS "Longest (mins)",
       ROUND(AVG(duration_mins), 1)         AS "Average (mins)",
       MAX(duration_mins) - MIN(duration_mins) AS "Range (mins)"
FROM flights
GROUP BY airline
ORDER BY (MAX(duration_mins) - MIN(duration_mins)) DESC;


-- -----------------------------------------------------------------------------
-- Q46. Per date: number of flights and total flying time
-- -----------------------------------------------------------------------------
SELECT date                                  AS "Date",
       COUNT(*)                              AS "Flights",
       SUM(duration_mins)                   AS "Total Minutes"
FROM flights
GROUP BY date
ORDER BY date;


-- -----------------------------------------------------------------------------
-- Q47. Per destination: number of arrivals and average inbound duration
-- -----------------------------------------------------------------------------
SELECT destination                           AS "Destination",
       COUNT(*)                              AS "Arrivals",
       ROUND(AVG(duration_mins), 1)         AS "Avg Inbound Duration (mins)"
FROM flights
GROUP BY destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q48. Per airline: total flights and total flying time, sorted by flying time
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       COUNT(*)                              AS "Total Flights",
       SUM(duration_mins)                   AS "Total Flying Time (mins)"
FROM flights
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- =============================================================================
-- SECTION 6: AGGREGATIONS WITH WHERE — FILTER BEFORE GROUPING (Q49–Q55)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q49. Among flights > 300 mins only: average duration per airline
-- -----------------------------------------------------------------------------
-- WHY: WHERE runs before GROUP BY. Only rows passing WHERE enter the groups.
--      Result: airlines' averages computed on their long-haul flights only.
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       ROUND(AVG(duration_mins), 1)         AS "Avg Duration (mins)",
       COUNT(*)                              AS "Qualifying Flights"
FROM flights
WHERE duration_mins > 300
GROUP BY airline
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q50. Kenya Airways only: flight count per destination
-- -----------------------------------------------------------------------------
SELECT destination                           AS "Destination",
       COUNT(*)                              AS "KQ Flights"
FROM flights
WHERE airline = 'KQ'
GROUP BY destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q51. January 2024 only: total flying time per airline
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       SUM(duration_mins)                   AS "Jan 2024 Total Minutes"
FROM flights
WHERE date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q52. NBO departures only: which airline operates the most flights from NBO?
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       COUNT(*)                              AS "Flights from NBO"
FROM flights
WHERE origin = 'NBO'
GROUP BY airline
ORDER BY COUNT(*) DESC
LIMIT 1;


-- -----------------------------------------------------------------------------
-- Q53. Short-haul (<180 mins) only: average duration per airline
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       ROUND(AVG(duration_mins), 1)         AS "Avg Short-Haul Duration",
       COUNT(*)                              AS "Short-Haul Flights"
FROM flights
WHERE duration_mins < 180
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q54. Ultra-long-haul (>540 mins) only: count per airline
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       COUNT(*)                              AS "Ultra-Long-Haul Flights"
FROM flights
WHERE duration_mins > 540
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q55. Arrivals into DXB only: average inbound flight duration
-- -----------------------------------------------------------------------------
SELECT ROUND(AVG(duration_mins), 1) AS "Avg Inbound DXB Duration (mins)",
       COUNT(*)                     AS "Inbound Flights"
FROM flights
WHERE destination = 'DXB';


-- =============================================================================
-- SECTION 7: HAVING — FILTERING AFTER GROUPING (Q56–Q65)
-- =============================================================================
-- RULE: HAVING filters groups after aggregation.
--       WHERE filters rows before aggregation.
--       Never put an aggregate function inside WHERE — use HAVING instead.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q56. Airlines that operate more than 5 flights
-- -----------------------------------------------------------------------------
-- WHY: HAVING COUNT(*) > 5 filters out groups (airlines) with 5 or fewer rows.
--      This CANNOT be written as WHERE COUNT(*) > 5 — that causes an error.
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY airline
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q57. Airlines that operate fewer than 3 flights
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY airline
HAVING COUNT(*) < 3
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q58. Origin airports with more than 5 departures
-- -----------------------------------------------------------------------------
SELECT origin          AS "Origin",
       COUNT(*)        AS "Departures"
FROM flights
GROUP BY origin
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q59. Airlines with average flight duration greater than 400 minutes
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
HAVING AVG(duration_mins) > 400
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q60. Airlines with average flight duration less than 300 minutes
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
HAVING AVG(duration_mins) < 300
ORDER BY AVG(duration_mins) ASC;


-- -----------------------------------------------------------------------------
-- Q61. Destination airports that receive more than 4 arrivals
-- -----------------------------------------------------------------------------
SELECT destination     AS "Destination",
       COUNT(*)        AS "Arrivals"
FROM flights
GROUP BY destination
HAVING COUNT(*) > 4
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q62. Dates with more than 3 flights scheduled
-- -----------------------------------------------------------------------------
SELECT date            AS "Date",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY date
HAVING COUNT(*) > 3
ORDER BY date;


-- -----------------------------------------------------------------------------
-- Q63. Airlines with total flying time greater than 1,000 minutes
-- -----------------------------------------------------------------------------
SELECT airline                         AS "Airline",
       SUM(duration_mins)             AS "Total Minutes"
FROM flights
GROUP BY airline
HAVING SUM(duration_mins) > 1000
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q64. Origin airports with average departure duration above 500 minutes
-- -----------------------------------------------------------------------------
SELECT origin                          AS "Origin",
       ROUND(AVG(duration_mins), 1)   AS "Avg Departure (mins)"
FROM flights
GROUP BY origin
HAVING AVG(duration_mins) > 500
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q65. Airlines with more than 3 flights AND average duration over 400 minutes
-- -----------------------------------------------------------------------------
-- WHY: Multiple conditions in HAVING work exactly like multiple conditions
--      in WHERE — use AND / OR between them.
-- -----------------------------------------------------------------------------
SELECT airline                         AS "Airline",
       COUNT(*)                        AS "Flights",
       ROUND(AVG(duration_mins), 1)   AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
HAVING COUNT(*) > 3
   AND AVG(duration_mins) > 400
ORDER BY AVG(duration_mins) DESC;


-- =============================================================================
-- SECTION 8: REAL-WORLD BUSINESS QUESTIONS (Q66–Q85)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q66. Network Planning: distinct routes per airline
-- -----------------------------------------------------------------------------
-- WHY: COUNT(DISTINCT ...) on a concatenated origin+destination column
--      counts unique route pairs per airline.
-- -----------------------------------------------------------------------------
SELECT airline                                              AS "Airline",
       COUNT(DISTINCT origin || '->' || destination)       AS "Unique Routes"
FROM flights
GROUP BY airline
ORDER BY COUNT(DISTINCT origin || '->' || destination) DESC;


-- -----------------------------------------------------------------------------
-- Q67. Capacity Report: airlines ranked by total airborne minutes
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       SUM(duration_mins)                   AS "Total Minutes",
       ROUND(SUM(duration_mins) / 60.0, 1) AS "Block Hours"
FROM flights
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q68. Hub Dominance: origin airports by departure count
-- -----------------------------------------------------------------------------
SELECT origin          AS "Origin",
       COUNT(*)        AS "Departures"
FROM flights
GROUP BY origin
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q69. Route Popularity: destination airports by inbound flights
-- -----------------------------------------------------------------------------
SELECT destination     AS "Destination",
       COUNT(*)        AS "Arrivals"
FROM flights
GROUP BY destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q70. Airline Size Ranking: largest to smallest by flight count
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights",
       ROW_NUMBER() OVER ()  AS "Dataset Rank"
FROM flights
GROUP BY airline
ORDER BY COUNT(*) DESC;

-- SIMPLER ALTERNATIVE without window function:
-- SELECT airline, COUNT(*) AS "Flights"
-- FROM flights
-- GROUP BY airline
-- ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q71. Average Stage Length per airline
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       ROUND(AVG(duration_mins), 1)  AS "Avg Stage Length (mins)"
FROM flights
GROUP BY airline
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q72. Busiest Travel Days: dates with highest flight counts
-- -----------------------------------------------------------------------------
SELECT date            AS "Date",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY date
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q73. Ground Crew Scheduling: avg arrivals per destination per day
-- -----------------------------------------------------------------------------
-- WHY: Divide total arrivals by distinct days to get average daily arrivals.
--      Useful for staffing models at each airport.
-- -----------------------------------------------------------------------------
SELECT destination                                                AS "Destination",
       COUNT(*)                                                   AS "Total Arrivals",
       COUNT(DISTINCT date)                                       AS "Days Active",
       ROUND(COUNT(*)::NUMERIC / COUNT(DISTINCT date), 1)        AS "Avg Arrivals/Day"
FROM flights
GROUP BY destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q74. Fleet Mix: short / medium / long-haul counts per airline
-- -----------------------------------------------------------------------------
-- WHY: CASE WHEN inside COUNT is the conditional count pattern.
--      One query returns three separate counts per airline simultaneously.
-- -----------------------------------------------------------------------------
SELECT airline                                                      AS "Airline",
       COUNT(CASE WHEN duration_mins < 180                THEN 1 END) AS "Short-Haul",
       COUNT(CASE WHEN duration_mins BETWEEN 180 AND 480  THEN 1 END) AS "Medium-Haul",
       COUNT(CASE WHEN duration_mins > 480                THEN 1 END) AS "Long-Haul"
FROM flights
GROUP BY airline
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q75. Revenue Potential: airlines by total flying minutes
-- -----------------------------------------------------------------------------
SELECT airline                               AS "Airline",
       SUM(duration_mins)                   AS "Total Flying Minutes"
FROM flights
GROUP BY airline
ORDER BY SUM(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q76. Kenya Airways Network Report: flights, avg, shortest, longest
-- -----------------------------------------------------------------------------
-- WHY: Single-airline summary using WHERE before aggregation.
--      No GROUP BY needed — all metrics are for one airline.
-- -----------------------------------------------------------------------------
SELECT COUNT(*)                     AS "Total Flights",
       ROUND(AVG(duration_mins), 1) AS "Avg Duration (mins)",
       MIN(duration_mins)           AS "Shortest Route (mins)",
       MAX(duration_mins)           AS "Longest Route (mins)"
FROM flights
WHERE airline = 'KQ';


-- -----------------------------------------------------------------------------
-- Q77. Competitor Benchmarking: EK vs BA vs SQ average duration
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)",
       COUNT(*)                       AS "Flights"
FROM flights
WHERE airline IN ('EK', 'BA', 'SQ')
GROUP BY airline
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q78. Operational Efficiency: highest variance between shortest and longest
-- -----------------------------------------------------------------------------
SELECT airline                                          AS "Airline",
       MIN(duration_mins)                              AS "Shortest (mins)",
       MAX(duration_mins)                              AS "Longest (mins)",
       MAX(duration_mins) - MIN(duration_mins)         AS "Range (mins)"
FROM flights
GROUP BY airline
ORDER BY (MAX(duration_mins) - MIN(duration_mins)) DESC;


-- -----------------------------------------------------------------------------
-- Q79. African Hub Analysis: flights from African airports by airline
-- -----------------------------------------------------------------------------
SELECT airline                    AS "Airline",
       COUNT(*)                   AS "African Departures"
FROM flights
WHERE origin IN ('NBO', 'JNB', 'ADD', 'ACC', 'DAR')
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q80. Monthly Volume: January 2024 vs February 2024 flight counts
-- -----------------------------------------------------------------------------
SELECT EXTRACT(MONTH FROM date)   AS "Month",
       EXTRACT(YEAR  FROM date)   AS "Year",
       COUNT(*)                   AS "Flights"
FROM flights
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY "Year", "Month";

-- ALTERNATIVE using CASE WHEN for side-by-side comparison:
-- SELECT
--   COUNT(CASE WHEN EXTRACT(MONTH FROM date) = 1 THEN 1 END) AS "Jan Flights",
--   COUNT(CASE WHEN EXTRACT(MONTH FROM date) = 2 THEN 1 END) AS "Feb Flights"
-- FROM flights;


-- -----------------------------------------------------------------------------
-- Q81. Route Frequency: how many times each origin-destination pair appears
-- -----------------------------------------------------------------------------
SELECT origin || ' -> ' || destination     AS "Route",
       COUNT(*)                            AS "Flights"
FROM flights
GROUP BY origin, destination
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q82. Minimum Viable Network: airlines with only one flight
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
GROUP BY airline
HAVING COUNT(*) = 1
ORDER BY airline;


-- -----------------------------------------------------------------------------
-- Q83. Peak Day Operations: flights per airline on the busiest day
-- -----------------------------------------------------------------------------
-- WHY: First find the busiest date using a subquery, then group by airline
--      for that date. This is the "filter then aggregate" pattern.
-- -----------------------------------------------------------------------------
SELECT airline         AS "Airline",
       COUNT(*)        AS "Flights"
FROM flights
WHERE date = (
    SELECT date
    FROM flights
    GROUP BY date
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY airline
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q84. Long-Haul Specialist: airlines with avg duration above overall average
-- -----------------------------------------------------------------------------
-- WHY: HAVING AVG(...) > (subquery) compares each group's average against
--      the overall dataset average computed by the subquery.
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
HAVING AVG(duration_mins) > (SELECT AVG(duration_mins) FROM flights)
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q85. Turnaround Pressure: destinations with most arrivals on a single day
-- -----------------------------------------------------------------------------
SELECT destination     AS "Destination",
       date            AS "Date",
       COUNT(*)        AS "Arrivals on Day"
FROM flights
GROUP BY destination, date
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;


-- =============================================================================
-- SECTION 9: CHALLENGE QUESTIONS (Q86–Q90)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q86. Airlines with >3 flights, sorted by highest average duration
-- -----------------------------------------------------------------------------
-- WHY: Combines HAVING for the flight count filter with ORDER BY for sorting.
--      HAVING is WHERE-equivalent for post-aggregation conditions.
-- -----------------------------------------------------------------------------
SELECT airline                        AS "Airline",
       COUNT(*)                       AS "Flights",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)"
FROM flights
GROUP BY airline
HAVING COUNT(*) > 3
ORDER BY AVG(duration_mins) DESC;


-- -----------------------------------------------------------------------------
-- Q87. Origin airports with >2 departures: total flights and average duration
-- -----------------------------------------------------------------------------
SELECT origin                         AS "Origin",
       COUNT(*)                       AS "Departures",
       ROUND(AVG(duration_mins), 1)  AS "Avg Duration (mins)"
FROM flights
GROUP BY origin
HAVING COUNT(*) > 2
ORDER BY COUNT(*) DESC;


-- -----------------------------------------------------------------------------
-- Q88. Airline with widest operational range (max longest AND shortest gap)
-- -----------------------------------------------------------------------------
SELECT airline                                       AS "Airline",
       MIN(duration_mins)                           AS "Shortest (mins)",
       MAX(duration_mins)                           AS "Longest (mins)",
       MAX(duration_mins) - MIN(duration_mins)      AS "Range (mins)"
FROM flights
GROUP BY airline
ORDER BY (MAX(duration_mins) - MIN(duration_mins)) DESC
LIMIT 1;


-- -----------------------------------------------------------------------------
-- Q89. Top 3 dates in January 2024 by total flying time
-- -----------------------------------------------------------------------------
SELECT date                          AS "Date",
       SUM(duration_mins)           AS "Total Flying Time (mins)"
FROM flights
WHERE date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY date
ORDER BY SUM(duration_mins) DESC
LIMIT 3;


-- -----------------------------------------------------------------------------
-- Q90. Per airline: count of long-haul flights and total flights
-- -----------------------------------------------------------------------------
-- WHY: CASE WHEN inside COUNT counts only long-haul rows per airline.
--      The plain COUNT(*) counts all rows per airline.
--      Dividing gives the long-haul share. Multiply by 100 for percentage.
-- -----------------------------------------------------------------------------
SELECT airline                                                          AS "Airline",
       COUNT(*)                                                         AS "Total Flights",
       COUNT(CASE WHEN duration_mins > 480 THEN 1 END)                 AS "Long-Haul Flights",
       ROUND(
           100.0 * COUNT(CASE WHEN duration_mins > 480 THEN 1 END)
           / COUNT(*), 1
       )                                                                AS "Long-Haul %"
FROM flights
GROUP BY airline
ORDER BY "Long-Haul %" DESC;


-- =============================================================================
-- END OF DAY 2 ANSWERS
-- =============================================================================
-- Key rules to remember from Day 2:
--   1. GROUP BY collapses rows into groups — one row per unique value
--   2. Every SELECT column must be in GROUP BY or wrapped in an aggregate
--   3. WHERE filters rows BEFORE grouping (no aggregates allowed in WHERE)
--   4. HAVING filters groups AFTER aggregation (aggregates allowed here)
--   5. COUNT(*) counts all rows including NULLs
--   6. COUNT(column) skips NULLs in that column
--   7. COUNT(DISTINCT column) counts only unique values
--   8. AVG automatically skips NULL values
--   9. Divide by 60.0 (not 60) to get fractional hours from minutes
--  10. CASE WHEN inside COUNT/AVG enables conditional aggregation
-- =============================================================================
