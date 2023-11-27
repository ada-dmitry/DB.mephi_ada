CREATE OR REPLACE FUNCTION rearrange_salaries() RETURNS VOID AS $$
DECLARE
    salaries RECORD;
	small NUMERIC[];
	larg NUMERIC[];
	const CONSTANT INTEGER = 10;
BEGIN
    FOR salaries IN 
        SELECT id, salary_in_euro
        FROM bd6_employees 
        ORDER BY salary_in_euro 
        LIMIT const
	LOOP
		small = array_append(small, (SELECT salary_in_euro FROM bd6_employees WHERE id = salaries.id));
    	DELETE FROM bd6_employees
    	WHERE id = salaries.id;
	END LOOP;

    FOR salaries IN 
        SELECT id, salary_in_euro
        FROM bd6_employees 
        ORDER BY salary_in_euro DESC 
        LIMIT const
	LOOP
		larg = array_append(larg, (SELECT id FROM bd6_employees WHERE id = salaries.id));
	END LOOP;
	
	FOR i IN 1..const
	LOOP
        UPDATE bd6_employees
        SET salary_in_euro = salary_in_euro + small[i]
        WHERE id = larg[i];
    END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT rearrange_salaries();