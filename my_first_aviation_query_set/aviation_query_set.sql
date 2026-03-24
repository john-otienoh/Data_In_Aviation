--Display all flight records showing origin, destination, airline, and duration. Use column aliases to make the headers more readable (e.g., "Departure City", "Arrival City").
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights;

--List all unique airlines operating flights.
select distinct(airline)
from flights;

--WHERE Clause Practice
--Show all columns for flight FL045
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where id = 45;

--Retrieve all flights operated by Kenya Airways
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline = 'Kenya Airways';


-- Find all flights that took place in February 2024
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where date >= '2024-02-01' and "date" <= '2024-02-29';

--Retrieve all flights on the date 2024-01-15
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where date = '2024-01-15';

--Show all flights that depart from Nairobi (NBO)
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where origin = 'NBO';

--Show all flights that arrive in Dubai (DXB)
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where destination = 'DXB';

--Find all flights departing from JFK airport.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin = 'JFK';

--Find all flights arriving at LAX airport.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where destination  = 'LAX';

--List all flights operated by Delta Air Lines.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where airline = 'Delta Air Lines';

--Show all flights with duration longer than 400 minutes.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins > 400;

--Find all flights from JFK to LAX (both origin and destination conditions).
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin = 'JFK' and destination = 'LAX';

--Find flights with duration between 200 and 500 minutes.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins between 200 and 500;

--Show flights from either JFK, LAX, or LHR
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin in ('JFK', 'LAX', 'LHR');

--Combining Conditions (AND / OR / NOT)
--Find all Kenya Airways flights departing from Nairobi
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin = 'NBO' and airline = 'Kenya Airways';

--Find all Emirates flights longer than 400 minutes
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins > 400 and airline = 'Emirates';

--Find all flights that are shorter than 100 minutes OR longer than 700 minutes
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins < 100 or duration_mins > 700;

--Find all Delta Air Lines flights arriving in Atlanta (ATL)
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where destination = 'ATL' and airline = 'Delta Air Lines';

--Find all flights departing from Nairobi that are longer than 300 minutes
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin = 'NBO' and duration_mins > 300;

--Find all flights that are NOT departing from Nairobi AND NOT arriving in Dubai
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where not origin = 'NBO' and not destination = 'DXB';

--Find all flights operated by American Airlines going to Los Angeles (LAX)
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where destination = 'LAX' and airline = 'American Airlines';

--Find all British Airways flights shorter than 100 minutes
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins < 100 and airline = 'British Airways';

--Find all flights arriving in London (LHR) that are longer than 5 hours (300 minutes)
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins > 300 and destination = 'LHR';

--ORDER BY Practice
--List all flights sorted by date (newest first).
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by "date" desc;

--Show flights ordered by duration (shortest to longest).
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by duration_mins;

--Display flights sorted by airline name alphabetically.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by airline;

--List flights ordered by origin, then by destination (alphabetical order).
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by origin, destination;

--Display flights sorted by duration (longest first) and then by airline name.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_min as "Flight Duration", date
from flights
order by duration_mins desc, airline ;

--List all flights sorted by duration from longest to shortest
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by duration_mins desc;

--Show all flights departing from Nairobi, sorted by duration
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin  = 'NBO'
order by duration_mins ;

--Show all Kenya Airways flights sorted by date
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where airline = 'Kenya Airways'
order by "date" ;

--List all flights sorted by origin airport alphabetically
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
order by origin ;

--Show all flights over 400 minutes, sorted from longest to shortest
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins >= 400
order by duration_mins desc;

--Combining WHERE and ORDER BY
--Find all Delta flights and order them by duration (longest first).
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where airline = 'Delta Air Lines'
order by duration_mins desc;

--List flights from JFK ordered by destination alphabetically.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where origin = 'JFK'
order by destination;

--Show flights with duration over 500 minutes, ordered by airline name.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins >= 500
order by airline ;

--List flights with duration exactly 90 minutes.
select id,
	origin as "Departure Airport", 
	destination as "Arrival Airport", 
	airline, duration_mins as "Flight Duration", date
from flights
where duration_mins = 90;

--Real-World Business Questions
--Route Planning: Which flights operate on the Nairobi to London route?
select id as "Flight Number", origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where origin = 'NBO' and destination = 'LHR';
--Short-Haul Identification: What flights qualify as short-haul — under 3 hours (180 minutes)?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins <= 180;

--Long-Haul Identification:** What flights qualify as ultra-long-haul — over 9 hours (540 minutes)?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins >= 540;

--Competitor Analysis: Show all flights not operated by Kenya Airways on routes out of Nairobi
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where not airline = 'Kenya Airways' and origin = 'NBO';

--Schedule Review: What flights were scheduled on the first day of the dataset?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
order by "date" ;

--Capacity Planning: List all flights arriving into Dubai (DXB) sorted by date — for ground crew scheduling
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where destination = 'DXB'
order by "date" ;
--Fleet Utilization: Find all flights longer than 8 hours — these would require a wide-body aircraft
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins > 240;
--Regional Operations: Show all flights with a duration under 2 hours — candidates for turboprop aircraft
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins < 120;
--Codeshare Check: Find all flights between London (LHR) and Dubai (DXB) in either direction
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where (origin = 'LHR' and destination = 'DXB') or (origin = 'DXB' and destination = 'LHR');

--Revenue Management: Show all Emirates flights sorted by duration — longer flights typically generate more revenue
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline  = 'Emirates'
order by duration_mins;

--Hub Analysis: Find all flights departing from OR arriving into Nairobi (NBO)
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins < 120;
--Operations Report: List all flights for a specific week — between 2024-01-07 and 2024-01-14
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where duration_mins < 120;

--Airline Performance View: Show all flights operated by United Airlines sorted by flight date
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline = 'United Airlines'
order  by "date" ;

--Find all flights shorter than 200 minutes that are NOT operated by Southwest Airlines, sorted by duration
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where not airline = 'Southwest Airlines'
order  by duration_mins ;

--Show all flights in January 2024 departing from either New York (JFK) or Los Angeles (LAX), sorted by date
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where ("date" between '2024-01-01' and '2024-01-31') and origin in ('JFK', 'LAX')
order  by "date" ;

--Find all long-haul flights (over 480 minutes) operated by either Singapore Airlines or Japan Airlines
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline in ('Singapore Airlines', 'Japan Airlines') and (duration_mins > 480);

--List all Qantas flights sorted by duration — labelling duration as `flight_time`
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline = 'Qantas'
order  by duration_mins ;

--Find all flights that depart from African airports — NBO, JNB, ADD, ACC, DAR, CMB — sorted by airline name

