-- Task 1. reclassification
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
CREATE TABLE ch12.ndwi AS
SELECT ST_MapAlgebra(b3.rast, b5.rast,
  '([rast1] - [rast2]) / ([rast1] + [rast2])') AS rast
FROM ch12.b3 b3
CROSS JOIN ch12.b5 b5;

-- Task 3. Reclassify NDWI to binary 
DROP ch12.ndwi_water_mask;
CREATE TABLE ch12.ndwi_water_mask AS
SELECT ST_Reclass(rast,1, '-1.0-0.0:1,0.0-1.0:2', '32BF') AS classified_rast
FROM ch12.ndwi;

-- Task 4. Count water pixels
SELECT SUM((stats).count) AS water_pixel_count
FROM (
  SELECT ST_ValueCount(classified_rast) AS stats
  FROM ch12.ndwi_water_mask
) AS counts
WHERE (stats).value = 1;






