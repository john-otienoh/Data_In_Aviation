select airline, COUNT(*) as total_flights
from flights 
group by airline
order by total_flights  desc;

select origin, count(*) as busiest_origin_airport
from flights
group by origin 
order by busiest_origin_airport  desc;

select destination, count(*) as busiest_destination_airport
from flights
group by destination 
order by busiest_destination_airport  desc;

select max(duration_mins ) as longest_flight_hours
from flights;

select MIN(duration_mins ) as shortest_flight_hours
from flights;

select avg(duration_mins ) as average_flight_hours
from flights;


-- Longest route by flight hours
SELECT *
FROM flights
ORDER BY duration_mins DESC
LIMIT 1;

-- Shortest route by flight hours
SELECT *
FROM flights
ORDER BY duration_mins
LIMIT 1;


