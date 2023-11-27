SELECT * 
FROM bd_employees 
WHERE last_name ~ '^[a-zA-Z]+[-[a-zA-Z]]{0,}';

SELECT * 
FROM bd_employees
WHERE department_id IN (
	SELECT id
	FROM bd_departments
	WHERE street ~ '^[A-Za-z\s]+$'
);


SELECT last_name, 
       CASE WHEN phone_number LIKE '+7%' 
	   THEN CONCAT('8', SUBSTRING(phone_number, 3)) 
	   ELSE phone_number END AS phone 
FROM bd_employees;

UPDATE staff 
SET department = (SELECT department_name FROM departments WHERE department_id = 60) 
WHERE department in (
	SELECT department_name
	FROM departments
	WHERE department_id in (
		SELECT department_id
		FROM employees
		WHERE manager_id = (
			SELECT employee_id 
			FROM employees
			WHERE first_name = 'Neena' AND last_name= 'Kochhar')));
	
SELECT *
FROM bd_employees
WHERE LENGTH(REGEXP_REPLACE(first_name, '[^aeiouAEIOU]', '', 'g')) <= 3;

WITH tmp AS 
	(
	SELECT
	last_name,
	(REGEXP_MATCHES(LOWER(last_name), '[a-z]', 'g'))[1] AS l,
	COUNT(*)*(ASCII((REGEXP_MATCHES(LOWER(last_name), '[a-z]', 'g'))[1]) - 96) AS cnt_l
	FROM bd_employees
	GROUP BY last_name, l
	)
SELECT last_name, sum(cnt_l) FROM tmp GROUP BY last_name;
