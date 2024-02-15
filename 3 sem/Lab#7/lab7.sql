-- Лабораторная работа №7 || Антипенко, Дробышевский || Вариант 4 -- 

-- Задание 1
-- • Создайте две таблицы: people и people_log. Первая таблица должна
-- содержать поля идентификатор (id), имя (first_name), фамилия
-- (last_name), дата рождения (birthday), текущее состояние счёта
-- (amount). Поле id – это первичный ключ. Поле amount – это
-- действительное число. Вторая таблица должна содержать поля:
-- идентификатор человека (person_id) дата операции (operation_date),
-- сумма (sum). Поле person_id должно быть ограничено, как внешний
-- ключ, ссылающийся на поле id таблицы people. Поле operation_date
-- должно позволить сохранять дату и время. Поле sum – это
-- действительное число. Заполните таблицы people и people_log
-- несколькими записями (не менее 5 на таблицу).

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthday DATE,
    amount DECIMAL(10, 2)
);

CREATE TABLE people_log (
    id SERIAL PRIMARY KEY,
    person_id INTEGER REFERENCES people(id),
    operation_date TIMESTAMP,
    sum DECIMAL(10, 2)
);

INSERT INTO people (first_name, last_name, birthday, amount) 
VALUES 
('Иван', 'Иванов', '1985-05-15', 1000.50),
('Петр', 'Петров', '1990-10-20', 750.25),
('Мария', 'Сидорова', '1978-12-03', 3000.75),
('Елена', 'Козлова', '1989-08-27', 200.00),
('Алексей', 'Смирнов', '1980-04-18', 1500.00);

INSERT INTO people_log (person_id, operation_date, sum) 
VALUES 
(1, '2023-09-20 10:15:00', 250.00),
(3, '2023-10-01 15:30:00', 800.50),
(2, '2023-11-05 08:45:00', 100.25),
(4, '2023-11-25 12:00:00', 50.00),
(5, '2023-12-02 18:20:00', 300.00);

SELECT * FROM people;
SELECT * FROM people_log;


-- Задание 2
-- • Напишите процедуру или функцию statement_of_acount, которая на
-- основе двух параметров: даты начала периода и даты окончания
-- периода печатала бы на экран данные (operation_date и sum) трёх самых
-- крупных операций с положительной суммой, трёх самых крупных
-- операций с отрицательной суммой и данные об общем числе операций
-- и среднем значении суммы.

CREATE OR REPLACE FUNCTION statement_of_account(start_date DATE, end_date DATE) RETURNS VOID AS $$
DECLARE  
    pos_counter INTEGER := 0;
    neg_counter INTEGER := 0;
    total_sum NUMERIC := 0;
    total_count INTEGER := 0;
    const CONSTANT INTEGER := 3;
    avg_amount NUMERIC := 0;
    operation RECORD;
BEGIN
    FOR operation IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date
        ORDER BY sum
    ) LOOP
        IF operation.sum > 0 THEN
            pos_counter := pos_counter + 1;
            IF pos_counter <= const THEN
                RAISE INFO 'Positive: %, Sum: %', operation.operation_date, operation.sum;
            END IF;
        ELSE
            neg_counter := neg_counter + 1;
            IF neg_counter <= const THEN
                RAISE INFO 'Negative: %, Sum: %', operation.operation_date, operation.sum;
            END IF;
        END IF;
        
        total_sum := total_sum + operation.sum;
        total_count := total_count + 1;
    END LOOP;

    IF total_count > 0 THEN
        avg_amount := total_sum / total_count;
    END IF;
    
    RAISE INFO 'Total number of operations: %', total_count;
    RAISE INFO 'Average amount of transactions: %', avg_amount;
END
$$ LANGUAGE plpgsql;



-- Задание 3
-- • Напишите процедуру или функцию account_operation, которая на
-- основе двух параметров: идентификатора человека и суммы вносит
-- изменения в таблицы people и people_log. В таблице people у человека с
-- указанным в качестве параметра идентификатором состояние счёта
-- должно измениться на указанную в качестве параметра сумму. В
-- таблицу people_log должна быть добавлена запись с указанным в
-- качестве параметра идентификатором человека, текущей датой и
-- временем и указанной в качестве параметра суммой.



CREATE OR REPLACE PROCEDURE account_operation(new_id integer, add_sum numeric) AS $$ 
DECLARE
m integer;
BEGIN 
select into m count(operation_date) from people_log where to_char(operation_date,'DD')= to_char(now(),'DD');
if m>=3 then

    UPDATE people 
	SET amount = amount + add_sum 
	WHERE id = new_id;
    INSERT INTO people_log (person_id, operation_date, sum) VALUES (new_id, CURRENT_TIMESTAMP(0), add_sum);
ELSE
raise info 'Too many operations'
END $$ LANGUAGE plpgsql; 

CALL account_operation(5, 1000000);

SELECT * FROM people;
SELECT * FROM people_log;


CREATE OR REPLACE FUNCTION statement_of_account(start_date DATE, end_date DATE) RETURNS VOID AS $$
DECLARE  
    pos_counter INTEGER := 0;
    neg_counter INTEGER := 0;
    total_sum NUMERIC := 0;
    total_count INTEGER := 0;
    const CONSTANT INTEGER := 3;
    avg_amount NUMERIC := 0;
    operation RECORD;
BEGIN
    FOR operation IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date
        ORDER BY sum
    ) LOOP
        IF operation.sum > 0 THEN
            pos_counter := pos_counter + 1;
            IF pos_counter <= const THEN
                RAISE INFO 'Positive: %, Sum: %', operation.operation_date, operation.sum;
            END IF;
        ELSE
            neg_counter := neg_counter + 1;
            IF neg_counter <= const THEN
                RAISE INFO 'Negative: %, Sum: %', operation.operation_date, operation.sum;
            END IF;
        END IF;
        
        total_sum := total_sum + operation.sum;
        total_count := total_count + 1;
    END LOOP;

    IF total_count > 0 THEN
        avg_amount := total_sum / total_count;
    END IF;
    
    RAISE INFO 'Total number of operations: %', total_count;
    RAISE INFO 'Average amount of transactions: %', avg_amount;
END
$$ LANGUAGE plpgsql;
