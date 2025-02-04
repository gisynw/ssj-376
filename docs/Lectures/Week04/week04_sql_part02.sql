ALTER TABLE ch04.us_attribute RENAME COLUMN AQPKE021 TO Associate;
ALTER TABLE ch04.us_attribute RENAME COLUMN AQPKE022 TO Another;
ALTER TABLE ch04.us_attribute RENAME COLUMN AQPKE023 TO Master;
ALTER TABLE ch04.us_attribute RENAME COLUMN AQPKE024 TO Professional;
ALTER TABLE ch04.us_attribute RENAME COLUMN AQPKE025 TO Doctorate;


--Retrieve the gisjoin, statea, and total_pop columns for records where gisjoin is equal to 'MA'
SELECT gisjoin, statea, total_pop FROM ch04.us_attribute WHERE gisjoin = 'MA';

--Retrieve the gisjoin, statea, and black_pop columns for records where black_pop is less than 10000
SELECT stusab, statea, black_pop FROM ch04.us_attribute WHERE black_pop < 10000;


SELECT gisjoin, statea, total_pop, master FROM ch04.us_attribute WHERE gisjoin = 'MA' AND total_pop > 5000 AND master > 500;

--Retrieve the stusab, statea, and total_pop columns for records which are 10 least populated region

SELECT stusab, statea, total_pop
FROM ch04.us_attribute
ORDER BY total_pop ASC
LIMIT 10;

--Retrieve the top 10 states (stusab) with the highest number of census tracts

SELECT stusab, COUNT(COUNTY) AS county_count 
FROM ch04.us_attribute 
GROUP BY stusab 
ORDER BY county_count DESC
Limit 10;

-- Calculate the proportion of people with both an associate and a master’s degree as a percentage of the total population,  and sort the results in descending order.
SELECT
stusab,statea,
100.0 * (SUM(associate) + SUM(master))/SUM(total_pop) AS master_associate
FROM ch04.us_attribute
GROUP BY statea,stusab
ORDER BY master_associate DESC;

--Calculate the total_pop for stusab WHERE stusab start with letter 'A'
SELECT stusab,  SUM(total_pop) AS TOTAL
FROM ch04.us_attribute 
WHERE stusab LIKE 'A%'
GROUP BY stusab;

--INSERT STATEMENT
insert into ch04.us_attribute(geo_id,stusab, master, professional)
values(1025699,'less_state', 100,200);

SELECT * 
FROM ch04.us_attribute
ORDER BY geo_id ASC
LIMIT 1;

--UPDATE TABLE

UPDATE ch04.us_attribute
SET gisjoin = 'MA_state'
WHERE gisjoin = 'MA';

--SELECT gisjoin
FROM ch04.us_attribute;

-- Add new column
ALTER TABLE ch04.us_attribute
ADD COLUMN Area INTEGER;

-- INSERT VALUE INTO COLUMN
UPDATE ch04.us_attribute
SET Area = 7800
WHERE gisjoin = 'MA_state';

SELECT Area, gisjoin from ch04.us_attribute WHERE gisjoin = 'MA_state';





