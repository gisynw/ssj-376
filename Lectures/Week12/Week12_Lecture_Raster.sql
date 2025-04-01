-- -- check metadata
-- SELECT
--   rid,
--   ST_SRID(rast) AS srid,
--   ST_Width(rast) AS width,
--   ST_Height(rast) AS height,
--   ST_NumBands(rast) AS num_bands
-- FROM ch12.b1;

-- -- check pixel resolution, x and y of the starting point
-- SELECT
--   rid,
--  ST_ScaleX(rast) AS pixel_width,
--   ST_ScaleY(rast) AS pixel_height,
--   ST_UpperLeftX(rast) AS ulx,
--   ST_UpperLeftY(rast) AS uly
-- FROM ch12.b1;

-- --merge 7 bands 
-- CREATE TABLE ch12.landsat AS
-- SELECT
--   b1.rid,
--   ST_AddBand(
--     ST_AddBand(
--       ST_AddBand(
--         ST_AddBand(
--           ST_AddBand(
--             ST_AddBand(
--               b1.rast,              -- Band 1
--               b2.rast               -- Band 2
--             ),
--             b3.rast                 -- Band 3
--           ),
--           b4.rast                   -- Band 4
--         ),
--         b5.rast                     -- Band 5
--       ),
--       b6.rast                       -- Band 6
--     ),
--     b7.rast                         -- Band 7
--   ) AS rast
-- FROM ch12.b1 AS b1
-- JOIN ch12.b2 AS b2 ON b1.rid = b2.rid
-- JOIN ch12.b3 AS b3 ON b1.rid = b3.rid
-- JOIN ch12.b4 AS b4 ON b1.rid = b4.rid
-- JOIN ch12.b5 AS b5 ON b1.rid = b5.rid
-- JOIN ch12.b6 AS b6 ON b1.rid = b6.rid
-- JOIN ch12.b7 AS b7 ON b1.rid = b7.rid;


-- -- band statistics for single band
-- SELECT 
-- 1 AS band,
--   (stats).min,
--   (stats).max,
--   (stats).mean,
--   (stats).stddev
-- FROM (
--   SELECT ST_SummaryStats(rast, 5) AS stats
--   FROM ch12.b5
-- ) AS foo;

-- -- band statistics for multiple band
-- SELECT 
--   1 AS band,
--   (stats).min,
--   (stats).max,
--   (stats).mean,
--   (stats).stddev
-- FROM (
--   SELECT ST_SummaryStats(rast, 5) AS stats
--   FROM ch12.landsat
-- ) AS foo;

-- -- Calculate NDVI
-- CREATE TABLE ch12.ndvi_raster02 AS
-- SELECT 
--   rid,
--   ST_MapAlgebra(
--     rast, 5,  -- NIR band
--     rast, 4,  -- RED band
--     '([rast1.val] - [rast2.val]) / ([rast1.val] + [rast2.val])',
--     '32BF'  -- Output pixel type
--   ) AS rast
-- FROM ch12.landsat;

-- --calculate NDVI, this one use 1.0 to ensure the value as float, but looks like no need
-- CREATE TABLE ch12.ndvi_raster02 AS
-- SELECT 
--   rid,
--   ST_MapAlgebra(
--     rast, 5,  -- NIR band
--     rast, 4,  -- RED band
--     '([rast1.val] - [rast2.val]) / (1.0 * ([rast1.val] + [rast2.val]))',
--     '32BF'  -- Output pixel type
--   ) AS rast
-- FROM ch12.landsat;

-- -- reclassify NDVI
-- CREATE TABLE ch12.NDVI_classified AS
-- SELECT rid,
--   ST_Reclass(
--     rast,
--     1,
--     '[-1.0-0):1, [0-0.3):2, [0.3-1.0):3',
--     '32BF'
--   ) AS classified_rast
-- FROM ch12.ndvi_raster;

-- -- pixel counts
-- SELECT SUM((stats).count) AS water_pixel_count
-- FROM (
--   SELECT ST_ValueCount(classified_rast) AS stats
--   FROM ch12.NDVI_classified
-- ) AS counts
-- WHERE (stats).value = 2 OR (stats).value = 3;

-- -- bare soil index
-- CREATE TABLE ch12.barren_index AS
-- WITH swir_red AS (
--   SELECT rid,
--     ST_MapAlgebra(rast, 6, rast, 4, '[rast1.val] + [rast2.val]', '32BF') AS sum_swir_red
--   FROM ch12.landsat
-- ),
-- nir_blue AS (
--   SELECT rid,
--     ST_MapAlgebra(rast, 5, rast, 2, '[rast1.val] + [rast2.val]', '32BF') AS sum_nir_blue
--   FROM ch12.landsat
-- )
-- SELECT s.rid,
--   ST_MapAlgebra(
--     s.sum_swir_red, 
--     n.sum_nir_blue,
--     '([rast1.val] - [rast2.val]) / (1.0 * ([rast1.val] + [rast2.val]))',
--     '32BF'
--   ) AS rast
-- FROM swir_red s
-- JOIN nir_blue n ON s.rid = n.rid;













