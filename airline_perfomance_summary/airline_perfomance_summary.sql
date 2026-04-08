-- ## Day 2 SQL Practice Questions — flights table

-- Using only: `GROUP BY`, `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` — building on Day 1 skills.

-- ---

-- ### 🔢 COUNT — Counting Flights

-- 1. How many total flights are in the dataset?
select count(*) as total_flights
from flights;
-- 2. How many flights does each airline operate?
select airline, count(airline) as flights_per_airline
from flights
group by airline ;

-- 3. How many flights depart from each origin airport?
select airline, count(airline) as flights_per_airline
from flights
group by airline ;

-- 4. How many flights arrive at each destination airport?
select origin as "Departure Airport", count(origin ) as flights_from_each_airport
from flights
group by origin ;

-- 5. How many flights are there per date?
select "date", count("date") as flights_on_each_day
from flights
group by "date" ;

-- 6. How many flights does Kenya Airways operate in total?
select airline, count(airline) as flights_per_airline
from flights
where airline = 'Kenya Airways'
group by airline ;

-- 7. How many unique airlines are in the dataset?
select count(distinct(airline)) as unique_airline_count
from flights;

-- 8. How many unique origin airports are in the dataset?
select count(distinct(origin)) as unique_deaparture_airport_count
from flights;

-- 9. How many flights depart from Nairobi (NBO)?
select count(*) as total_flights_from_NBO
from flights
where origin = 'NBO';

-- 10. How many flights arrive in Dubai (DXB)?
select count(*) as total_flights_to_DXB
from flights
where destination = 'DXB';

-- 11. How many flights does each airline operate, sorted from most to least?
select count(airline) as flights_per_airline
from flights
group by airline
order by flights_per_airline desc;

-- 12. Which date had the most flights?
select "date", count("date") as flights_on_each_day
from flights
group by "date" 
order by flights_on_each_day desc 
limit 1;

-- 13. How many flights are there per destination, sorted alphabetically?
select destination, count(destination) as destination_airport_count
from flights
group by destination 
order by destination ;

-- 14. How many flights does each airline operate out of Nairobi specifically?
select airline, count(airline) as flights_outside_NBO
from flights
where not origin = 'NBO'
group by airline ;
-- ---

-- ### ➕ SUM — Totalling Flight Time

-- 15. What is the total combined flight duration across all flights in the dataset?
select sum(duration_mins ) as total_flight_hours
from flights;

-- 16. What is the total flying time per airline in minutes?
select airline, sum(duration_mins ) as total_flight_hours_per_airline
from flights
group by airline ;

-- 17. What is the total flying time per airline, sorted from highest to lowest?
select airline, sum(duration_mins ) as total_flight_hours_per_airline
from flights
group by airline 
order by total_flight_hours_per_airline desc;

-- 18. What is the total flying time for all flights departing from Nairobi?
select airline, sum(duration_mins ) as total_flight_hours_per_airline
from flights
group by airline ;

-- 19. What is the total flying time per origin airport?
select origin , sum(duration_mins ) as total_flight_hours_per_origin_airport
from flights
group by origin ;

-- 20. What is the total flying time for each destination airport?
select destination , sum(duration_mins ) as total_flight_hours_per_destination_airport
from flights
group by destination ;

-- 21. What is the total flying time per date?
select "date" , sum(duration_mins ) as total_flight_hours_per_day
from flights
group by "date" ;

-- 22. What is the total flying time for Kenya Airways across all its routes?
select sum(duration_mins ) as total_flight_hours_by_KQ
from flights
where airline = 'Kenya Airways' ;

-- 23. What is the combined flying time for all flights arriving in London (LHR)?
select sum(duration_mins ) as total_flight_hours_to_LHR
from flights
where destination = 'LHR' ;
-- ---

-- ### 📊 AVG — Average Flight Duration

