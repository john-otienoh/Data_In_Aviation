-- ## Day 3 SQL Practice Questions — Joins

-- ### 🔗 Basic INNER JOIN — Two Tables

-- 1. Join flights to airports so that the full airport name appears instead of the origin IATA code
select * from flights;
select * from airports;
select * from airlines;

-- Join with sample data
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    f.destination,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
ORDER BY f.date;

-- 2. Join flights to airports on the destination side so you see the destination city name
SELECT 
    f.origin,
    f.destination,
    a.airport_name AS destination_airport_name,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.destination = a.iata_code
ORDER BY f.date;

-- 3. Join flights to airlines so the airline's country of origin appears alongside each flight
SELECT 
    f.origin,
    f.destination,
    f.airline,
    a.airline_name as "Airline",
    a.country_of_origin AS airline_country,
    f.duration_mins,
    f.date
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
ORDER BY a.country_of_origin, f.date; 

-- 4. Show each flight with the full name of its departing airport and the country it is in
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.country as origin_country,
    f.destination,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
ORDER BY a.country, f.date;

-- 5. Show each flight with the full name of its arriving airport and the continent it is on
SELECT 
    f.origin,
    f.destination,
    a.airport_name AS destination_airport_name,
    a.continent as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.destination = a.iata_code
ORDER BY a.continent, f.duration_mins DESC;

-- 6. Retrieve all flights together with the alliance that airline belongs to — for example Star Alliance, Oneworld, or SkyTeam
SELECT 
    f.origin,
    f.destination,
    f.airline,
    a.airline_name as "Airline",
    a.alliance AS airline_alliance,
    f.duration_mins,
    f.date
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
ORDER BY a.alliance, a.airline_name;

-- 7. Join flights to airlines and show only the airline name, origin, destination, and flight duration
SELECT 
	a.airline_name,
    f.origin,
    f.destination,
    f.duration_mins
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
ORDER BY a.airline_name, f.duration_mins DESC;

-- 8. Join flights to airports on origin and show only flights where the airport country is Kenya
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.country as origin_country,
    f.destination,
    f.airline,
    al.airline_name    AS "Airline",
    f.duration_mins
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
JOIN airlines as al  
ON f.airline = al.iata_code
where a.country = 'Kenya'
ORDER BY f.date;
-- ---

-- ### 🔗 Joining on Both Origin AND Destination

-- 9. Join the airports table twice — once for origin and once for destination — so both city names appear in the same row
SELECT 
    f.origin,
    a.city as origin_city,
    f.destination,
    aa.city as destination_city,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
ORDER BY f.duration_mins DESC;

-- 10. Show each flight with the full origin city name and full destination city name side by side
SELECT 
    f.origin,
    a.city as origin_city,
    f.destination,
    aa.city as destination_city
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
ORDER BY a.city, aa.city;

-- 11. Show each flight with the origin country and destination country in the same row
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.country as origin_country,
    f.destination,
    aa.country  as destination_country,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code;

-- 12. Show each flight with the origin continent and destination continent — so you can see if it is a domestic or intercontinental flight
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.continent as origin_continent,
    f.destination,
    aa.continent  as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code;

-- 13. Find all flights where the origin country and destination country are different — true international flights
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.country as origin_country,
    f.destination,
    aa.country  as destination_country,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
where a.country != aa.country;

-- 14. Find all flights where the origin and destination are on the same continent
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.continent as origin_continent,
    f.destination,
    aa.continent  as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination = aa.iata_code
where a.continent = aa.continent
ORDER BY f.id;

-- 15. Show the full route description for every flight — for example "Nairobi, Kenya → London, United Kingdom"
SELECT f.id,
       a.city || ', ' || a.country
       || ' → '
       || aa.city || ', ' || aa.country     AS "Route",
       aaa.airline_name                         AS "Airline",
       f.duration_mins                         AS "Duration (mins)"
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
inner join airlines aaa
on f.airline = aaa.iata_code
ORDER BY f.id;
-- ---

-- ### 🔎 Filtering After Joining

-- 16. After joining flights to airports, find all flights departing from airports in Africa
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.continent as origin_continent,
    f.destination
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
where a.continent = 'Africa'
ORDER BY f.id;

-- 17. After joining, find all flights arriving into airports in Asia
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    f.destination,
    a.continent as destination_continent
FROM flights as f
inner JOIN airports as a 
ON f.destination = a.iata_code
where a.continent = 'Asia'
ORDER BY f.duration_mins desc;

-- 18. After joining flights to airlines, find all flights operated by airlines based in the United Kingdom
SELECT 
    f.airline,
    a.airline_name,
    a.country_of_origin AS airline_country
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
where a.country_of_origin = 'United Kingdom'; 

