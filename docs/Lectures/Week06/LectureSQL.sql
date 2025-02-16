-- Example 01
CREATE OR REPLACE FUNCTION fn_mid(varchar, integer, integer)
returns varchar
as 
$$
begin
	return substring($1, $2, $3);
end;
$$
language plpgsql;


select fn_mid('software', 5,3)

-- Example 02 -- ALIAS
CREATE OR REPLACE FUNCTION fn_mid(varchar, integer, integer)
returns varchar
as 
$$
declare word ALIAS for $1;
		startPos ALIAS for $2;
		endPoss ALIAS for $3;
begin
	return substring(word, startPos, endPoss);
end;
$$
language plpgsql;

select fn_mid('software', 5,3)

use parameter name and datatype

-- Example 03 -- Parameter name and data type
CREATE OR REPLACE FUNCTION fn_mid(word varchar, startPos integer, endPos integer)
returns varchar
as 
$$
begin
	return substring(word, startPos, endPos);
end;
$$
language plpgsql;

select fn_mid('software', 5,3)

-- Example 04: Inout parameter
parameter type{in*|out|inout|VARIADIC**}  *DEFAULT **variable number of arguments
create or replace function fnSwap(inout num1 int, inout num2 int)
as
$$
begin 
	select num1, num2 into num2, num1;
end;
$$
language plpgsql;

select fnSwap(10,20)

-- Example 05: ARRAY input parameter
CREATE OR REPLACE FUNCTION fnMean(numeric[])
returns numeric
as 
$$
declare total numeric := 0;
		val numeric;
		cnt int := 0;
		n_array ALIAS for $1;
begin
	foreach val in array n_array 
	loop
		total := total + val;
		cnt := cnt +1;
	end loop;

	return total/cnt;
		
end;
$$
language plpgsql;

select fnMean(ARRAY[1,2,3,4,5])

-- Example 06: Table
CREATE OR REPLACE FUNCTION subway_filter(borough_name TEXT)
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
where subway.borough = borough_name;
end;
$$
language plpgsql;

select * from subway_filter('Brooklyn')

-- Example 07: Dynamic SQL for Table (EXECUTE)
CREATE OR REPLACE FUNCTION dynamic_subway_filter(
    schema_name TEXT,   -- Schema name
    table_name TEXT,    -- Table name
    column_name TEXT, -- Column name to filter
    filter_value TEXT -- Value to filter by
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
    -- Construct the dynamic SQL statement
    sql_query := format(
        'SELECT id, name, borough, color FROM %I.%I WHERE %I = %L', 
        schema_name, table_name, column_name, filter_value
    );

    -- Execute the dynamic query and return results
    RETURN QUERY EXECUTE sql_query;
END;
$$
LANGUAGE plpgsql;

select * from dynamic_subway_filter('ch05','subway', 'color', 'BLUE')

-- Example 08: Dynamic SQL for Spatial Relationship
CREATE OR REPLACE FUNCTION dynamic_subway_filter(
    schema_name TEXT,   -- Schema name
    table_name TEXT,    -- Table name

	schema_name02 TEXT,
	table_name02 TEXT, 
	
    column_name TEXT, -- Column name to filter
    subway_color TEXT, -- Value to filter by
	buffer_size NUMERIC
)
RETURNS TABLE (
    id double precision,
    name character varying(200),
	geom geometry(Point,26918))
	
AS 
$$
DECLARE
    sql_query TEXT;  -- Stores the dynamic SQL query
BEGIN
    -- Construct the dynamic SQL statement
    sql_query := format(
        'SELECT street.id, street.name, street.geom
        FROM %I.%I AS street
        JOIN %I.%I AS subway
        ON ST_Intersects(street.geom, ST_Buffer(subway.geom, %L))
        WHERE subway.%I = %L', 
        schema_name, table_name,schema_name02,table_name02,buffer_size, column_name, subway_color
    );

    -- Execute the dynamic query and return results
    RETURN QUERY EXECUTE sql_query;
END;
$$
LANGUAGE plpgsql;

select * from dynamic_subway_filter('ch05','streets', 'ch05', 'subway', 'color', 'GREEN', 100)