-- 24. What is the average flight duration across the entire dataset?
select avg(duration_mins ) as average_flight_hours
from flights;

-- 25. What is the average flight duration per airline?
select airline, AVG(duration_mins ) as average_flight_hours_per_airline
from flights
group by airline ;

-- 26. Which airline has the highest average flight duration?
select airline, AVG(duration_mins ) as average_flight_hours_per_airline
from flights
group by airline 
order by average_flight_hours_per_airline desc
limit 1;

-- 27. Which airline has the lowest average flight duration?
select airline, AVG(duration_mins ) as average_flight_hours_per_airline
from flights
group by airline 
order by average_flight_hours_per_airline
limit 1;

-- 28. What is the average flight duration per origin airport?
select origin , avg(duration_mins ) as average_flight_hours_per_origin_airport
from flights
group by origin ;

-- 29. What is the average flight duration for flights arriving in Dubai (DXB)?
select avg(duration_mins ) as average_flight_hours_to_DXB
from flights
where destination = 'DXB' ;

-- 30. What is the average flight duration per date?
select "date" , avg(duration_mins ) as average_flight_hours_per_day
from flights
group by "date" ;

-- 31. What is the average duration of Kenya Airways flights?
select avg(duration_mins) as "average duration of Kenya Airways flights"
from flights
where airline = 'Kenya Airways';
-- 32. What is the average flight duration for flights departing from Nairobi compared to flights departing from London (LHR)?

-- ---

-- ### 📈 MIN and MAX — Extremes

-- 33. What is the shortest flight in the entire dataset?
select min(duration_mins) as "Shortest flight"
from flights;

-- 34. What is the longest flight in the entire dataset?
select max(duration_mins) as "longest flight"
from flights;

-- 35. What is the shortest flight operated by each airline?
select airline, min(duration_mins) as "Shortest flight by each airline"
from flights
group by airline ;

-- 36. What is the longest flight operated by each airline?
select airline, max(duration_mins) as "longest flight by each airline"
from flights
group by airline ;

-- 37. What is the shortest flight departing from each origin airport?
select origin , min(duration_mins) as "Shortest flight from each origin airport"
from flights
group by  origin ;

-- 38. What is the longest flight arriving at each destination?
select destination , max(duration_mins) as "Longest flight from each origin airport"
from flights
group by  origin ;

-- 39. What is the earliest flight date in the dataset?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
order by "date"
limit 1;

-- 40. What is the latest flight date in the dataset?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
order by "date" desc
limit 1;

-- 41. What is the longest Kenya Airways flight?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline = 'Kenya Airways'
order by duration_mins desc
limit 1;

-- 42. What is the shortest Emirates flight?
select id, origin as "Departure Airport", destination as "Arrival Airport", airline, duration_mins as "Flight Duration", date 
from flights
where airline = 'Emirates'
order by duration_mins
limit 1;
-- ---

-- ### 🔗 Combining Aggregations

-- 43. For each airline, show the total number of flights, total flying time, and average flight duration together
select airline, count(*) as "Total number of flights", sum(duration_mins) as "Total flying hours", avg(duration_mins) as "Average flight duration" 
from flights
group by airline;

-- 44. For each origin airport, show the number of flights and the average duration
select origin , count(*) as "Total number of flights", avg(duration_mins) as "Average flight duration" 
from flights
group by  origin;

-- 45. For each airline, show the shortest, longest, and average flight duration side by side
select airline, max(duration_mins) as "Max flight duration", min(duration_mins) as "Min flight duration", avg(duration_mins) as "Average flight duration" 
from flights
group by airline;

-- 46. For each date, show the number of flights and the total flying time
select date, count(*) as "Total number of flights", sum(duration_mins) as "Total flying hours"
from flights
group by date;

-- 47. For each destination, show the number of arrivals and the average inbound flight duration
select destination , count(*) as "Total number of flights", avg(duration_mins) as "Average flying hours"
from flights
group by destination ;