-- 19. After joining, find all Star Alliance member airline flights
SELECT 
    f.airline,
    a.airline_name,
    a.alliance 
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
where a.alliance = 'Star Alliance'; 

-- 20. After joining origin and destination airports, find all flights where both the origin and destination are in Africa
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.continent as origin_continent,
    f.destination,
    aa.continent
as destination_continent
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination = aa.iata_code
where a.continent = 'Africa' and aa.continent = 'Africa'
ORDER BY f.id;

-- 21. After joining, find all flights departing from Kenya sorted by duration
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.country as origin_country,
    f.destination,
    f.duration_mins 
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
where a.country = 'Kenya'
ORDER BY f.duration_mins;

-- 22. After joining flights to airlines, show all Oneworld alliance flights longer than 400 minutes
SELECT 
    f.airline,
    a.airline_name,
    a.alliance,
    f.duration_mins 
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code
where a.alliance = 'Oneworld' and f.duration_mins > 400; 

-- 23. After joining both airport tables, find all flights from Europe to the Middle East
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
    a.continent as origin_continent,
    f.destination,
    aa.country        AS "To Country",
    aa.continent  as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
where a.continent  = 'Europe' and (aa.continent = 'Asia' or aa.country IN ('United Arab Emirates','Saudi Arabia','Qatar','Kuwait','Bahrain','Oman','Jordan'))

ORDER BY f.id;

-- 24. After joining, find all flights arriving into a country different from where the airline is based — the airline is operating a foreign route
SELECT 
    aa.airport_name,
    f.destination,
    aa.country  as destination_country,
    f.airline,
    aaa.airline_name,
    aaa.country_of_origin 
FROM flights as f
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
inner join airlines as aaa
on f.airline = aaa.iata_code 
where aa.country != aaa.country_of_origin ;

-- 25. After joining, find all Emirates flights arriving into African airports
SELECT 
    f.origin,
    a.airport_name AS airport_name,
    a.continent as origin_continent,
    f.destination,
    f.airline,
    aa.airline_name 
FROM flights as f
inner JOIN airports as a 
ON f.destination = a.iata_code
inner join  airlines as aa 
ON f.airline  = aa.iata_code
where aa.airline_name = 'Emirates' and a.continent = 'Africa';
-- ---

-- ### ↩️ LEFT JOIN — Catching Missing Data

-- 26. Left join flights to airports on origin — find any flights where the origin airport has no matching record in the airports table
SELECT 
    f.id,
    f.origin,
    f.destination,
    f.airline
FROM flights f
LEFT JOIN airports as a 
ON f.origin = a.iata_code
WHERE a.iata_code IS NULL;

-- 27. Left join flights to airlines — find any flights where the airline name could not be matched
SELECT 
    f.id,
    f.origin,
    f.destination,
    f.airline
FROM flights f
LEFT join airlines as a 
ON f.airline = a.iata_code
WHERE a.iata_code IS NULL;

-- 28. Left join airports to flights — find any airports in your airports table that have no departing flights in the dataset
SELECT a.iata_code,
       a.airport_name,
       a.city,
       a.country,
       a.continent
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.origin
WHERE f.id IS NULL
ORDER BY a.continent, a.country;

-- 29. Left join airports to flights on destination — find airports that no flight in the dataset lands at
SELECT a.iata_code,
       a.airport_name,
       a.city,
       a.country
FROM airports a
LEFT JOIN flights f ON a.iata_code = f.destination
WHERE f.id IS NULL
ORDER BY a.country;


-- 30. Left join airlines to flights — find any airline in the airlines table that has no flights recorded in the flights table
SELECT al.iata_code,
       al.airline_name,
       al.country_of_origin,
       al.alliance
FROM airlines al
LEFT JOIN flights f ON al.iata_code = f.airline
WHERE f.id IS NULL
ORDER BY al.airline_name;

-- 31. Left join flights to airports on destination — show all flights, and for any destination not found in airports, the city should appear as NULL
SELECT 
    f.id,
    f.origin,
    f.destination,
    a.city AS destination_city,
    f.airline
FROM flights f
LEFT JOIN airports a 
ON f.destination = a.iata_code;

-- 32. Use a left join and filter for NULLs to produce a list of unmatched airports — these represent data quality gaps
SELECT a.iata_code          AS "Airport Code",
       a.airport_name       AS "Airport Name",
       a.city               AS "City",
       a.country            AS "Country",
       a.continent          AS "Continent",
       'No flights in dataset' AS "Status"
FROM airports a
LEFT JOIN flights f 
ON a.iata_code = f.origin 
OR a.iata_code = f.destination
WHERE f.id IS NULL;
-- ---

-- ### 📊 Joining + Sorting + Aliases

