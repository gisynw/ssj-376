-- SELECT
-- filename,
-- COUNT(rast) As num_tiles,
-- ST_Union(rast) As rast
-- FROM ch10.prec
-- WHERE filename IN ('wc2.1_10m_prec_01.tif','wc2.1_10m_prec_12.tif')
-- GROUP BY filename;

-- SELECT ST_Union(ST_Clip(rast,geom)) AS rast
-- FROM
-- ch10.elev
-- CROSS JOIN
-- ST_MakeEnvelope(42.24106,-71.78586,42.26774,-71.79479,4326) As geom
-- WHERE ST_Intersects(rast,geom);
DROP TABLE IF EXISTS ch10.elev_clipped;
-- save result to raster table
-- Step 1: Create a new raster table
CREATE TABLE ch10.elev_clipped (
    id SERIAL PRIMARY KEY,
    rast raster
);

-- Step 2: Insert the raster result into the new table
INSERT INTO ch10.elev_clipped (rast)
SELECT ST_Union(ST_Clip(rast, geom)) AS rast
FROM ch10.elev
CROSS JOIN ST_MakeEnvelope(-71, 42, -71.5, 42.5, 4326) AS geom
WHERE ST_Intersects(rast, geom);

-- Step 2: Insert the raster result into the new table
INSERT INTO ch10.elev_clipped (rast)
SELECT ST_Union(ST_Clip(rast, geom)) AS rast
FROM ch10.elev
CROSS JOIN ST_MakeEnvelope(8,47,8.5,47.5,4326) AS geom
WHERE ST_Intersects(rast, geom);




