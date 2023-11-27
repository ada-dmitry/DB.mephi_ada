CREATE OR REPLACE PROCEDURE update_salary() AS $$
DECLARE
   emp_record bd6_employees%ROWTYPE;
   counter integer := 0;
   min_salary bd6_employees.salary_in_euro%TYPE;
   max_salary bd6_employees.salary_in_euro%TYPE;
BEGIN
   SELECT MIN(salary_in_euro), MAX(salary_in_euro) INTO min_salary, max_salary FROM bd6_employees;
   
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