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
ORDER BY f.id;

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
ORDER BY f.id;

-- 3. Join flights to airlines so the airline's country of origin appears alongside each flight
SELECT 
    f.origin,
    f.destination,
    f.airline,
    a.country_of_origin AS airline_country,
    f.duration_mins,
    f.date
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code; 

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
ORDER BY f.id;

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
ORDER BY f.id;

-- 6. Retrieve all flights together with the alliance that airline belongs to — for example Star Alliance, Oneworld, or SkyTeam
SELECT 
    f.origin,
    f.destination,
    f.airline,
    a.alliance AS airline_alliance,
    f.duration_mins,
    f.date
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code;

-- 7. Join flights to airlines and show only the airline name, origin, destination, and flight duration
SELECT 
	a.airline_name,
    f.origin,
    f.destination,
    f.duration_mins
FROM flights as f
inner join airlines as a
on f.airline = a.iata_code;

-- 8. Join flights to airports on origin and show only flights where the airport country is Kenya
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
where a.country = 'Kenya'
ORDER BY f.id;
-- ---

-- ### 🔗 Joining on Both Origin AND Destination

-- 9. Join the airports table twice — once for origin and once for destination — so both city names appear in the same row
SELECT 
    f.origin,
    a.airport_name AS origin_airport_name,
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
ORDER BY f.id;

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
ORDER BY f.id;

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
ON f.destination  = aa.iata_code
ORDER BY f.id;

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
ON f.destination  = aa.iata_code
ORDER BY f.id;

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
where a.country != aa.country 
ORDER BY f.id;

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
ON f.destination  = aa.iata_code
where a.continent  = aa.continent
ORDER BY f.id;

-- 15. Show the full route description for every flight — for example "Nairobi, Kenya → London, United Kingdom"
SELECT 
    f.origin,
    a.city as origin_city,
    a.country as origin_country,
    a.continent  as origin_continent,
    f.destination,
    aa.city as destination_city,
    aa.country as destination_country,
    aa.continent  as destination_continent,
    f.airline,
    aaa.airline_name as full_airline_name,
    f.duration_mins,
    f.date
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
ORDER BY f.id;

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
    aa.continent as destination_continent
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
    aa.continent  as destination_continent,
    f.airline,
    f.duration_mins,
    f.date
FROM flights as f
inner JOIN airports as a 
ON f.origin = a.iata_code
inner JOIN airports as aa 
ON f.destination  = aa.iata_code
where a.continent  = 'Europe' and aa.continent = 'Asia'
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
    f.airline,
    f.duration_mins,
    f.date
FROM flights f
LEFT JOIN airports as a 
ON f.origin = a.iata_code
WHERE a.iata_code IS NULL;

-- 27. Left join flights to airlines — find any flights where the airline name could not be matched
SELECT 
    f.id,
    f.origin,
    f.destination,
    f.airline,
    f.duration_mins,
    f.date
FROM flights f
LEFT join airlines as a 
ON f.airline = a.iata_code
WHERE a.airline_name  IS NULL;

-- 28. Left join airports to flights — find any airports in your airports table that have no departing flights in the dataset
-- 29. Left join airports to flights on destination — find airports that no flight in the dataset lands at
-- 30. Left join airlines to flights — find any airline in the airlines table that has no flights recorded in the flights table
-- 31. Left join flights to airports on destination — show all flights, and for any destination not found in airports, the city should appear as NULL
-- 32. Use a left join and filter for NULLs to produce a list of unmatched airports — these represent data quality gaps

-- ---

-- ### 📊 Joining + Sorting + Aliases

-- 33. Join flights and airports, rename the airport name column as `departure_airport`, and sort by country
-- 34. Join flights to airlines, label the airline country as `carrier_country`, and sort alphabetically
-- 35. Join both airport tables and rename them clearly as `origin_city` and `destination_city`, sorted by duration
-- 36. After joining, sort all African-departure flights by flight duration from longest to shortest
-- 37. Join flights to airlines and sort by alliance, then by duration within each alliance

-- ---

-- ### ✈️ Real-World Business Questions

-- *These are questions airline and airport operations teams actually ask:*

-- 38. **Network Map:** Show every route operated as full city-to-city pairs — not just IATA codes
-- 39. **Alliance Reporting:** Which flights in the dataset are operated by SkyTeam member airlines?
-- 40. **Hub Dominance:** Show all flights departing from Nairobi Jomo Kenyatta International Airport with the full airport name displayed
-- 41. **International Route Audit:** Find all flights where the origin and destination are in different countries — true cross-border operations
-- 42. **Continent Traffic Flow:** Show all flights from Africa to the Middle East — key for identifying trade and diaspora route demand
-- 43. **Codeshare Eligibility:** Find all flights operated by Star Alliance airlines arriving into Star Alliance hub airports
-- 44. **Foreign Carrier Analysis:** Find all flights arriving into Kenya that are operated by non-Kenyan airlines
-- 45. **Ground Handler Planning:** Show every destination airport name and country for flights arriving on 2024-01-15 — ground teams need to prepare
-- 46. **Interline Agreement Check:** Find all flights where the operating airline's home country differs from both the origin and destination country — fully foreign operations
-- 47. **Capacity by Continent:** Show all flights arriving into Europe sorted by duration — longer flights need wider aircraft and more catering
-- 48. **Revenue Route Report:** Show all routes — origin city to destination city — operated by Emirates, sorted by duration
-- 49. **Alliance Gap Analysis:** Left join airlines to flights and find which alliance member airlines have zero recorded flights — potential underserved partnerships
-- 50. **Airport Utilization Report:** Left join airports to flights on origin — find which airports in your table have no departing flights recorded — these may be underreported or inactive
-- 51. **Bilateral Air Service:** Find all city pairs where flights operate in both directions — NBO→LHR and LHR→NBO both exist
-- 52. **Domestic vs International Split:** After joining both airport tables, count how many routes are within the same country versus crossing borders — without using COUNT yet, just retrieve and observe the rows
-- 53. **Turnaround Complexity:** Find all short-haul flights (under 150 minutes) arriving into major hub airports — these have the most complex ground turnaround requirements
-- 54. **African Aviation Network:** Show all flights where either the origin or destination is on the African continent, with full city names, sorted by date
-- 55. **Fuel Planning by Region:** Show all ultra-long-haul flights (over 600 minutes) with the full origin and destination country — fuel uplift planning depends on route geography

-- ---

-- ### 💡 Challenge Questions

-- *Combining joins with everything from Days 1–3:*

-- 56. Join all three tables — flights, origin airport, destination airport, and airlines — in a single query showing: origin city, destination city, airline name, alliance, and duration
-- 57. Find all flights where a non-African airline is flying between two African cities
-- 58. Show all Oneworld flights departing from Asia arriving into Europe, with full city names, sorted by duration
-- 59. Find all routes where the flight duration is under 200 minutes but the origin and destination are on different continents — these are unusually fast intercontinental routes worth investigating
-- 60. Left join all three tables and identify any flight record that is missing either an airport match or an airline match — a full data quality audit in one query

-- ---

-- By the time you finish these 60 questions you will have genuine confidence joining multiple tables, catching unmatched records, and translating real aviation business problems into SQL — exactly what airline analytics teams do every day.