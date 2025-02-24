-- -- tag::code_airports_dwithin_distinct_on[]
-- SELECT DISTINCT ON (a.ident) 
--     a.ident, 
-- 	a.name As airport, 
-- 	n.name As closest_navaid, 
-- 	(ST_Distance(a.geog,n.geog)/1000)::integer As dist_km
-- --
-- FROM ch09.airports As a LEFT JOIN ch09.navaids As n 
-- --
-- ON ST_DWithin(a.geog, n.geog,100000) 
-- ORDER BY a.ident, dist_km; 
-- -- end::code_airports_dwithin_distinct_on[]

-- -- tag::code_airports_dwithin_distinct_on, order result by dist_km[]
-- -- FIND CLOSET LOCATIONS – EXERCISE 01
-- SELECT *
-- FROM (
--     SELECT DISTINCT ON (a.ident) 
--         a.ident, 
--         a.name AS airport, 
--         n.name AS closest_navaid, 
--         (ST_Distance(a.geog, n.geog)/1000)::integer AS dist_km
--     FROM ch09.airports AS a
--     LEFT JOIN ch09.navaids AS n 
--     ON ST_DWithin(a.geog, n.geog, 100000)
--     ORDER BY a.ident, dist_km
-- ) AS subquery
-- ORDER BY dist_km;
-- -- end::code_airports_dwithin_distinct_on, order result by dist_km[]

-- -- tag::FIND CLOSET LOCATIONS - EXERCISE 02
-- SELECT DISTINCT ON (a.ident) 
--     a.ident, 
-- 	a.name As navaid, 
-- 	n.name As closest_airport, 
-- 	(ST_Distance(a.geog,n.geog)/1000)::integer As dist_km
-- --
-- FROM ch09.navaids As a LEFT JOIN ch09.airports As n 
-- --
-- ON ST_DWithin(a.geog, n.geog,100000) 
-- ORDER BY a.ident, dist_km; 


-- -- tag::code_dwithin_between[]
-- SELECT name, iso_country, iso_region, geog
-- FROM ch09.airports
-- WHERE ST_DWithin(geog, 
--         ST_Point(-75.8008, 42.2610)::geography, 100000)
--   AND NOT ST_DWithin(geog, 
--             ST_Point(-75.8008, 42.2610)::geography, 90000);
-- -- end::code_dwithin_between[]

-- -- tag::check is geography or geometry[]
-- SELECT column_name, data_type
-- FROM information_schema.columns
-- WHERE table_name = 'airports' AND column_name = 'geog';
-- -- tag::code_dwithin_between[]

-- -- K NEAREST NEIGHBOR
-- SELECT ident, name,geog,
--     geog <-> (SELECT geog 
--              FROM  ch09.airports WHERE ident = 'KBOS') AS dist
-- FROM ch09.airports
-- WHERE ident != 'KBOS' AND type = 'large_airport'
-- ORDER BY dist LIMIT 10;
-- -- end::code_knn_geog_1[]

-- -- K NEAREST NEIGHBOR Exercise 01
-- SELECT ident, name,geog,
--     geog <-> (SELECT geog 
--              FROM  ch09.navaids WHERE filename = 'Bedds_NDB_US') AS dist
-- FROM ch09.navaids
-- WHERE filename != 'Bedds_NDB_US'
-- ORDER BY dist LIMIT 10;

-- -- K nearest neighbor WITH ROW_NUMBER – exercise 01
-- WITH ranked_airports AS (
--     SELECT 
--         ident, 
--         name, 
--         geog,
--         geog <-> (SELECT geog FROM ch09.airports WHERE ident = 'KBOS') AS dist,
-- 		--
--         ROW_NUMBER() OVER (ORDER BY geog <-> (SELECT geog FROM ch09.airports WHERE ident = 'KBOS')) AS rank_num
-- 		--
--     FROM ch09.airports
--     WHERE ident != 'KBOS' AND type = 'large_airport'
-- )
-- SELECT rank_num, ident, name, geog, dist
-- FROM ranked_airports
-- WHERE rank_num <= 10;

-- -- ROW_NUMBER() and RANK()
-- WITH ranked_airports AS (
--     SELECT 
--         ident, 
--         name, 
--         geog,
--         geog <-> (SELECT geog FROM ch09.airports WHERE ident = 'KBOS') AS dist,
--         ROW_NUMBER() OVER (ORDER BY geog <-> (SELECT geog FROM ch09.airports WHERE ident = 'KBOS')) AS row_num,
--         RANK() OVER (ORDER BY geog <-> (SELECT geog FROM ch09.airports WHERE ident = 'KBOS')) AS rank_num
--     FROM ch09.airports
--     WHERE ident != 'KBOS' AND type = 'large_airport'
-- )
-- SELECT row_num, rank_num, ident, name, geog, dist
-- FROM ranked_airports
-- WHERE rank_num <= 10;






