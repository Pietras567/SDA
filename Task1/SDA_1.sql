--1. 
SELECT nyc_neighborhoods.boroname, COUNT(nyc_neighborhoods.name) 
FROM nyc_neighborhoods
GROUP BY nyc_neighborhoods.boroname
ORDER BY nyc_neighborhoods.boroname;

--2.
SELECT nyc_census_blocks.boroname, SUM(nyc_census_blocks.popn_total) 
FROM nyc_census_blocks
GROUP BY nyc_census_blocks.boroname
ORDER BY SUM(nyc_census_blocks.popn_total) DESC;

--3. 
SELECT 
nyc_census_blocks.boroname, 
ROUND((SUM(nyc_census_blocks.popn_white)/SUM(nyc_census_blocks.popn_total))::numeric ,2) * 100 AS white, 
ROUND((SUM(nyc_census_blocks.popn_black)/SUM(nyc_census_blocks.popn_total))::numeric ,2) * 100 AS black, 
ROUND((SUM(nyc_census_blocks.popn_asian)/SUM(nyc_census_blocks.popn_total))::numeric ,2) * 100 AS asian
FROM nyc_census_blocks
GROUP BY nyc_census_blocks.boroname
ORDER BY SUM(nyc_census_blocks.popn_total) DESC;

--4. 
SELECT nyc_streets.type, COUNT(nyc_streets.name)
FROM nyc_streets
GROUP BY nyc_streets.type;

--5.
SELECT nyc_subway_stations.borough, COUNT(nyc_subway_stations.gid) 
FROM nyc_subway_stations
GROUP BY nyc_subway_stations.borough;

--6.
SELECT COUNT(nyc_subway_stations.express), COUNT(nyc_subway_stations.gid) - COUNT(nyc_subway_stations.express)
FROM nyc_subway_stations;

--7.
SELECT COUNT(nyc_subway_stations.closed)
FROM nyc_subway_stations
WHERE nyc_subway_stations.closed = 'yes'

--8.
SELECT DISTINCT nyc_subway_stations.name
FROM nyc_subway_stations
WHERE nyc_subway_stations.color LIKE '%RED%'

--9.
SELECT nyc_homicides.boroname, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
GROUP BY nyc_homicides.boroname

--10.
SELECT nyc_homicides.weapon, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
GROUP BY nyc_homicides.weapon

--11.
SELECT nyc_homicides.year, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
GROUP BY nyc_homicides.year

--12.
SELECT EXTRACT(MONTH from nyc_homicides.incident_d) as miesiac, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
GROUP BY miesiac
ORDER BY miesiąc

--13.
SELECT DATE_PART('DOW', nyc_homicides.incident_d) as dzien, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
GROUP BY dzien
ORDER BY dzień

--14.
SELECT *
FROM nyc_homicides
WHERE CAST(nyc_homicides.num_victim as INT) > 1

--15.
SELECT nyc_homicides.light_dark, SUM(CAST(nyc_homicides.num_victim as INT))
FROM nyc_homicides
WHERE nyc_homicides.light_dark IS NOT null
GROUP BY nyc_homicides.light_dark;