-- -- Example 1: Find all streets within 50 meters of subway stations (using buffer).

SELECT street.name, subway.borough
FROM ch05.streets AS street, ch05.subway AS subway
WHERE ST_Intersects(street.geom, ST_Buffer(subway.geom, 50));

-- -- Exercise 1: Find all one-way streets within 50 meters of subway stations.
-- SELECT street.name, subway.borough
-- FROM ch05.streets AS street, ch05.subway AS subway
-- WHERE oneway = 'yes' AND ST_Intersects(street.geom, ST_Buffer(subway.geom, 50));

-- -- Example 2: Identify neighborhoods where there are subway stations
-- SELECT nbh.boroname, COUNT(*) AS station_count
-- FROM ch05.neighborhoods AS nbh, ch05.subway as subway
-- WHERE ST_Intersects(nbh.geom, subway.geom)
-- GROUP BY boroname;

-- -- Exercise 2: Identify neighborhoods with more than 100 subway stations
-- SELECT nbh.boroname, COUNT(*) AS station_count
-- FROM ch05.neighborhoods AS nbh, ch05.subway as subway
-- WHERE ST_Intersects(nbh.geom, subway.geom)
-- GROUP BY boroname
-- HAVING COUNT(*) > 100;

-- Example 3:List all subway stations where express trains stop that are within 50 meters of residential roads.
SELECT subway.name, street.name
FROM ch05.subway AS subway, ch05.streets AS street
WHERE subway.express = 'express' AND street.type = 'residential'AND ST_Intersects(ST_Buffer(subway.geom, 50), street.geom);

----------------------------------------------
-- ST_Disjoint
-- Example 1: Find neighborhoods with no subway stations
-- SELECT boroname
-- FROM ch05.neighborhoods
-- WHERE NOT EXISTS ( 
-- SELECT 1 FROM ch05.subway    
-- WHERE ST_Disjoint(ch05.neighborhoods.geom, ch05.subway.geom) = FALSE);


-- Exercise 1: Find streets that do not intersect with any subway station with 500 meter buffer
-- SELECT street.name,street.geom
-- FROM ch05.streets AS street, ch05.subway  
-- WHERE ST_Disjoint(street.geom, ch05.subway.geom);




