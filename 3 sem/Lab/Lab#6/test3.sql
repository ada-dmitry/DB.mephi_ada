CREATE OR REPLACE FUNCTION rearrange_salaries() RETURNS VOID AS $$
DECLARE
    salaries RECORD;
	small NUMERIC[];
	larg NUMERIC[];
	const CONSTANT INTEGER = 10;
BEGIN
    FOR salaries IN 
        SELECT id, salary_in_euro
        FROM bd6_employees 
        ORDER BY salary_in_euro 
        LIMIT const
	LOOP
		small = array_append(small, (SELECT salary_in_euro FROM bd6_employees WHERE id = salaries.id));
    	DELETE FROM bd6_employees
    	WHERE id = salaries.id;
	END LOOP;

    FOR salaries IN 
        SELECT id, salary_in_euro
        FROM bd6_employees 
        ORDER BY salary_in_euro DESC 
        LIMIT const
	LOOP
		larg = array_append(larg, (SELECT id FROM bd6_employees WHERE id = salaries.id));
	END LOOP;
	
	FOR i IN 1..const
	LOOP
        UPDATE bd6_employees
        SET salary_in_euro = salary_in_euro + small[i]
        WHERE id = larg[i];
    END LOOP;
END;
$$ LANGUAGE plpgsql;
SELECT rearrange_salaries();




CREATE OR REPLACE FUNCTION update_salaries() RETURNS VOID AS $$
DECLARE
    max_salary_employee_id INTEGER;
    min_salaries numeric[];
    max_salaries numeric[];
    i INTEGER;
    const CONSTANT INTEGER = 10;
BEGIN
    -- Получаем заработные платы последних 10 человек с самой маленькой заработной платой
    SELECT array_agg(id) FROM bd6_employees
    ORDER BY salary_in_euro ASC
    LIMIT const INTO min_salaries;

    -- Получаем заработные платы 10 первых человек с самой большой заработной платой
    SELECT array_agg(id) FROM bd6_employees
    ORDER BY salary_in_euro DESC
    LIMIT const INTO max_salaries;

    -- Добавляем заработные платы
    FOR i IN 1..const LOOP
        UPDATE bd6_employees
        SET salary_in_euro = salary_in_euro + min_salaries[i]
        WHERE id = max_salaries[i];
    END LOOP;

    -- Удаляем 10 человек с наименьшей заработной платой
    DELETE FROM bd6_employees
    WHERE id IN (SELECT unnest(min_salaries));

    RAISE NOTICE 'Заработные платы обновлены и % человек удалены', const;
END;
$$ LANGUAGE plpgsql;