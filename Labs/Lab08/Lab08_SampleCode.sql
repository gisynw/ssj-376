-- In-class practice 1:
SELECT 
  (stats_b4).* AS b4,
  (stats_b5).* AS b5
FROM (
  SELECT
    ST_SummaryStats(rast, 4) AS stats_b4,
	ST_SummaryStats(rast, 5) AS stats_b5
  FROM ch12.landsat
) AS subquery;

-- In-class practice 2:
CREATE TABLE ch12.ndvi_raster_union AS
SELECT
  ST_Union(rast) AS rast
FROM ch12.ndvi_raster;

-- Task 1. reclassification
DROP TABLE IF EXISTS ch12.barren_classified;
CREATE TABLE ch12.barren_classified AS
SELECT rid,
  ST_Reclass(
    rast,
    1,
    '-1.0-0.1:1, 0.1-0.3:2, 0.3-1.0:3',
    '32BF'
  ) AS classified_rast
FROM ch12.barren_index;

-- Task 2. NDWI index
DROP TABLE IF EXISTS ch12.ndwi;
CREATE TABLE ch12.ndwi AS
SELECT 
rid,
ST_MapAlgebra(rast, 5, rast, 3,
  '([rast1] - [rast2]) / ([rast1] + [rast2])') AS rast
FROM ch12.landsat;

-- Task 3. Reclassify NDWI to binary 
DROP TABLE IF EXISTS ch12.ndwi_water_mask;
CREATE TABLE ch12.ndwi_water_mask AS
SELECT rid,
  ST_Reclass(rast, 1, '-1.0-0.0:1, 0.0-1.0:2', '32BF') AS classified_rast
FROM ch12.ndwi;


-- Task 4. Count water pixels
SELECT SUM((stats).count) AS water_pixel_count
FROM (
  SELECT ST_ValueCount(classified_rast) AS stats
  FROM ch12.ndwi_water_mask
) AS counts
WHERE (stats).value = 2;

-- Task 5. Combine indices into one raster file
CREATE TABLE ch12.landsat_indices AS
SELECT ndvi.rid,
	ST_AddBand(
		ST_AddBand(
	ndvi.rast, bi.rast
		), ndwi.rast) AS rast
FROM ch12.ndvi_raster AS ndvi
JOIN ch12.barren_index AS bi ON ndvi.rid = bi.rid AND ndvi.rast ~= bi.rast
JOIN ch12.ndwi AS ndwi ON ndvi.rid = ndwi.rid AND ndvi.rast ~= ndwi.rast;


-- Task 6. ST_SummaryStats()
SELECT 
  (stats_ndvi).min AS ndvi_min,
  (stats_ndvi).max AS ndvi_max,
  (stats_ndvi).mean AS ndvi_mean,
  (stats_ndvi).stddev AS ndvi_sd,
  (stats_ndwi).min AS ndwi_min,
  (stats_ndwi).max ndwi_max,
  (stats_ndwi).mean AS ndwi_mean,
  (stats_ndwi).stddev AS ndwi_sd
FROM (
  SELECT
    ST_SummaryStats(rast, 1) AS stats_ndvi,
	ST_SummaryStats(rast, 3) AS stats_ndwi
  FROM ch12.landsat_indices
) AS subquery;

-- Task 7. ST_Union to unit all tiles and do statistical summary
DROP TABLE IF EXISTS ch12.landsat_indices_union;
CREATE TABLE ch12.landsat_indices_union AS
SELECT
  ST_Union(rast) AS rast
FROM ch12.landsat_indices;

SELECT 
  (stats_ndvi).min AS ndvi_min,
  (stats_ndvi).max AS ndvi_max,
  (stats_ndvi).mean AS ndvi_mean,
  (stats_ndvi).stddev AS ndvi_sd,
  (stats_ndwi).min AS ndwi_min,
  (stats_ndwi).max ndwi_max,
  (stats_ndwi).mean AS ndwi_mean,
  (stats_ndwi).stddev AS ndwi_sd
FROM (
  SELECT
    ST_SummaryStats(rast, 1) AS stats_ndvi,
	ST_SummaryStats(rast, 3) AS stats_ndwi
  FROM ch12.landsat_indices_union
) AS subquery;



