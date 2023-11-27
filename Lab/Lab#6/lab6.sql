WITH RECURSIVE tmp AS (
  SELECT id, first_name, last_name, manager_id, 1 AS level
  FROM bd6_employees
  WHERE manager_id = 1 OR id = 1
  UNION ALL
  SELECT e.id, e.first_name, e.last_name, e.manager_id, t.level + 1
  FROM bd6_employees e
  JOIN tmp t ON e.manager_id = t.id
)
SELECT *
FROM tmp;

CREATE OR REPLACE PROCEDURE department_names() AS $$ 
DECLARE d_attrs RECORD; 
BEGIN

FOR d_attrs IN 
WITH RECURSIVE tmp AS ( 
	SELECT 
	 	id, 
	 	first_name, 
	 	last_name, manager_id, 
	 	1 AS level 
	 FROM bd6_employees 
	 WHERE manager_id = 1 or id = 1 
	UNION ALL 
	SELECT 
		e.id, 
		e.first_name, 
		e.last_name, 
		e.manager_id, 
		t.level + 1 
	FROM bd6_employees e 
	JOIN tmp t ON e.manager_id = t.id )
	SELECT * FROM tmp LOOP RAISE INFO ' % % ',

d_attrs.first_name, d_attrs.last_name; 
END LOOP; 
END $$ LANGUAGE plpgsql; 
CALL department_names();

DECLARE
    prev_employee NUMBER := 0;
    mod_salary NUMBER;
BEGIN
    FOR tmp IN (
        SELECT first_name, last_name, salary,
               ROW_NUMBER() OVER (ORDER BY salary) AS salary_rank
        FROM employees
    )
    LOOP
        IF emp.salary_rank = 1 THEN
            modified_salary := FLOOR(emp.salary / 100) * 100; -- округляем до сотен в меньшую сторону
        ELSE
            modified_salary := FLOOR((emp.salary + previous_remainder) / 100) * 100;
            previous_remainder := (emp.salary + previous_remainder) - modified_salary;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Фамилия: ' || emp.last_name || ', Имя: ' || emp.first_name || ', Модифицированная заработная плата: ' || modified_salary);
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE f() AS $$ 
DECLARE d_attrs RECORD; 
BEGIN

FOR d_attrs IN 
    WITH RECURSIVE tmp AS ( 
        SELECT i AS f1, i2 AS f2, i3 AS f3,i4 AS f4,i5 AS f5 
        FROM generate_series(1,200) i)

SELECT * FROM tmp LOOP RAISE INFO ' % % % % %',

d_attrs.f1, d_attrs.f2, d_attrs.f3, d_attrs.f4, d_attrs.f5; END LOOP; 
END $$ LANGUAGE plpgsql; 
CALL f();

WITH RECURSIVE tmp AS (
  SELECT id, first_name, last_name, manager_id, 1 AS level
  FROM bd6_employees
  WHERE manager_id = 1 OR id = 1
  UNION ALL
  SELECT e.id, e.first_name, e.last_name, e.manager_id, t.level + 1
  FROM bd6_employees e
  JOIN tmp t ON e.manager_id = t.id
)
SELECT *
FROM tmp;

CREATE OR REPLACE PROCEDURE department_names() AS $$ 
DECLARE d_attrs RECORD; 
BEGIN

FOR d_attrs IN 
WITH RECURSIVE tmp AS ( 
	SELECT 
	 	id, 
	 	first_name, 
	 	last_name, manager_id, 
	 	1 AS level 
	 FROM bd6_employees 
	 WHERE manager_id = 1 or id = 1 
	UNION ALL 
	SELECT 
		e.id, 
		e.first_name, 
		e.last_name, 
		e.manager_id, 
		t.level + 1 
	FROM bd6_employees e 
	JOIN tmp t ON e.manager_id = t.id )
	SELECT * FROM tmp LOOP RAISE INFO ' % % ',

d_attrs.first_name, d_attrs.last_name; 
END LOOP; 
END $$ LANGUAGE plpgsql; 
CALL department_names();

CREATE OR REPLACE PROCEDURE modified_salary() AS $$ 
DECLARE
    prev_employee numeric := 0;
    mod_salary numeric := (
	SELECT FLOOR(min(salary_in_euro) / 100) * 100
	FROM bd6_employees
		);
	d_attrs RECORD;
BEGIN
    FOR d_attrs IN  WITH tmp AS (
        SELECT first_name, last_name, salary_in_euro
        FROM bd6_employees
		ORDER BY salary_in_euro ASC
    )
	SELECT * FROM tmp
	RAISE INFO ' % % % ',
		d_attrs.last_name,
		d_attrs.first_name,
		mod_salary;
    LOOP
		mod_salary := FLOOR((d_attrs.salary_in_euro + prev_employee) / 100) * 100;
        prev_employee := (d_attrs.salary_in_euro + prev_employee) - mod_salary;
		RAISE INFO ' % % % ',
		d_attrs.last_name,
		d_attrs.first_name,
		mod_salary;
    END LOOP;
END $$ LANGUAGE plpgsql;
CALL modified_salary();
