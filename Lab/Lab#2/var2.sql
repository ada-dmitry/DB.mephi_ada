/* Лабораторная работа #2 || Вариант 2 || Антипенко, Дробышевский */

/* Задание 1 */
SELECT 
    (first_name || ' ' || last_name) AS "ФИО",
    to_char(salary, '9999999D99') AS "ОКЛАД",
    trunc(salary*0.87) AS "Оклад минус подоходный"
FROM employees;

/* Задание 2 */
SELECT 
    first_name AS "Имя",
    last_name AS "Фамилия",
    job_id AS "Должность", 
    to_char(hire_date, 'DD.MM.YYYY') AS "Дата приема на работу"
FROM employees
WHERE job_id IN ('AD_PRES', 'AD_VP', 'AD_ASST')
OR hire_date BETWEEN
'1995-01-01' AND '2023-01-01'
LIMIT 5;

/* Задание 3 */
SELECT 
	first_name AS "Имя",
	last_name AS "Фамилия",
	to_char(salary, '99999D99') AS "Оклад", 
	to_char(hire_date, 'DD.MM.YYYY') AS "Дата приема на работу",
	
	EXTRACT(month from age(now(), hire_date)) 
	+ EXTRACT(year from age(now(), hire_date))*12
	as "Проработано месяцев"

FROM employees;

/* Задание 4 */
SELECT 
	job_id AS "Должность",
	trunc(MAX(salary)) AS "Максимальная зарплата",
	trunc(MIN(salary)) AS "Минимальная зарплата",
	trunc(AVG(salary), 2) AS "Средняя зарплата" 

FROM employees 
GROUP BY job_id;