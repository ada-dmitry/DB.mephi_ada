DROP TABLE people_log IF EXISTS;
DROP TABLE people IF EXISTS;


--1--
CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(64),
    last_name VARCHAR(64),
    birthday DATE,
    amount NUMERIC(10,2)
);

CREATE TABLE people_log (
    person_id INTEGER REFERENCES people(id),
    operation_date TIMESTAMP,
    sum NUMERIC(10,2)
);

INSERT INTO people (first_name, last_name, birthday, amount) 
VALUES ('Andrey', 'Ad', '2004-03-09', 1000.00),
       ('Sanal', 'Bat', '2004-12-15', 2000.00),
       ('Alex', 'Yak', '2004-08-10', 3000.00),
       ('Dima', 'Klev', '2004-04-25', 4000.00),
       ('David', 'Dav', '2001-11-30', 5000.00),
	   ('Reno', 'G', '2004-08-28', 6000.00),
       ('Ilya', 'Zim', '2005-01-06', 7000.00),
       ('Sema', 'Akh', '2005-12-01', 8000.00);
	   

INSERT INTO people_log ( person_id, operation_date, sum) 
VALUES
(1, '2022-01-05 17:15:00', 100.00),
(2, '2022-01-06 17:30:00', 300.00),
(3, '2022-01-07 17:45:00', 300.00),
(4, '2022-01-08 18:00:00', 400.00),
(5, '2022-01-09 18:15:00', 500.00),
(6, '2022-01-10 17:15:00', -100.00),
(7, '2022-01-12 17:15:00', -400.00),
(8, '2022-01-29 17:15:00', -200.00);



SELECT * FROM people;
SELECT * FROM people_log; 


--2--

CREATE OR REPLACE PROCEDURE statement_of_acount(start_date DATE, end_date DATE) AS $$ 
DECLARE 
    pos_sum RECORD;
    neg_sum RECORD;
    total_count INTEGER;
    avg_amount NUMERIC;
BEGIN 
    FOR pos_sum IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date AND sum > 0
        ORDER BY sum DESC
        LIMIT 3
    ) LOOP
        RAISE INFO 'Положительная операция: %, Сумма: %', pos_sum.operation_date, pos_sum.sum;
    END LOOP;

    FOR neg_sum IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date AND sum < 0
        ORDER BY sum ASC
        LIMIT 3
    ) LOOP
        RAISE INFO 'Отрицательная операция: %, Сумма: %', neg_sum.operation_date, neg_sum.sum;
    END LOOP;

    SELECT COUNT(*) INTO total_count
    FROM people_log
    WHERE operation_date BETWEEN start_date AND end_date;

    SELECT AVG(sum) INTO avg_amount
    FROM people_log
    WHERE operation_date BETWEEN start_date AND end_date;

    RAISE INFO 'Общее количество операций: %', total_count;
    RAISE INFO 'Средняя сумма операций: %', avg_amount;

END $$ LANGUAGE plpgsql; 
CALL statement_of_acount('2022-01-01', '2022-11-12');

--3--
CREATE OR REPLACE PROCEDURE account_operation(new_id integer, summa numeric) AS $$ 
DECLARE
BEGIN 
    UPDATE people SET amount = amount + summa WHERE id = new_id;
    INSERT INTO people_log (person_id, operation_date, sum) VALUES (new_id, CURRENT_TIMESTAMP(0), summa);
END $$ LANGUAGE plpgsql; 

CALL account_operation(1, 100);