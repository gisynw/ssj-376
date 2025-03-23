-- -- select column names
-- SELECT column_name 
-- FROM information_schema.columns 
-- WHERE table_schema = 'ch10' 
--   AND table_name = 'tmean';

-- -- assign month to tmean
-- ALTER TABLE ch10.tmean ADD COLUMN month smallint;
-- UPDATE ch10.tmean SET month = regexp_replace(filename, E'(.*)([0-9]{2}).tif', E'\\2')::integer; 

-- -- working with band
-- CREATE TABLE ch10.tmean_prec (
-- rid serial primary key,
-- rast raster,
-- filename_tmean text,
-- filename_prec text,
-- month smallint
-- );

-- INSERT INTO ch10.tmean_prec (rast, filename_tmean, filename_prec, month)

-- SELECT
-- ST_AddBand(t.rast, p.rast) As rast,
-- t.filename As filename_tmean, p.filename As filename_prec, t.month
-- FROM ch10.tmean As t INNER JOIN ch10.prec As p

-- ON t.rast ~= p.rast AND t.month = p.month;

-- CREATE INDEX idx_tmean_prec_rast_gist ON ch10.tmean_prec
-- USING gist (ST_ConvexHull(rast));

-- -- -- raster statistics
-- -- SELECT month, ST_Value(rast,1,pt) As temp_c, ST_Value(rast,2,pt) As precip
-- -- FROM
-- -- ch10.tmean_prec
-- -- INNER JOIN ST_SetSRID(ST_Point(-118.31206918723862, 34.088472190148906),4326) AS pt
-- -- ON ( month IN (1,7) AND ST_Intersects(rast,pt) )
-- -- ORDER BY month;

-- -- geometry intersection
SELECT
CAST((gval).val As integer) AS val,
ST_Union((gval).geom) As geom

FROM ( 

SELECT ST_Intersection(ST_Clip(rast,ST_Envelope(buf.geom)), 1,buf.geom ) As gval
FROM ch10.kauai
INNER JOIN (

SELECT ST_Buffer( ST_GeomFromText('POINT(444205 2438785)',26904),100) As geom -- CREATE A BUFFER AREA AROUND A POINT

) As buf
ON ST_Intersects(rast,buf.geom)) As foo
GROUP BY (gval).val
ORDER BY (gval).val;








