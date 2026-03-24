## Day 1 SQL Practice Questions — flights table

Using only: `SELECT`, `WHERE`, `ORDER BY`, and aliases.

---

### 🔍 Basic Retrieval

1. Retrieve every flight in the dataset
2. Show only the flight ID, origin, and destination for all flights
3. Display all flights and rename the columns to something more readable — for example `duration_mins` as `Flight Duration`
4. Show all columns for flight FL045
5. Retrieve all flights operated by Kenya Airways
6. Show all flights that depart from Nairobi (NBO)
7. Show all flights that arrive in Dubai (DXB)
8. Retrieve all flights on the date 2024-01-15

---

### 📏 Filtering with WHERE

9. Find all flights longer than 500 minutes
10. Find all flights shorter than 120 minutes
11. Find all flights that are exactly 510 minutes long
12. Retrieve all flights that are NOT operated by Emirates
13. Find all flights departing from London Heathrow (LHR)
14. Find all flights arriving in Nairobi (NBO)
15. Retrieve all flights operated by British Airways
16. Find all flights that depart from Singapore (SIN)
17. Show all flights arriving in Sydney (SYD)
18. Find all flights that took place in February 2024

---

### 🔗 Combining Conditions (AND / OR / NOT)

19. Find all Kenya Airways flights departing from Nairobi
20. Find all flights departing from either London (LHR) or Paris (CDG)
21. Find all Emirates flights longer than 400 minutes
22. Find all flights that are shorter than 100 minutes OR longer than 700 minutes
23. Find all Delta Air Lines flights arriving in Atlanta (ATL)
24. Find all flights departing from Nairobi that are longer than 300 minutes
25. Find all flights that are NOT departing from Nairobi AND NOT arriving in Dubai
26. Find all flights operated by American Airlines going to Los Angeles (LAX)
27. Find all British Airways flights shorter than 100 minutes
28. Find all flights arriving in London (LHR) that are longer than 5 hours (300 minutes)

---

### 📊 Sorting with ORDER BY

29. List all flights sorted by duration from shortest to longest
30. List all flights sorted by duration from longest to shortest
31. List all flights sorted by date from earliest to most recent
32. List all flights sorted alphabetically by airline name
33. Show all flights departing from Nairobi, sorted by duration
34. Show all Kenya Airways flights sorted by date
35. List all flights sorted by origin airport alphabetically
36. Show all flights over 400 minutes, sorted from longest to shortest

---

### ✈️ Real-World Business Questions

*These are questions an airline analyst would actually ask:*

37. **Route Planning:** Which flights operate on the Nairobi to London route?
38. **Short-Haul Identification:** What flights qualify as short-haul — under 3 hours (180 minutes)?
39. **Long-Haul Identification:** What flights qualify as ultra-long-haul — over 9 hours (540 minutes)?
40. **Competitor Analysis:** Show all flights not operated by Kenya Airways on routes out of Nairobi
41. **Schedule Review:** What flights were scheduled on the first day of the dataset?
42. **Capacity Planning:** List all flights arriving into Dubai (DXB) sorted by date — for ground crew scheduling
43. **Fleet Utilization:** Find all flights longer than 8 hours — these would require a wide-body aircraft
44. **Regional Operations:** Show all flights with a duration under 2 hours — candidates for turboprop aircraft
45. **Codeshare Check:** Find all flights between London (LHR) and Dubai (DXB) in either direction
46. **Revenue Management:** Show all Emirates flights sorted by duration — longer flights typically generate more revenue
47. **Hub Analysis:** Find all flights departing from OR arriving into Nairobi (NBO)
48. **Operations Report:** List all flights for a specific week — between 2024-01-07 and 2024-01-14
49. **Airline Performance View:** Show all flights operated by United Airlines sorted by flight date
50. **Ground Ops Turnaround:** Find all flights under 90 minutes — these have the tightest turnaround windows for ground crews

---

### 💡 Challenge Questions

*These require combining multiple clauses carefully:*

51. Find all flights shorter than 200 minutes that are NOT operated by Southwest Airlines, sorted by duration
52. Show all flights in January 2024 departing from either New York (JFK) or Los Angeles (LAX), sorted by date
53. Find all long-haul flights (over 480 minutes) operated by either Singapore Airlines or Japan Airlines
54. List all Qantas flights sorted by duration — labelling duration as `flight_time`
55. Find all flights that depart from African airports — NBO, JNB, ADD, ACC, DAR, CMB — sorted by airline name

---