-- 48. For each airline, show total flights and total flying time, sorted by total flying time descending
select airline, count(*) as "Total number of flights", sum(duration_mins) as "Total flying hours", avg(duration_mins) as "Average flight duration" 
from flights
group by airline
order by "Total flying hours" desc;
-- ---

-- ### 🔍 Aggregations with WHERE (Filter Before Grouping)

-- 49. Among flights longer than 300 minutes only, what is the average duration per airline?
select airline, avg(duration_mins) as "Average Flight Duration"
from flights
where duration_mins > 300
group by airline ;

-- 50. Among Kenya Airways flights only, how many routes does it operate per destination?
select destination , count(destination) as "routes per destination"
from flights
where airline = 'Kenya Airways'
group by destination ;

-- 51. Among flights in January 2024 only, what is the total flying time per airline?
select airline, sum(duration_mins ) as "Total flying time per airline in january" 
from flights 
where date between '2024/01/01' and '2024/01/31'
group by airline ;

-- 52. Among flights departing from Nairobi only, which airline operates the most flights?
select airline, count(*) as "Total tally"
from flights
where origin = 'NBO'
group by airline 
order by "Total tally" desc 
limit 1;

-- 53. Among short-haul flights (under 180 minutes) only, what is the average duration per airline?
select airline, avg(duration_mins) as "Average Duration per airline"
from flights 
where duration_mins <= 180
group  by airline ;

-- 54. Among ultra-long-haul flights (over 540 minutes) only, how many does each airline operate?
select airline, count(*) as "Airline Count"
from flights 
where duration_mins >= 540
group  by airline ;

-- 55. Among flights arriving in Dubai (DXB) only, what is the average inbound flight duration?
select avg(duration_mins) as "Average flight duration"
from flights
where destination = 'DXB';
-- ---

-- ### 📋 HAVING — Filtering After Grouping

-- 56. Which airlines operate more than 5 flights in the dataset?
select airline, count(*) as "Total Flights"
from flights 
group by airline
having count(*) > 5; 

-- 57. Which airlines operate fewer than 3 flights?
select airline, count(*) as "Total Flights"
from flights 
group by airline
having count(*) < 3; 

-- 58. Which origin airports have more than 5 departures?
select origin, count(*) as "Departure Count"
from flights 
group by origin 
having count(*) > 5;

-- 59. Which airlines have an average flight duration greater than 400 minutes?
select airline, avg(duration_mins) as "Average Flight duration"
from flights f 
group by airline
having avg(f.duration_mins ) > 400;

-- 60. Which airlines have an average flight duration less than 300 minutes?
select airline, avg(duration_mins) as "Average Flight duration"
from flights f 
group by airline
having avg(f.duration_mins ) < 300;

-- 61. Which destination airports receive more than 4 arrivals?
select destination , count(*) as "Destination Count"
from flights 
group by destination 
having count(*) > 4;

-- 62. Which dates had more than 3 flights scheduled?
select date, count(*) as "Flights per day Count"
from flights 
group by date 
having count(*) > 3;

-- 63. Which airlines have a total flying time greater than 1,000 minutes?
select airline, sum(duration_mins ) as "Total Flight Hours"
from flights 
group by airline
having sum(duration_mins) > 1000;

-- 64. Which origin airports have an average departure duration above 500 minutes?
select origin , sum(duration_mins ) as "Total Flight Hours"
from flights 
group by origin 
having sum(duration_mins) > 500;

-- 65. Which airlines have both more than 3 flights AND an average duration over 400 minutes?
select airline, sum(duration_mins ) as "Total Flight Hours", count(*) as "Flight Count"
from flights 
group by airline
having sum(duration_mins) > 400 and count(*) > 3;
-- ---

-- ### ✈️ Real-World Business Questions

-- *These are questions an airline analyst or operations manager would actually ask:*

