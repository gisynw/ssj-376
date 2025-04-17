-- -- meta inforamtion
-- SELECT
--   rid,
--   ST_SRID(rast) AS srid,
--   ST_Width(rast) AS width,
--   ST_Height(rast) AS height,
--   ST_NumBands(rast) AS num_bands,
--   ST_ScaleX(rast) AS pixel_x,
--   ST_ScaleY(rast) AS pixel_y,
--   ST_UpperLeftX(rast) AS start_x,
--   ST_UpperLeftY(rast) AS start_y
-- FROM ch12.b1;

-- -- merge three bands
-- CREATE TABLE ch12.threebands AS
-- SELECT
-- b1.rid, 
-- ST_AddBand(ST_AddBand(b1.rast, b2.rast),
-- 			b3.rast)		
-- AS rast
-- FROM ch12.b1 AS b1
-- JOIN ch12.b2 AS b2 ON b1.rid = b2.rid
-- JOIN ch12.b3 AS b3 ON b1.rid = b3.rid;

-- -- merge four bands
-- CREATE TABLE ch12.fourbands AS
-- SELECT
-- b1.rid, 
-- ST_AddBand(ST_AddBand(ST_AddBand(b1.rast, b2.rast),
-- 			b3.rast), b4.rast)		
-- AS rast
-- FROM ch12.b1 AS b1
-- JOIN ch12.b2 AS b2 ON b1.rid = b2.rid
-- JOIN ch12.b3 AS b3 ON b1.rid = b3.rid
-- JOIN ch12.b4 AS b4 ON b1.rid = b4.rid;

-- -- landsat with 7 bands
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

-- band statistics
SELECT 
5 AS band,
(stats).min,
(stats).max,
(stats).mean,
(stats).stddev
FROM (
  SELECT ST_SummaryStats(rast, 5) AS stats
  FROM ch12.landsat

  
) AS foo;










