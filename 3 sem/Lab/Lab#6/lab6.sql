CREATE OR REPLACE PROCEDURE update_salary() AS $$
DECLARE
   emp_record bd6_employees%ROWTYPE;
   counter integer := 0;
   min_salary bd6_employees.salary_in_euro%TYPE;
   max_salary bd6_employees.salary_in_euro%TYPE;
BEGIN
  -- SELECT MIN(salary_in_euro), MAX(salary_in_euro) INTO min_salary, max_salary FROM bd6_employees;
   
   FOR emp_record IN
   SELECT * FROM (SELECT * FROM bd6_employees ORDER BY salary_in_euro LIMIT 3) AS min_salaries
   LOOP
      DELETE FROM bd6_employees WHERE id = emp_record.id;
      counter := counter + 1;
   END LOOP;
   FOR emp_record IN
   SELECT * FROM (SELECT * FROM bd6_employees ORDER BY salary_in_euro DESC LIMIT 3) AS max_salaries
   LOOP
      UPDATE bd6_employees SET salary_in_euro = salary_in_euro + min_salary WHERE id = emp_record.id;
      counter := counter + 1;
   END LOOP;
   
   RAISE NOTICE 'Successfully updated % bd6_employees.', counter;
END $$ LANGUAGE plpgsql;
CALL update_salary();

CREATE OR REPLACE PROCEDURE update_and_delete_salaries() AS $$
BEGIN
    -- Увеличение заработной платы
    WITH lowest_salaries AS (
        SELECT id, salary_in_euro
        FROM bd6_employees
        ORDER BY salary_in_euro
        LIMIT 10
    ), highest_salary AS (
        SELECT max(salary_in_euro) AS max_salary 
        FROM bd6_employees
    )
    UPDATE bd6_employees e
    SET salary_in_euro = e.salary_in_euro + ls.salary_in_euro - (SELECT max_salary FROM highest_salary)
    FROM lowest_salaries ls
    WHERE e.id = ls.id;

    -- Удаление сотрудников
    DELETE FROM bd6_employees WHERE id IN (SELECT id FROM lowest_salaries);

    RAISE NOTICE 'Salaries updated and lowest paid bd6_employees deleted.';
END;
$$ LANGUAGE plpgsql;