-- 66. **Network Planning:** How many routes does each airline operate — as measured by number of distinct origin-destination pairs they appear in?

-- 67. **Capacity Report:** Which airlines accumulate the most total airborne minutes — a proxy for fleet utilization?
select airline, sum(duration_mins) as "Total Flight Duration"
from flights
group by airline 
order by "Total Flight Duration" desc
limit 1;

-- 68. **Hub Dominance:** Which origin airports generate the most departures — indicating the strongest hub activity?
select origin , count(*) as "Total departure count"
from flights
group by origin 
order by "Total departure count"  desc
limit 1;

-- 69. **Route Popularity:** Which destination airports receive the most inbound flights — useful for terminal capacity planning?
select destination , count(*) as "Total destination count"
from flights
group by destination 
order by "Total destination count" desc
limit 1;

-- 70. **Airline Size Ranking:** Rank all airlines from largest to smallest by number of flights operated
select airline , count(*) as "Total flights per airline"
from flights
group by airline
order by "Total flights per airline" desc;

-- 71. **Average Stage Length:** What is the average flight duration per airline — airlines with higher averages operate more long-haul networks
select airline , avg(duration_mins) as "Aversge flights per airline"
from flights
group by airline;

-- 72. **Busiest Travel Days:** Which dates had the highest number of flights — useful for staffing and gate planning?
select date, count(*) as "Flight count per day"
from flights 
group by date
order by "Flight count per day" desc
limit 1;

-- 73. **Ground Crew Scheduling:** How many flights arrive per destination per day on average?
select destination, count(*)
from flights f 
group by destination ;

-- 74. **Fleet Mix Analysis:** How many flights fall into short-haul (under 180 mins), medium-haul (180–480 mins), and long-haul (over 480 mins) categories per airline?

-- 75. **Revenue Potential:** Which airlines have the highest total flying minutes — longer flights generate more ancillary revenue per flight?
-- 76. **Kenya Airways Network Report:** What is the total number of flights, average duration, shortest route, and longest route for Kenya Airways specifically?
-- 77. **Competitor Benchmarking:** How does the average flight duration of Emirates compare to British Airways and Singapore Airlines?
-- 78. **Operational Efficiency:** Which airlines have the highest variance between their shortest and longest flights — indicating a very mixed network?
-- 79. **African Hub Analysis:** How many total flights depart from African airports (NBO, JNB, ADD, ACC, DAR) grouped by airline?
-- 80. **Monthly Volume Report:** How many flights were operated in January 2024 versus February 2024?
-- 81. **Route Frequency:** How many times does each origin-destination pair appear — identifying the most frequently operated routes?
-- 82. **Minimum Viable Network:** Which airlines operate only a single flight in the dataset — possible charter or seasonal operators?
-- 83. **Peak Day Operations:** On the busiest day in the dataset, how many flights did each airline operate?
-- 84. **Long-Haul Specialist:** Which airlines have an average flight duration above the overall dataset average — indicating a long-haul focused network?
-- 85. **Turnaround Pressure:** Which destination airports have the highest number of arrivals on a single day — indicating peak ground pressure?

-- ---

-- ### 💡 Challenge Questions

-- *These combine Day 1 and Day 2 skills together:*

-- 86. Among airlines with more than 3 flights, which has the highest average duration — sorted descending?
-- 87. For each origin airport, show total flights and average duration, but only for airports with more than 2 departures
-- 88. Which airline has the single longest maximum flight AND the single shortest minimum flight — showing the widest operational range?
-- 89. Among dates in January 2024 only, which 3 dates had the highest total flying time across all airlines?
-- 90. For each airline, what percentage of its flights are long-haul (over 480 minutes) — expressed as a count out of its total flights?

-- ---

-- These 90 questions are scoped entirely to Day 2 tools. By the time you finish them you will have a solid intuition for aggregating and summarising data — the foundation of every analytical report you will ever build on aviation data.