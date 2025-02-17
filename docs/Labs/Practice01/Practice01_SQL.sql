-- Lab Task 01

CREATE OR REPLACE FUNCTION fn_right_part(varchar, integer) 
RETURNS varchar 
AS 
$$
BEGIN
    RETURN RIGHT($1, $2);
END;
$$
LANGUAGE plpgsql;

-- Test the function
SELECT fn_right_part('Geographic', 5);

-- Lab Task 02
CREATE OR REPLACE FUNCTION fnLatLonToUTM(INOUT latitude FLOAT, INOUT longitude FLOAT)
AS 
$$
BEGIN
    -- Convert to approximate UTM-like coordinates
    longitude := (longitude + 180) * 5000;  -- Easting (X)
    latitude := (latitude + 90) * 10000;    -- Northing (Y)
END;
$$
LANGUAGE plpgsql;

-- Test the function
SELECT fnLatLonToUTM(40.7128, -74.0060);

-- Lab Task 03
CREATE OR REPLACE FUNCTION subway_filter(borough_name varchar[])
returns table(
	id numeric,
    name character varying(31),
	borough character varying(15)
)
as 
$$
begin
-- table alias is mandatory, or use tablename as alias
return query
select subway.id, 
	   subway.name, 
	   subway.borough
from ch05.subway subway
where subway.borough =  ANY(borough_name);
end;
$$
language plpgsql;

select * from subway_filter(ARRAY['Brooklyn', 'Bronx'])

-- Lab Task 04
CREATE OR REPLACE FUNCTION dynamic_subway_filter(
    schema_name TEXT,   -- Schema name
    table_name TEXT,    -- Table name
    column_name TEXT,   -- Column name to filter
    filter_values TEXT[] -- Array of values to filter by
)
RETURNS TABLE (
    id NUMERIC,
    name character varying(31),
    borough character varying(15),
    color character varying(30) 
) 
AS 
$$
DECLARE
    sql_query TEXT;  -- Stores the dynamic SQL query
BEGIN
    -- Construct the dynamic SQL statement with ANY() for array filtering
    sql_query := format(
        'SELECT id, name, borough, color FROM %I.%I WHERE %I = ANY($1)', 
        schema_name, table_name, column_name
    );

    -- Execute the dynamic query and return results, passing the array as a parameter
    RETURN QUERY EXECUTE sql_query USING filter_values;
END;
$$
LANGUAGE plpgsql;

-- Test the function with multiple filter values
SELECT * FROM dynamic_subway_filter('ch05', 'subway', 'color', ARRAY['BLUE', 'RED']);

-- Lab Task 5
DROP FUNCTION IF EXISTS dynamic_subway_filter(TEXT, TEXT, TEXT, TEXT, TEXT, TEXT);

CREATE OR REPLACE FUNCTION dynamic_subway_filter(
    schema_name TEXT,   -- Schema name
    table_name TEXT,    -- Table name

	schema_name02 TEXT,
	table_name02 TEXT, 
	
    column_name TEXT, -- Column name to filter
    streetName TEXT -- Value to filter by
)
RETURNS TABLE (
    name character varying(64),
	geom geometry(MultiPolygon,26918))
	
AS 
$$
DECLARE
    sql_query TEXT;  -- Stores the dynamic SQL query
BEGIN
    -- Construct the dynamic SQL statement
    sql_query := format(
        'SELECT neighborhood.name, neighborhood.geom
        FROM %I.%I AS street
        JOIN %I.%I AS neighborhood
        ON ST_Intersects(street.geom, neighborhood.geom)
        WHERE street.%I = %L', 
		
        schema_name, table_name,schema_name02,table_name02, column_name, streetName
    );

    -- Execute the dynamic query and return results
    RETURN QUERY EXECUTE sql_query;
END;
$$
LANGUAGE plpgsql;

select * from dynamic_subway_filter('ch05','streets', 'ch05', 'neighborhoods', 'name', '7th Ave')




