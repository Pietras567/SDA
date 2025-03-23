-- 1. Wyświetl nazwę osiedla i dzielnicy, w których znajduje się stacja metra East Broadway.
SELECT nb.name, nb.boroname
FROM nyc_neighborhoods AS nb
JOIN nyc_subway_stations AS ss
ON ST_Contains(nb.geom, ss.geom)
WHERE ss.name = 'East Broadway';

-- 2. Wyświetl nazwy ulic znajdujących się w promieniu 20 metrów od stacji metra Botanic Garden.
SELECT st.name
FROM nyc_streets AS st
JOIN nyc_subway_stations AS ss
ON ST_DWithin(st.geom, ss.geom, 20)
WHERE ss.name = 'Botanic Garden';

-- 3. Wyświetl nazwy ulic, z którymi skrzyżowania ma ulica Pulaski St.
SELECT st2.name
FROM nyc_streets AS st1
JOIN nyc_streets AS st2
ON ST_Intersects(st1.geom, st2.geom)
WHERE st1.name LIKE 'Pulaski St' AND st2.name != 'Pulaski St';

-- 4. Wyświetl liczbę mieszkańców, którzy żyją w promieniu 100 metrów od ulicy Kosciuszko St.
SELECT SUM(cb.popn_total) 
FROM nyc_census_blocks AS cb
JOIN nyc_streets AS st
ON ST_Distance(st.geom, cb.geom) <= 100
WHERE st.name LIKE 'Kosciuszko St';

-- 5. Wyświetl rodzaj broni oraz liczbę przestępstw, które popełniono na osiedlu Clearview z użyciem tego rodzaju broni.
SELECT hm.weapon, COUNT(hm.num_victim)
FROM nyc_homicides AS hm
JOIN nyc_neighborhoods AS nb
ON ST_Contains(nb.geom, hm.geom)
WHERE nb.name LIKE 'Clearview'
GROUP BY weapon;

-- 1. Wyświetl liczbę mieszkańców osiedla Battery Park.
SELECT SUM(cb.popn_total)
FROM nyc_census_blocks AS cb
JOIN nyc_neighborhoods AS nb
ON ST_Intersects(nb.geom, cb.geom)
WHERE nb.name LIKE 'Battery Park';

-- 2. Dla każdego osiedla wyświetl jego nazwę oraz zaokrąglony do dwóch miejsc po przecinku procentowy udział w całkowitej liczbie mieszkańców społeczności rasy białej, czarnej i żółtej. Ogranicz wyniki dla dzielnicy Staten Island.
SELECT nb.name, 
	ROUND((SUM(cb.popn_white) / NULLIF(SUM(cb.popn_total), 0) * 100)::numeric, 2) AS white,
	ROUND((SUM(cb.popn_black) / NULLIF(SUM(cb.popn_total), 0) * 100)::numeric, 2) AS black,
	ROUND((SUM(cb.popn_asian) / NULLIF(SUM(cb.popn_total), 0) * 100)::numeric, 2) as asian
FROM nyc_census_blocks AS cb
JOIN nyc_neighborhoods AS nb
ON ST_Intersects(nb.geom, cb.geom)
WHERE nb.boroname LIKE 'Staten Island'
GROUP BY nb.name;

-- 3. Wyświetl nazwy osiedli oraz wyrażoną w liczbie osób na kilometr kwadratowy gęstość zaludnienia trzech najgęściej zaludnionych osiedli.
SELECT nb.name, SUM(cb.popn_total) / (ST_Area(nb.geom) / 1000 ^ 2) AS pop_pr_kmsq
FROM nyc_neighborhoods AS nb
JOIN nyc_census_blocks AS cb
ON ST_Intersects(nb.geom, cb.geom)
GROUP BY nb.name, nb.geom
ORDER BY pop_pr_kmsq DESC
FETCH FIRST 3 ROWS WITH TIES;

-- 4. Wyświetl nazwy stacji metra, które znajdują się na osiedlu Utopia.
SELECT ss.name
FROM nyc_subway_stations AS ss
JOIN nyc_neighborhoods AS nb
ON ST_Intersects(ss.geom, nb.geom)
WHERE nb.name LIKE 'Utopia';

-- 5. Wyświetl nazwy osiedli i dzielnic, przez które przebiega linia metra F.
SELECT DISTINCT nb.name, nb.boroname
FROM nyc_subway_stations AS ss
JOIN nyc_neighborhoods AS nb
ON ST_Intersects(ss.geom, nb.geom)
WHERE ss.routes LIKE '%F%';

-- 6. Dla każdej stacji metra wyświetl jej nazwę oraz liczbę mieszkańców, którzy żyją w promieniu 100 metrów od niej. Ogranicz wyniki dla stacji metra, przez które przebiega linia fioletowa. Dane posortuj malejąco według liczby mieszkańców.
SELECT ss.name, SUM(cb.popn_total) as suma
FROM nyc_subway_stations AS ss
JOIN nyc_census_blocks AS cb
ON ST_DWithin(ss.geom, cb.geom, 100)
WHERE ss.color LIKE '%PURPLE%'
GROUP BY ss.name
ORDER BY suma DESC;