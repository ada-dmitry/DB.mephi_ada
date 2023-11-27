/* Вариант 1 || Работа 6 || Антипенко, Дробышевский */


-- Task 1 -- 
/* a) Напишите запрос, используя конструкцию WITH, выбирающий
рекурсивно сотрудника с идентификатором 1 и все его подчинённых,
как прямых, так и подчинённых более низкого ранга*.
b) Напишите программу на языке PL/SQL, печатающую на экран фамилию
и имя сотрудника с идентификатором 1 и всех его подчинённых, как
прямых, так и подчинённых более низкого ранга. */

CREATE OR REPLACE PROCEDURE department_names() AS 
DECLARE d_attrs RECORD; 
BEGIN

FOR d_attrs IN WITH RECURSIVE tmp AS ( 
    SELECT id, first_name, last_name, manager_id, 1 AS level 
    FROM bd6_employees 
    WHERE manager_id = 1 or id = 1 
    UNION ALL 
    SELECT e.id, e.first_name, e.last_name, e.manager_id, t.level + 1 
    FROM bd6_employees e JOIN tmp t ON e.manager_id = t.id ) 

SELECT * FROM tmp 
LOOP 
    RAISE INFO ' % % ', d_attrs.first_name, d_attrs.last_name; 
END LOOP; 
END  LANGUAGE plpgsql; 
CALL department_names();


-- Task 2 --
/* Напишите программу на языке PL/SQL, выбирающую строки из таблицы
employees в порядке возрастания заработной платы (salary) и печатающие на
экран следующие данные: фамилия, имя, модифицированная заработная
плата. Модифицированная заработная плата получается следующим
образом: у первого по порядку сотрудника она округляется до сотен в
меньшую сторону, а у всех последующих сотрудников она сначала
увеличивается на остаток от округления, полученный от предыдущего
сотрудника, а затем округляется до сотен в меньшую сторону. */ 

CREATE OR REPLACE PROCEDURE print_employees() RETURNS VOID AS $$
DECLARE
current_salary INTEGER;
m_salary INTEGER;
mod_salary INTEGER := 0;
employee_rec RECORD;
BEGIN
FOR employee_rec IN (
   SELECT last_name, first_name, salary_in_euro 
   FROM bd6_employees 
   ORDER BY salary_in_euro) 
LOOP
   current_salary := employee_rec.salary_in_euro;

   IF mod_salary=0 THEN
      m_salary := (current_salary / 100) * 100;
   ELSE
      m_salary := ((current_salary + mod_salary) / 100) * 100;
END IF;

RAISE NOTICE 'Employee: % %, Modified Salary: %', employee_rec.last_name, employee_rec.first_name, m_salary;
mod_salary := current_salary - m_salary;
END LOOP;
END $$ LANGUAGE plpgsql;

SELECT print_employees();

-- Task 3 -- 
/* Напишите программу на языке PL/SQL, удаляющую 10 сотрудников с
самой маленькой заработной платой. При этом их заработная плата должна
добавиться 10 сотрудникам с самой большой заработной платой. Причём
самая маленькая заработная плата должна добавиться к человеку с самой
большой заработной платой. 2-я с конца заработная плата должна добавиться
к человеку со второй по размеру заработной платой и т.д. */

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

-- Task 4 --
/* Создайте таблицу spiral с 5 полями f1, f2, f3, f4, f5 – целые числа.
Напишите программу на языке PL/SQL, заполняющую данную таблицу 1000
строк по следующему принципу:
1 2 3 4 5
10 9 8 7 6
11 12 13 14 15
20 19 18 17 16
21 22 23 24 25 */

CREATE OR REPLACE PROCEDURE f() AS $$ 
DECLARE d_attrs RECORD; 
BEGIN

FOR d_attrs IN WITH RECURSIVE tmp AS ( 
    SELECT 1+i5 AS f1, 2+i5 AS f2, 3+i5 AS f3, 4+i5 AS f4,5+i*5 AS f5 
    FROM generate_series(0,199) i)

SELECT * FROM tmp 
LOOP 
case 
when ( mod(d_attrs.f1,2)!=0) 
then RAISE INFO ' % % % % %', d_attrs.f1, d_attrs.f2, d_attrs.f3, d_attrs.f4, d_attrs.f5; 
when ( mod(d_attrs.f1,2)=0) 
then RAISE INFO ' % % % % %', d_attrs.f5, d_attrs.f4, d_attrs.f3, d_attrs.f2, d_attrs.f1; 
end case; 
END LOOP; 
END $$ LANGUAGE plpgsql; 
call f();