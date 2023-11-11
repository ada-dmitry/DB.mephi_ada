SELECT * 
FROM bd_employees 
WHERE last_name ~ '^[a-zA-Z]+-[a-zA-Z]+$';

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
SET department = '60' 
WHERE id = (
	SELECT manager_id 
	FROM employees 
	WHERE first_name LIKE 'Neena' AND last_name LIKE 'Kochhar');
	
SELECT *
FROM bd_employees
WHERE LENGTH(REGEXP_REPLACE(first_name, '[^aeiouAEIOU]', '', 'g')) <= 3;

WITH tmp AS (
	SELECT chr(i+96), i FROM generate_series(1,26) i)
SELECT e.last_name sum(t.i) AS name_sum
FROM db_employees e
JOIN tmp t ON t.chr = ANY(string_to_array(LOWER(e.last_name), NULL))
GROUP BY e.last_name;