-- 33. Join flights and airports, rename the airport name column as `departure_airport`, and sort by country
SELECT 
    f.origin,
    a.airport_name AS departure_airport,
    a.country  as departure_country,
    f.destination,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
ORDER BY a.country;

-- 34. Join flights to airlines, label the airline country as `carrier_country`, and sort alphabetically
SELECT 
    f.origin,
    f.destination,
    f.airline,
    a.airline_name,
    a.country_of_origin as "carrier_country"
FROM flights as f
inner JOIN airlines as a 
ON f.airline = a.iata_code
ORDER by carrier_country ;

-- 35. Join both airport tables and rename them clearly as `origin_city` and `destination_city`, sorted by duration
SELECT 
    f.origin,
    a.city as origin_city,
    f.destination,
    aa.city as destination_city,
    f.airline, 
    f.duration_mins 
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
order by f.duration_mins ;

-- 36. After joining, sort all African-departure flights by flight duration from longest to shortest
SELECT 
    f.origin,
    a.continent  as origin_continent,
    f.destination,
    aa.city as destination_city,
    aa.country as destination_country,
    aa.continent  as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
where aa.continent = 'Africa'
order by f.duration_mins desc;

-- 37. Join flights to airlines and sort by alliance, then by duration within each alliance
select
    f.id,
    a.alliance,
    a.airline_name,
    f.duration_mins    AS "Duration (mins)"
from flights as f
join airlines as a on f.airline = a.iata_code
order by a.alliance asc NULLS LAST, f.duration_mins DESC;

-- ---

-- ### ✈️ Real-World Business Questions

-- *These are questions airline and airport operations teams actually ask:*

-- 38. **Network Map:** Show every route operated as full city-to-city pairs — not just IATA codes
select DISTINCT
    dep.city || ', ' || dep.country    AS "Origin",
    arr.city || ', ' || arr.country    AS "Destination",
    al.airline_name                    AS "Airline"
from flights as f
join airports as dep on f.origin = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
JOIN airlines al  ON f.airline     = al.iata_code
ORDER BY "Origin", "Destination";

-- 39. **Alliance Reporting:** Which flights in the dataset are operated by SkyTeam member airlines?
select
    f.id,
    aa.airline_name,
    aa.alliance,
    f.origin,
    f.destination
from flights as f
join airlines as aa on f.airline = aa.iata_code
where aa.alliance = 'SkyTeam' 
ORDER BY aa.airline_name;

-- 40. **Hub Dominance:** Show all flights departing from Nairobi Jomo Kenyatta International Airport with the full airport name displayed
SELECT 
    f.id,
    f.origin,
    a.city,
    a.country,
    a.airport_name
FROM flights
JOIN airports as a on f.origin = a.iata_code
where f.origin = 'NBO';

-- 41. **International Route Audit:** Find all flights where the origin and destination are in different countries — true cross-border operations
SELECT
    f.id,
    f.origin, 
    a.country as "Departure Country",
    aa.country as "Destination Country",
    f.date
from flights as f
join airports as a on f.origin = a.iata_code 
join airports as aa on f.destination = aa.iata_code 
where a.country != aa.country;

-- 42. **Continent Traffic Flow:** Show all flights from Africa to the Middle East — key for identifying trade and diaspora route demand
SELECT
    f.id,
    a.continent as "Departure Continent",
    aa.continent as "Destination Continent"
FROM flights as f 
JOIN airports as a on f.origin = a.iata_code
JOIN airports as aa on f.destination = aa.iata_code
where a.continent = 'Africa' and aa.continent = 'Asia';

-- 43. **Codeshare Eligibility:** Find all flights operated by Star Alliance airlines arriving into Star Alliance hub airports
SELECT f.id,
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

-- 44. **Foreign Carrier Analysis:** Find all flights arriving into Kenya that are operated by non-Kenyan airlines
SELECT f.id,
       al.airline_name    AS "Airline",
       al.alliance        AS "Alliance",
       dep.country           AS "From",
       arr.country           AS "To",
       f.duration_mins
FROM flights f
JOIN airlines al  ON f.airline     = al.iata_code
JOIN airports dep ON f.origin      = dep.iata_code
JOIN airports arr ON f.destination = arr.iata_code
WHERE arr.country = 'Kenya' AND al.country_of_origin != 'Kenya';

-- 45. **Ground Handler Planning:** Show every destination airport name and country for flights arriving on 2024-01-15 — ground teams need to prepare
SELECT 
    f.id,
    f.destination,
    a.airport_name,
    a.country as "Destination Country",
    f.date
from flights as f
join airports as a on f.destination = a.iata_code
where date = '2024-01-15';

-- 46. **Interline Agreement Check:** Find all flights where the operating airline's home country differs from both the origin and destination country — fully foreign operations
SELECT
    f.id,
    f.origin,
    a.country as "Departure Country",
    aaa.country_of_origin,
    f.destination,
    aa.country as "Destination Country",
    f.date
