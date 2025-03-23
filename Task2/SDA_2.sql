--1
CREATE TABLE geometries (
	name VARCHAR(255),
	geom geometry
)

--2
INSERT INTO geometries VALUES
  ('Point', 'POINT(0 0)'),
  ('Linestring', 'LINESTRING(0 0, 1 1, 2 1, 2 2)'),
  ('Polygon', 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
  ('PolygonWithHole', 'POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
  ('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');
  
--3
SELECT name, geom FROM geometries;

--4
SELECT name, ST_AsText(geom) FROM geometries;

--5
SELECT * FROM geometry_columns;

--6
SELECT name, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom)
  FROM geometries;

--7
SELECT ST_X(geom), ST_Y(geom)
  FROM geometries
  WHERE name = 'Point';
  
--8
SELECT ST_Length(geom)
  FROM geometries
  WHERE name = 'Linestring';
  
--9
SELECT name, ST_Area(geom)
  FROM geometries
  WHERE name LIKE 'Polygon%';
  
--10
SELECT name, ST_NumGeometries(geom)
  FROM geometries
  WHERE name = 'Collection';
  
--ZAPYTANIA
--1
SELECT name, ST_Area(geom)
  FROM nyc_neighborhoods
  WHERE name = 'West Village';
	
--2
SELECT boroname, (SUM(ST_Area(geom))/(SELECT SUM(ST_Area(geom)) FROM nyc_neighborhoods)) * 100
  FROM nyc_neighborhoods
  GROUP BY boroname;
  
--3
SELECT SUM(ST_Length(geom)) 
  FROM nyc_streets
  
--4
SELECT name, ST_Length(geom) 
  FROM nyc_streets
  WHERE ST_Length(geom) >= (SELECT MAX(ST_Length(geom)) FROM nyc_streets);
  
--5
SELECT name, ST_GeometryType(geom)
  FROM nyc_subway_stations
  WHERE name = 'Morris Park';
  
--6
SELECT name, ST_AsGML(geom), ST_AsGeoJSON(geom)
  FROM nyc_subway_stations;
  
 --7
SELECT name
  FROM nyc_subway_stations
  WHERE ST_X(geom) <= (SELECT MIN(ST_X(geom)) FROM nyc_subway_stations);
  
--8
SELECT type, SUM(ST_Length(geom))
  FROM nyc_streets
  GROUP BY type;