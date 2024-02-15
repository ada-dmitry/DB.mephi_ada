/* Лабораторная работа №3 | Вариант 4 | Антипенко, Дробышевский */

SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM jobs;

/* Задание 1 */
SELECT 
	e.first_name AS "FIRST_NAME",
	e.last_name AS "LAST_NAME", 
	d.department_name AS "DEPARTMENT_NAME"
FROM employees e, departments d
WHERE e.department_id = d.department_id AND d.department_name IN ('IT', 'Sales');

/* Задание 2 */
SELECT 
	e.first_name AS "FIRST_NAME",
	e.last_name AS "LAST_NAME", 
	trunc(e.salary) AS "SALARY",
	d.department_name AS "DEPARTMENT_NAME",
	j.job_title AS "JOB_TITLE"
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id AND e.job_id = j.job_id
AND e.salary > 10000
ORDER BY e.salary ASC;

/* Задание 3 */
SELECT
	e.first_name AS "Имя",
	e.last_name AS "Фамилия", 
	to_char(e.salary, '99999D99') AS "Оклад",
	trunc(j.min_salary) AS "Мин.оклад"
FROM employees e, jobs j
WHERE e.job_id = j.job_id AND j.min_salary*1.2 >= e.salary;

/* Задание 4 */
SELECT
	last_name AS "Фамилия_Р",
	first_name AS "Имя",
	to_char(salary, '99999D99') AS "Оклад"
FROM employees
WHERE salary > (
	SELECT
		AVG(salary)
	FROM employees
)
ORDER BY salary ASC;

/* Задание 5 */
SELECT 
	e.first_name AS "Имя",
    e.last_name AS "Фамилия",
    e.job_id AS "Должность",
	to_char(e.salary, '999999D99') AS "Оклад"
FROM employees e
/*WHERE e.job_id = j.job_id AND e.salary = j.max_salary*/
WHERE e.salary, e.job_id IN (
	SELECT 
		max_salary,
		job_id
	FROM jobs
);
	 