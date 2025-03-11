-- DATE_TRUNC
-- SELECT date_trunc('minute', TIMESTAMP '2009-07-18 04:30:00-04');

-- -- date_part
-- SELECT DATE_PART('minute', TIMESTAMP '2009-07-18 04:31:00-04');

-- cast CONVERT number into a time interval
-- SELECT CAST(DATE_PART('minute', TIMESTAMP '2009-07-18 04:31:00-04') AS integer);

-- mod
-- SELECT mod(CAST(DATE_PART('minute', TIMESTAMP '2009-07-18 04:30:00-04') AS integer), 15);

-- -- normalize the time
-- SELECT 
--     DATE_TRUNC('minute', time) -
--         CAST(
--             mod(
--                 CAST(DATE_PART('minute', time) AS integer), 15
--             ) || ' minutes' AS interval
--         ) AS track_period
-- FROM ch11.aussie_track_points;

-- SELECT CAST(3 || 'minutes' as interval)

--  -- find min and max, make line
--  SELECT 
--     DATE_TRUNC('minute', time) - 
--         CAST(
--             mod(CAST(DATE_PART('minute', time) AS integer), 15) || ' minutes' AS interval
--         ) AS track_period,
--     MIN(time) AS t_start, 
--     MAX(time) AS t_end,

-- FROM ch11.aussie_track_points
-- GROUP BY track_period;

--  -- make line
--  SELECT 
--     DATE_TRUNC('minute', time) - 
--         CAST(
--             mod(CAST(DATE_PART('minute', time) AS integer), 15) || ' minutes' AS interval
--         ) AS track_period,
--     MIN(time) AS t_start, 
--     MAX(time) AS t_end,
-- 	ST_MakeLine(geom ORDER BY time) AS geom
-- FROM ch11.aussie_track_points
-- GROUP BY track_period;

-- --save results/ CREATE NEW DATA TO STORE THE DATA
-- SELECT 
--     DATE_TRUNC('minute',time) - -- <1>
--         CAST(
--             mod(
--                 CAST(DATE_PART('minute',time) AS integer),15
--             ) ||' minutes' AS interval
--         ) AS track_period, -- <1>
--     MIN(time) AS t_start, 
--     MAX(time) AS t_end, 
--     ST_MakeLine(geom ORDER BY time) AS geom  
-- --
-- INTO ch11.aussie_run
-- FROM ch11.aussie_track_points
-- --
-- GROUP BY track_period 


-- -- ANALYZE THE RESULT
-- SELECT 
--     CAST(track_period AS timestamp),
--     CAST(t_start AS timestamp) AS t_start,    
--     CAST(t_end AS timestamp) AS t_end, 
--     ST_NPoints(geom) AS np, 
--     CAST(ST_Length(geom::geography) AS integer) AS dist_m, 
--     (t_end - t_start) AS dur               
-- FROM ch11.aussie_run;

