-- -- check extension
-- SELECT n.nspname AS schema_name, e.extname AS extension_name
-- FROM pg_extension e
-- JOIN pg_namespace n ON e.extnamespace = n.oid
-- WHERE e.extname = 'postgis';


-- -- Add extension to ch16
-- DROP EXTENSION pgrouting;
-- DROP EXTENSION postgis;
-- CREATE EXTENSION pgrouting SCHEMA ch16;
-- CREATE EXTENSION postgis;

-- -- Add two new columns for the 
-- SET search_path TO ch16, public;

-- ALTER TABLE ch16.twin_cities ADD COLUMN source integer;
-- ALTER TABLE ch16.twin_cities ADD COLUMN target integer;
-- ALTER TABLE ch16.twin_cities
-- ALTER COLUMN geom type geometry(LINESTRING,4326) USING
-- ST_Transform(geom,4326);

-- Create Topology
SET search_path TO ch16;

UPDATE ch16.twin_cities SET source = NULL, target = NULL;

SELECT ch16.pgr_createTopology(
'ch16.twin_cities',
1,
'geom',
'gid',
'source',
'target',
'',
true
);

-- -- Create length column for the table
-- ALTER TABLE ch16.twin_cities ADD COLUMN length float8;
-- UPDATE ch16.twin_cities
-- SET length = ST_Length(geom::geography);

-- --Dijkstra shortest path algorithm
-- SELECT pd.seq, e.geom, pd.cost, pd.node
-- INTO ch16.dijkstra_result
-- FROM
-- pgr_Dijkstra(
-- 'SELECT gid AS id, source, target, length As cost
-- FROM ch16.twin_cities',
-- (SELECT id
-- FROM ch16.twin_cities_vertices_pgr
-- ORDER BY the_geom <-> ST_SetSRID(ST_Point(-93.8,45.2),4326)
-- LIMIT 1
-- ),
-- (SELECT id
-- FROM ch16.twin_cities_vertices_pgr
-- ORDER BY the_geom <-> ST_SetSRID(ST_Point(-93.2,44.6),4326)
-- LIMIT 1
-- ),
-- directed =>false
-- ) As pd
-- LEFT JOIN
-- ch16.twin_cities As e
-- ON pd.edge = e.gid
-- ORDER BY pd.seq;





