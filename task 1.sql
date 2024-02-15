--2
SELECT *
FROM bd_departments
WHERE LENGTH(street) = POWER(SQRT(75 + LENGTH(street)), 2) / 4;

INSERT INTO bd_departments VALUES
(35,'meow', 407596, 'aaaaaaaaaaaaaaaaaaaaaaaaa', 2, 'MSK');
--4
CREATE TABLE employees_backup AS
SELECT *, 
    CASE 
        WHEN random() < 0.5 THEN 'Active'
        ELSE 'Inactive'
    END AS employee_status
FROM bd_employees;
SELECT * FROM employees_backup;
--5
SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE LENGTH(m.last_name) > 6;

--3--

DO $$
DECLARE
BEGIN
    RAISE NOTICE 'Шахматная доска:';
    CALL chess('z9', 'C');
 

    RAISE NOTICE 'Размещение фигуры А на клетке A5:';
    CALL chess('a5', ' A ');


    RAISE NOTICE 'Размещение фигуры У на клетке H4:';
    CALL chess('h4', ' Y ');


END $$;



CREATE OR REPLACE PROCEDURE chess(pos varchar, bukva char) AS $$
DECLARE
    board text;
    queen_col integer;
    queen_row integer;
BEGIN
    queen_col := ascii(substring(pos from 1 for 1)) - 96;
    queen_row := substring(pos from 2)::integer;
	
    FOR i IN 1..8 LOOP
        board := '';
		
        FOR j IN 1..8 LOOP
            IF i = queen_row AND j = queen_col THEN
                board := board || bukva;
            ELSE
                IF (i + j) % 2 = 0 THEN
                    board := board || ' б ';
                ELSE
                    board := board || ' ч ';
                END IF;
            END IF;
        END LOOP;
		
        RAISE NOTICE '%', board;
    END LOOP;
END
$$ LANGUAGE plpgsql;
SELECT chess('c3');