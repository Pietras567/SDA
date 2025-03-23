--1
CREATE VIEW hrabstwa AS
SELECT *
FROM counties
WHERE no_farms87 > 500 
    AND age_18_64 >= 25000
    AND pop_sqmile < 150;

--2
CREATE VIEW miasta AS
SELECT DISTINCT ci.*
FROM cities as ci
JOIN counties as co
ON ST_Intersects(ci.geom, co.geom)
WHERE ci.crime_inde <= 0.02 
    AND ci.university > 0
    AND co.no_farms87 > 500 
    AND co.age_18_64 >= 25000
    AND co.pop_sqmile < 150;

--3
CREATE VIEW droga_ms AS
SELECT DISTINCT ci.*
FROM cities as ci
JOIN counties as co
ON ST_Intersects(ci.geom, co.geom)
JOIN interstates as i
ON ST_DWithin(ci.geom, i.geom, 105600)
WHERE ci.crime_inde <= 0.02 
    AND ci.university > 0
    AND co.no_farms87 > 500 
    AND co.age_18_64 >= 25000
    AND co.pop_sqmile < 150;

--4
CREATE VIEW rekreacja AS
SELECT DISTINCT ci.*
FROM cities as ci
JOIN counties as co
ON ST_Intersects(ci.geom, co.geom)
JOIN interstates as i
ON ST_DWithin(ci.geom, i.geom, 105600)
JOIN recareas as r
ON ST_DWithin(ci.geom, r.geom, 52800)
WHERE ci.crime_inde <= 0.02 
    AND ci.university > 0
    AND co.no_farms87 > 500 
    AND co.age_18_64 >= 25000
    AND co.pop_sqmile < 150;