FROM flights as f 
join airlines as aaa on f.airline = aaa.iata_code
join airports as a on f.origin = a.iata_code
join airports as aa on f.destination = aa.iata_code
where aaa.country_of_origin != a.country and aaa.country_of_origin != aa.country;


-- 47. **Capacity by Continent:** Show all flights arriving into Europe sorted by duration — longer flights need wider aircraft and more catering
SELECT
    f.id,
    f.destination,
    aa.continent as "Destination Continent",
    f.duration_mins
FROM flights as f 
join airports as aa on f.destination = aa.iata_code 
where aa.continent = 'Europe'
order by f.duration_mins desc;

-- 48. **Revenue Route Report:** Show all routes — origin city to destination city — operated by Emirates, sorted by duration
SELECT
    f.id,
    f.origin,
    f.airline,
    a.city as "Departure City",
    aa.city as "Destination City",
    aaa.airline_name as "Airline Name",
    f.duration_mins
FROM flights as f
JOIN airports as a on f.origin = a.iata_code
JOIN airports as aa on f.destination = aa.iata_code
JOIN airlines as aaa on f.airline = aaa.iata_code
where aaa.airline_name = 'Emirates' or f.airline = 'EK'
order by f.duration_mins desc;

-- 49. **Alliance Gap Analysis:** Left join airlines to flights and find which alliance member airlines have zero recorded flights — potential underserved partnerships
select 
    f.id,
    a.airline_name,
    a.alliance,
    f.date
from airlines as a 
left join flights as f on a.iata_code = f.airline
WHERE f.id IS NULL AND a.alliance IS NOT NULL;

-- 50. **Airport Utilization Report:** Left join airports to flights on origin — find which airports in your table have no departing flights recorded — these may be underreported or inactive
SELECT
    f.origin,
    a.airport_name,
    a.city,
    a.country
from airports as a
LEFT JOIN flights as f on a.iata_code = f.origin
where f.id is NULL; 

-- 51. **Bilateral Air Service:** Find all city pairs where flights operate in both directions — NBO→LHR and LHR→NBO both exist
SELECT DISTINCT
       dep.city           AS "City A",
       arr.city           AS "City B"
FROM flights f1
JOIN flights f2
  ON f1.origin      = f2.destination
 AND f1.destination = f2.origin
JOIN airports dep ON f1.origin      = dep.iata_code
JOIN airports arr ON f1.destination = arr.iata_code
WHERE f1.origin < f1.destination 
ORDER BY "City A";

-- 52. **Domestic vs International Split:** After joining both airport tables, count how many routes are within the same country versus crossing borders — without using COUNT yet, just retrieve and observe the rows
SELECT f.id,
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

-- 53. **Turnaround Complexity:** Find all short-haul flights (under 150 minutes) arriving into major hub airports — these have the most complex ground turnaround requirements
SELECT f.id,
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

-- 54. **African Aviation Network:** Show all flights where either the origin or destination is on the African continent, with full city names, sorted by date
select 
    f.id,
    f.origin,
    a.continent as "Departure Continent",
    aa.continent as "Destination Continent",
    f.date
from flights
join airports as a on f.origin = a.iata_code
join airports as aa on f.destination = aa.iata_code
where a.continent = 'Africa' or aa.continent = 'Africa'
order by f.date;

-- 55. **Fuel Planning by Region:** Show all ultra-long-haul flights (over 600 minutes) with the full origin and destination country — fuel uplift planning depends on route geography
select 
    f.id,
    f.origin,
    a.country as "Departure Country",
    aa.country as "Destination Country",
    f.duration_mins,
    f.date
from flights as f
join airports as a on f.origin = a.iata_code
join airports as aa on f.destination = aa.iata_code
where f.duration_mins > 600
order by f.duration_mins desc;
-- ---

-- ### 💡 Challenge Questions

-- *Combining joins with everything from Days 1–3:*

-- 56. Join all three tables — flights, origin airport, destination airport, and airlines — in a single query showing: origin city, destination city, airline name, alliance, and duration
SELECT f.id,
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

-- 57. Find all flights where a non-African airline is flying between two African cities
SELECT f.id,
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

-- 58. Show all Oneworld flights departing from Asia arriving into Europe, with full city names, sorted by duration
SELECT f.id,
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

-- 59. Find all routes where the flight duration is under 200 minutes but the origin and destination are on different continents — these are unusually fast intercontinental routes worth investigating
SELECT f.id,
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

-- 60. Left join all three tables and identify any flight record that is missing either an airport match or an airline match — a full data quality audit in one query
SELECT f.id,
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
ORDER BY "Data Quality Status", f.id;
