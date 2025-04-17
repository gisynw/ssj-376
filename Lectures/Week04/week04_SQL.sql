-- CREATE TABLE ch04.us_attribute (
--     GEO_ID VARCHAR(20) PRIMARY KEY, -- Census Geographic Area Identifier (Primary Key)
--     GISJOIN VARCHAR(20), -- GIS Join Match Code
--     STUSAB VARCHAR(20), -- State Abbreviation
--     STATE VARCHAR(50), -- State Name
--     STATEA VARCHAR(50), -- State Code
--     COUNTY VARCHAR(50), -- County Name
--     COUNTYA INTEGER, -- County Code
--     TRACTA VARCHAR(20), -- Census Tract Code
--     TL_GEO_ID VARCHAR(20), -- TIGER/Line Shapefile Geographic Area Identifier
--     NAME_E VARCHAR(255), -- Full Geographic Area Name (Estimates)

--     -- Population Data
--     AQNFE001 INTEGER, -- Total Population
--     AQNGE002 INTEGER, -- White Population
--     AQNGE003 INTEGER, -- Black or African American Population
--     AQNGE004 INTEGER, -- American Indian/Alaska Native Population
--     AQNGE005 INTEGER, -- Asian Population
--     AQNGE006 INTEGER, -- Native Hawaiian/Other Pacific Islander Population
--     AQNGE007 INTEGER, -- Another Race Category

--     -- Education Data
--     AQPKE017 INTEGER, -- Some Education Field
--     AQPKE021 INTEGER, -- Associate’s Degree
--     AQPKE022 INTEGER, -- Another Degree Field
--     AQPKE023 INTEGER, -- Master’s Degree
--     AQPKE024 INTEGER, -- Professional School Degree
--     AQPKE025 INTEGER  -- Doctorate Degree
-- );

-- -- Rename columns

-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNFE001 TO total_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE002 TO white_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE003 TO black_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE004 TO native_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE005 TO asian_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE006 TO pacific_pop;
-- ALTER TABLE ch04.us_attribute RENAME COLUMN AQNGE007 TO other_race;


-- -- Filtering data with where

SELECT DISTINCT *  FROM ch04.us_attribute;

-- SELECT stusab, statea, total_pop FROM ch04.us_attribute WHERE stusab = 'New Jersey';

-- SELECT stusab, statea, total_pop FROM ch04.us_attribute WHERE total_pop > 10000;

-- SELECT stusab, statea, total_pop FROM ch04.us_attribute WHERE stusab = 'California' AND total_pop > 10000;

-- -- Order data with ORDER BY
-- SELECT stusab, statea, total_pop
-- FROM ch04.us_attribute 
-- ORDER BY total_pop DESC 
-- LIMIT 10;

-- -- Group data by group by
-- SELECT stusab, COUNT(COUNTY) AS county_count 
-- FROM ch04.us_attribute 
-- GROUP BY stusab 
-- ORDER BY county_count DESC;

-- -- Calculation the total population by state (SUM)
-- SELECT stusab, SUM(total_pop ) AS total_population
-- FROM ch04.us_attribute
-- GROUP BY stusab
-- ORDER BY total_population DESC;

-- -- Find the average population of counties
-- SELECT stusab, AVG(total_pop) AS avg_population 
-- FROM ch04.us_attribute 
-- GROUP BY stusab 
-- ORDER BY avg_population DESC;

-- -- Pattern matching using LIKE
-- SELECT stusab, statea 
-- FROM ch04.us_attribute 
-- WHERE stusab LIKE 'Mass%';

-- -- in and between
-- SELECT stusab, statea, total_pop 
-- FROM ch04.us_attribute 
-- WHERE stusab IN ('Texas', 'California', 'Florida');

-- -- percentage
SELECT
  stusab,statea,
  100.0 * Sum(white_pop)/Sum(total_pop) AS white_pct
FROM ch04.us_attribute
GROUP BY statea,stusab
ORDER BY white_pct DESC;












