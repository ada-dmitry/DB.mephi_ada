/* Вариант 1 || Работа 6 || Антипенко, Дробышевский */


-- Task 1 -- 
/* a) Напишите запрос, используя конструкцию WITH, выбирающий
рекурсивно сотрудника с идентификатором 1 и все его подчинённых,
как прямых, так и подчинённых более низкого ранга*.
b) Напишите программу на языке PL/SQL, печатающую на экран фамилию
и имя сотрудника с идентификатором 1 и всех его подчинённых, как
прямых, так и подчинённых более низкого ранга. */

-- CREATE OR REPLACE PROCEDURE department_names() AS $$
-- DECLARE d_attrs RECORD; 
-- BEGIN

-- FOR d_attrs IN WITH RECURSIVE tmp AS ( 
--     SELECT id, first_name, last_name, manager_id, 1 AS level 
--     FROM bd6_employees 
--     WHERE manager_id = 1 or id = 1 
--     UNION ALL 
--     SELECT e.id, e.first_name, e.last_name, e.manager_id, t.level + 1 
--     FROM bd6_employees e JOIN tmp t ON e.manager_id = t.id ) 

-- SELECT * FROM tmp 
-- LOOP 
--     RAISE INFO ' % % ', d_attrs.first_name, d_attrs.last_name; 
-- END LOOP; 
-- END $$ LANGUAGE plpgsql; 
-- CALL department_names();

-- Пункт а)
WITH RECURSIVE tmp AS (
SELECT id, first_name, last_name, manager_id, 1 AS level
FROM bd6_employees
WHERE manager_id = 1 or id = 1
UNION ALL
SELECT e.id, e.first_name, e.last_name, e.manager_id, t.level + 1
FROM bd6_employees e JOIN tmp t ON e.manager_id = t.id )

SELECT * FROM tmp

-- Пункт б)
CREATE OR REPLACE PROCEDURE department_names(integer) AS $$
DECLARE 
	d_attrs RECORD;
	i integer;
	l integer;
BEGIN
FOR d_attrs IN 
	(
	SELECT id,last_name, first_name, manager_id
	FROM bd6_employees 
	ORDER BY manager_id
	)   
	LOOP
	IF d_attrs.manager_id=$1 THEN
	 	RAISE INFO ' % % % % ', d_attrs.first_name, d_attrs.last_name, d_attrs.id, d_attrs.manager_id;   
		l:= d_attrs.id;
    	CALL department_names(l); 
	END IF;
	END LOOP; 
END $$ LANGUAGE plpgsql; 


CREATE OR REPLACE PROCEDURE department_names2(integer) AS $$
DECLARE
	d_attrs RECORD;
	BEGIN
	FOR d_attrs IN 
	(
	SELECT 
		id,
		last_name, 
		first_name, 
		manager_id   
	FROM bd6_employees 
	ORDER BY manager_id
	)
      
	LOOP   
	IF d_attrs.id=$1 THEN   
	RAISE INFO ' % % % % ', d_attrs.first_name, d_attrs.last_name, d_attrs.id, d_attrs.manager_id;
    END IF;
	END LOOP; 
CALL department_names($1);
END $$ LANGUAGE plpgsql; 
CALL department_names2(4);  


-- Task 2 --
/* Напишите программу на языке PL/SQL, выбирающую строки из таблицы
employees в порядке возрастания заработной платы (salary) и печатающие на
экран следующие данные: фамилия, имя, модифицированная заработная
плата. Модифицированная заработная плата получается следующим
образом: у первого по порядку сотрудника она округляется до сотен в
меньшую сторону, а у всех последующих сотрудников она сначала
увеличивается на остаток от округления, полученный от предыдущего
сотрудника, а затем округляется до сотен в меньшую сторону. */ 

CREATE OR REPLACE PROCEDURE print_employees() AS $$
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

RAISE NOTICE 'Employee: % % || Modified Salary: %', employee_rec.last_name, employee_rec.first_name, m_salary;
END LOOP;
END $$ LANGUAGE plpgsql;

CALL print_employees();
CREATE OR REPLACE PROCEDURE print_employees() AS $$
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

CALL print_employees();

-- Task 3 -- 
/* Напишите программу на языке PL/SQL, удаляющую 10 сотрудников с
самой маленькой заработной платой. При этом их заработная плата должна
добавиться 10 сотрудникам с самой большой заработной платой. Причём
самая маленькая заработная плата должна добавиться к человеку с самой
большой заработной платой. 2-я с конца заработная плата должна добавиться
к человеку со второй по размеру заработной платой и т.д. */

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
    SELECT 1+i*5 AS f1, 2+i*5 AS f2, 3+i*5 AS f3, 4+i*5 AS f4,5+i*5 AS f5 
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

-- Task 7 from lab4 -- 






CREATE OR REPLACE PROCEDURE department_names(integer) AS $$DECLARE d_attrs RECORD;
i integer;l integer;
BEGIN
FOR d_attrs IN (   SELECT id,last_name, first_name, manager_id
   FROM bd6_employees order by manager_id )   
   LOOP
      if d_attrs.manager_id=$1 then
    RAISE INFO ' % % % % ', d_attrs.first_name, d_attrs.last_name, d_attrs.id, d_attrs.manager_id;    l:= d_attrs.id;
    call department_names(l);    end if;
END LOOP; 
END $$ LANGUAGE plpgsql; 


CREATE OR REPLACE PROCEDURE department_names2(integer) AS $$
DECLARE d_attrs RECORD;
BEGINFOR d_attrs IN (
   SELECT id,last_name, first_name, manager_id   FROM bd6_employees order by manager_id )
      
LOOP   
   if d_attrs.id=$1 then    RAISE INFO ' % % % % ', d_attrs.first_name, d_attrs.last_name, d_attrs.id, d_attrs.manager_id;
    end if;END LOOP; 
CALL department_names($1);END $$ LANGUAGE plpgsql; 
CALL department_names2(4);