CREATE table staff(
	id integer primary key,
	name varchar(64) NOT NULL,
	department varchar(64) NOT NULL
);

CREATE SEQUENCE staff_id_seq
	START WITH 12
	CYCLE
	INCREMENT BY 8
	CACHE 100;
	

INSERT INTO staff VALUES
	(nextval('staff_id_seq'), 'Ivan Makarenko', 'Director');
	
INSERT INTO staff
	(SELECT nextval('staff_id_seq'), last_name, department_name
	 FROM employees e JOIN departments d ON e.department_id = d.department_id);
	 
UPDATE staff SET department = 'Innovations department'
	WHERE id < 40;
	
DELETE FROM staff 
	WHERE name ILIKE('%K%');
	
WITH RECURSIVE tmp AS (
  SELECT employee_id, first_name, last_name, manager_id, 1 AS level
  FROM employees
  WHERE manager_id = 100
  UNION ALL
  SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, t.level + 1
  FROM employees e
  JOIN tmp t ON e.manager_id = t.employee_id
)
SELECT first_name, last_name
FROM tmp;