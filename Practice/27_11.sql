-- Task 1 --

CREATE OR REPLACE PROCEDURE molodec() AS $$
DECLARE 
    name1 varchar := 'Julia';
    name2 varchar := 'Пустотааа';
BEGIN
    RAISE INFO ' %, %, вы молодцы! ', name1, name2;

END $$ LANGUAGE plpgsql; 
CALL molodec();

-- Task 2 -- 

CREATE OR REPLACE PROCEDURE fiiiizika() AS $$
DECLARE
    velocity_kmh NUMERIC := 60; 
    time_seconds NUMERIC := 30; 
    velocity_ms NUMERIC;
    distance_m NUMERIC; 
    train_length_m NUMERIC; 
BEGIN

    velocity_ms := velocity_kmh * 1000 / 3600;

    distance_m := velocity_ms * time_seconds;
    train_length_m := distance_m;

    RAISE INFO ' % ', TRUNC(train_length_m);
END;
$$ LANGUAGE plpgsql;
CALL fiiiizika();



-- Task 3 -- 

CREATE OR REPLACE PROCEDURE show_city_streets() AS $$
DECLARE
    city_record RECORD;
BEGIN
    FOR city_record IN SELECT city, street_address FROM locations
	LOOP
        RAISE NOTICE 'В городе % есть улица %',
		city_record.city, city_record.street_address;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL show_city_streets();


-- Task 4 --

CREATE OR REPLACE PROCEDURE factorial(n INTEGER) AS $$
DECLARE
    result INTEGER := 1;
    i INTEGER := 1;
BEGIN
    WHILE i <= n LOOP
        result := result * i;
        i := i + 1;
    END LOOP;
    RAISE INFO ' % ', result;
END;
$$ LANGUAGE plpgsql;

CALL factorial(10);

-- Task 5 -- 

CREATE OR REPLACE FUNCTION get_employees_and_managers_names() 
RETURNS TABLE (employee_name TEXT, manager_name TEXT) AS $$ 
BEGIN 
    RETURN QUERY  
    SELECT e.first_name || ' ' || e.last_name AS employee_name,  
           COALESCE(m.first_name || ' ' || m.last_name, 'No manager') AS manager_name 
    FROM employees e 
    LEFT JOIN employees m ON e.manager_id = m.employee_id; 
END; 
$$ LANGUAGE plpgsql;

SELECT get_employees_and_managers_names();

-- Task 6 -- 

CREATE OR REPLACE FUNCTION binary_to_decimal(binary_num VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    decimal_num NUMERIC := 0;
    power NUMERIC := 0;
    bit NUMERIC;
BEGIN
    FOR i IN REVERSE 1..LENGTH(binary_num) LOOP
        bit := CAST(SUBSTRING(binary_num FROM i FOR 1) AS NUMERIC);
        decimal_num := decimal_num + (bit * (2 ^ power));
        power := power + 1;
    END LOOP;
    RETURN decimal_num;
END;
$$ LANGUAGE plpgsql;

SELECT binary_to_decimal('101');

