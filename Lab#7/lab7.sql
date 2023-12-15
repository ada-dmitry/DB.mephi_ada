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

CREATE OR REPLACE PROCEDURE statement_of_acount(start_date DATE, end_date DATE) AS $$ 
DECLARE 
    pos_sum RECORD;
    neg_sum RECORD;
    total_count INTEGER;
    avg_amount NUMERIC;
	const CONSTANT INTEGER = 3;
	
BEGIN 
    FOR pos_sum IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date AND sum > 0
        ORDER BY sum DESC
        LIMIT const
    ) LOOP
        RAISE INFO 'Positive: %, Sum: %', pos_sum.operation_date, pos_sum.sum;
    END LOOP;

    FOR neg_sum IN (
        SELECT operation_date, sum
        FROM people_log
        WHERE operation_date BETWEEN start_date AND end_date AND sum < 0
        ORDER BY sum ASC
        LIMIT const
    ) LOOP
        RAISE INFO 'Negative: %, Sum: %', neg_sum.operation_date, neg_sum.sum;
    END LOOP;

    SELECT COUNT(*) INTO total_count
    FROM people_log
    WHERE operation_date BETWEEN start_date AND end_date;

    SELECT AVG(sum) INTO avg_amount
    FROM people_log
    WHERE operation_date BETWEEN start_date AND end_date;

    RAISE INFO 'Total number of operations: %', total_count;
    RAISE INFO 'Average amount of transactions: %', avg_amount;

END $$ LANGUAGE plpgsql; 

CALL statement_of_acount('2023-01-01', '2023-12-31');


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
BEGIN 
    UPDATE people 
	SET amount = amount + add_sum 
	WHERE id = new_id;
    INSERT INTO people_log (person_id, operation_date, sum) VALUES (new_id, CURRENT_TIMESTAMP(0), add_sum);
END $$ LANGUAGE plpgsql; 

CALL account_operation(5, 1000000);

SELECT * FROM people;
SELECT * FROM people_log;