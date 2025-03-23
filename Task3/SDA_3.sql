--1. Sprawdź, czy mniejszy wielokąt i wielokąt z otworem są jednakowe.
SELECT ST_Equals((SELECT geom FROM geometries WHERE name = 'Polygon'), (SELECT geom FROM geometries WHERE name = 'PolygonWithHole'));

--2. Sprawdź, czy mniejszy wielokąt i wielokąt z otworem na siebie zachodzą.
SELECT ST_Overlaps((SELECT geom FROM geometries WHERE name = 'Polygon'), (SELECT geom FROM geometries WHERE name = 'PolygonWithHole'));

--3. Sprawdź, czy mniejszy wielokąt znajduje się wewnątrz wielokąta z otworem.
SELECT ST_Within((SELECT geom FROM geometries WHERE name = 'Polygon'), (SELECT geom FROM geometries WHERE name = 'PolygonWithHole'))

--4. Sprawdź, czy wielokąt z otworem zawiera mniejszy wielokąt.
SELECT ST_Contains((SELECT geom FROM geometries WHERE name = 'PolygonWithHole'), (SELECT geom FROM geometries WHERE name = 'Polygon'))

--5. Sprawdź, czy linia i mniejszy wielokąt są rozłączne.
SELECT ST_Disjoint((SELECT geom FROM geometries WHERE name = 'Linestring'), (SELECT geom FROM geometries WHERE name = 'Polygon'))

--6. Sprawdź, czy linia i mniejszy wielokąt krzyżują się.
SELECT ST_Crosses((SELECT geom FROM geometries WHERE name = 'Linestring'), (SELECT geom FROM geometries WHERE name = 'Polygon'))

--7. Sprawdź, czy linia i mniejszy wielokąt przecinają się.
SELECT ST_Intersects((SELECT geom FROM geometries WHERE name = 'Linestring'), (SELECT geom FROM geometries WHERE name = 'Polygon'))

--8. Sprawdź, czy linia i mniejszy wielokąt dotykają się.
SELECT ST_Touches((SELECT geom FROM geometries WHERE name = 'Linestring'), (SELECT geom FROM geometries WHERE name = 'Polygon'));

--9. Sprawdź, czy punkt i linia znajdują się od siebie w promieniu równym 5.
SELECT ST_DWithin((SELECT geom FROM geometries WHERE name = 'Point'), (SELECT geom FROM geometries WHERE name = 'Linestring'), 5);

--10. Wyświetl odległość między punktem a linią.
SELECT ST_Distance((SELECT geom FROM geometries WHERE name = 'Point'), (SELECT geom FROM geometries WHERE name = 'Linestring'));

----Zapytania

--1. Wyświetl nazwę osiedla i dzielnicy, w których znajduje się stacja metra East Broadway.
SELECT nh.name, nh.boroname
FROM nyc_neighborhoods nh
WHERE ST_Contains(nh.geom, (SELECT geom FROM nyc_subway_stations WHERE name = 'East Broadway'));

--2. Wyświetl nazwy ulic znajdujących się w promieniu 20 metrów od stacji metra Botanic Garden.
SELECT nyc_streets.name 
FROM nyc_streets
WHERE ST_DISTANCE(nyc_streets.geom, (
	SELECT nyc_subway_stations.geom 
	FROM nyc_subway_stations 
	WHERE nyc_subway_stations.name LIKE 'Botanic Garden')
) <= 20;

--3. Wyświetl nazwy ulic, z którymi skrzyżowania ma ulica Pulaski St.
SELECT name 
FROM nyc_streets
WHERE ST_Intersects(nyc_streets.geom, (
	SELECT nyc_streets.geom 
	FROM nyc_streets
	WHERE nyc_streets.name LIKE 'Pulaski St')) AND name != 'Pulaski St';

--4. Wyświetl liczbę mieszkańców, którzy żyją w promieniu 100 metrów od ulicy Kosciuszko St.
SELECT SUM(nyc_census_blocks.popn_total) 
FROM nyc_census_blocks
WHERE ST_Distance(nyc_census_blocks.geom, (
	SELECT nyc_streets.geom
	FROM nyc_streets
	WHERE nyc_streets.name LIKE 'Kosciuszko St'
)) <= 100;

--5. Wyświetl rodzaj broni oraz liczbę zabójstw, które popełniono na osiedlu Clearview z użyciem tego rodzaju broni.
SELECT weapon, SUM(Cast(num_victim AS INTEGER)) 
FROM nyc_homicides
WHERE ST_Contains((
	SELECT geom 
	FROM nyc_neighborhoods
	WHERE name LIKE 'Clearview'
), nyc_homicides.geom)
GROUP BY weapon;