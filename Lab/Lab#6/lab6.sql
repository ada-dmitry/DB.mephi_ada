/* Вариант 1 || Работа 6 || Антипенко, Дробышевский */


-- Task 1 -- 
/* a) Напишите запрос, используя конструкцию WITH, выбирающий
рекурсивно сотрудника с идентификатором 1 и все его подчинённых,
как прямых, так и подчинённых более низкого ранга*.
b) Напишите программу на языке PL/SQL, печатающую на экран фамилию
и имя сотрудника с идентификатором 1 и всех его подчинённых, как
прямых, так и подчинённых более низкого ранга. */

CREATE OR REPLACE PROCEDURE department_names() AS $$ 
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
END $$ LANGUAGE plpgsql; 
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

-- Task 3 -- 
/* Напишите программу на языке PL/SQL, удаляющую 10 сотрудников с
самой маленькой заработной платой. При этом их заработная плата должна
добавиться 10 сотрудникам с самой большой заработной платой. Причём
самая маленькая заработная плата должна добавиться к человеку с самой
большой заработной платой. 2-я с конца заработная плата должна добавиться
к человеку со второй по размеру заработной платой и т.д. */

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
    SELECT i AS f1, i2 AS f2, i3 AS f3,i4 AS f4,i5 AS f5 
    FROM generate_series(1,200) i)

SELECT * FROM tmp 
LOOP 
RAISE INFO ' % % % % %',
d_attrs.f1, d_attrs.f2, d_attrs.f3, d_attrs.f4, d_attrs.f5; 
END LOOP;
END $$ LANGUAGE plpgsql; 
call f();
