 -- Exercise 01
SELECT airport.name AS airport_name,
       COUNT(nav.name) AS nearby_nav_count,
       airport.geog AS geom
FROM ch09.airports AS airport
LEFT JOIN ch09.navaids AS nav
ON ST_DWithin(airport.geog, nav.geog, 1000000)  -- 50 km radius
GROUP BY airport.name, geom
HAVING COUNT(nav.name) < 3;

-- Exercise 02
SELECT airport.name AS airport_name,
       COUNT(nav.name) AS nearby_nav_count,
       airport.geog AS geom
FROM ch09.airports AS airport
LEFT JOIN ch09.navaids AS nav
ON ST_DWithin(airport.geog, nav.geog, 50000)  -- 50 km radius
GROUP BY airport.name, geom
ORDER BY nearby_nav_count DESC  -- Sort by highest number of navigation aids first
LIMIT 5;  -- Return the top 5 airports

-- Exercise 03
SELECT airport.name AS airport_name,
       COUNT(nav.name) AS nearby_nav_count,
       airport.geog AS geom
FROM ch09.airports AS airport
LEFT JOIN ch09.navaids AS nav
ON ST_DWithin(airport.geog, nav.geog, 50000)  -- 50 km radius
GROUP BY airport.name, geom
ORDER BY nearby_nav_count ASC  -- Sort by the lowest number of navigation aids first
LIMIT 10;  -- Return only the airport with the fewest navigation aids

-- Exercise 04
SELECT name, 
       iso_country, 
       iso_region, 
	   geog,
       (ST_Distance(geog, ST_Point(-75.8008, 42.2610)::geography) / 1000) AS distance_km
FROM ch09.airports
WHERE ST_Distance(geog, ST_Point(-75.8008, 42.2610)::geography) >= 90000  -- At least 90 km away
ORDER BY distance_km ASC  -- Sort by closest distance
LIMIT 3;  -- Return only the 3 closest airports

-- Exercise 05
SELECT ident, 
       name, 
       geog, 
       (geog <-> (SELECT geog 
                  FROM ch09.navaids 
                  WHERE filename != 'Bedds_NDB_US' 
                  ORDER BY geog <-> (SELECT geog FROM ch09.navaids WHERE filename = 'Bedds_NDB_US') DESC 
                  LIMIT 1)) / 1000 AS dist_km  -- Convert to kilometers
FROM ch09.navaids
WHERE filename != (SELECT filename 
                   FROM ch09.navaids 
                   WHERE filename != 'Bedds_NDB_US' 
                   ORDER BY geog <-> (SELECT geog FROM ch09.navaids WHERE filename = 'Bedds_NDB_US') DESC 
                   LIMIT 1)  -- Exclude itself
ORDER BY dist_km ASC  -- Sort by closest navigation aids
LIMIT 5;  -- Return only the 5 closest navigation aids

