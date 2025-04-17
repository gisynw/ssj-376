-- SELECT PostGIS_Full_Version();

-- -- aggregate city 
-- CREATE TABLE ch11.boroughs_city AS
-- SELECT ST_Union(geom) AS geom
-- FROM ch11.boroughs;

-- -- check spatial reference
-- SELECT srid, srtext 
-- FROM spatial_ref_sys
-- WHERE srid = (SELECT ST_SRID(geom) FROM ch11.boroughs LIMIT 1);


-- -- new your city unified with 500-foot grid
-- CREATE TABLE ch11.boroughs_citi_500 AS 
-- SELECT ST_Union(geom, 500) AS geom
-- FROM ch11.boroughs;

-- -- new your city unified with 10000-foot grid
-- CREATE TABLE ch11.boroughs_citi_10000 AS 
-- SELECT ST_Union(geom, 10000) AS geom
-- FROM ch11.boroughs;

-- -- new your city unified with 1-foot grid
-- CREATE TABLE ch11.boroughs_citi_1 AS 
-- SELECT ST_Union(geom, 1) AS geom
-- FROM ch11.boroughs;

-- -- count points for each borough
-- SELECT 
--     (SELECT SUM(ST_NPoints(geom)) FROM ch11.boroughs) AS pts_original,
-- 	(SELECT ST_NPoints(geom) FROM ch11.boroughs_citi_500) AS pts_500,
--     (SELECT ST_NPoints(geom) FROM ch11.boroughs_citi_10000) AS pts_10000;

-- -- count how many geometry for the city
-- SELECT city,COUNT(city) AS num_records 
-- FROM ch11.cities
-- GROUP BY CITY 
-- ORDER BY num_records DESC;

-- -- aggregate geometry with condition
-- SELECT city,COUNT(city) AS num_records,

-- SUM(ST_NumGeometries(geom)) AS numpoly_before,
-- ST_NumGeometries(ST_Union(geom)) AS num_poly_after

-- FROM ch11.cities
-- GROUP BY city
-- HAVING COUNT(city) > 1;

-- -- check if any geometry share the boundary and belong to the same city
-- SELECT a.city, a.gid AS gid_1, b.gid AS gid_2
-- FROM ch11.cities a
-- JOIN ch11.cities b 
-- ON a.city = b.city  -- Same city name
-- AND a.gid < b.gid  -- Avoid self-join and duplicate pairs
-- AND ST_Touches(a.geom, b.geom);  -- Check if they share a boundary

-- aggregate polygon and save it into a new table
CREATE TABLE ch11.cities_merged AS
SELECT 
    city,
    COUNT(city) AS num_records,
    SUM(ST_NumGeometries(geom)) AS numpoly_before,
    ST_NumGeometries(ST_Union(geom)) AS num_poly_after,
    ST_Union(geom) AS merged_geom  -- Save the merged geometry
FROM ch11.cities
GROUP BY city
HAVING COUNT(city) > 0;
















