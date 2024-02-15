/* Лабораторная работа #2 || Вариант 1 || Гаранян, Епифанов */

SELECT 
	((30*20)/10)+(20*10) AS "X";

SELECT * 
FROM locations 
WHERE postal_code IS NOT NULL;


SELECT first_name AS "Имя", last_name AS "Фамилия",
	   left(upper(first_name), 3) || left(upper(last_name), 2) AS "Идентификатор"
FROM employees;


SELECT  
	job_id AS "Должность", max(salary) AS "Максимальная зарплата",
	min(salary) AS "Минимальная зарплата", 
	to_char(avg(salary), '99999.00') AS "Средняя зарплата"
FROM employees
GROUP BY job_id;