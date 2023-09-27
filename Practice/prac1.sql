DROP TABLE IF EXISTS professors;

CREATE table professors(
    id integer PRIMARY KEY,
    first_name varchar(20) NOT NULL,
    last_name varchar(20) NOT NULL,
    sec_name varchar(20),
    salary integer CHECK(salary <= 900000) NOT NULL,
    subj varchar(20) default 'Общая практика',
    work_exp integer CHECK(work_exp >= 0),
    dep varchar(2)
);

INSERT into professors VALUES 
(1, 'Rob', 'Ivanov', 'Ivanovich', 34000, default, 3, '75'),
(2, 'Vasiliy', 'Vasilyev', 'Vasilyevich', 874000, 'TMP', 12, 42),
(3, 'Сергей', 'Егоров', 'Артемьевич', 37879, default, 2, 33),
(4, 'Егор', 'Медведев', 'Кириллович', 34000, default, 3, '75'),
(5, 'Андрей', 'Смирнов', ' Александрович', 554000, 'TMP', 6, 72),
(6, 'Андрей', 'Егоров', 'Артемьевич', 37879, default, 2, 83),
(7, 'Rob', 'Ivanov', 'Ivanovich', 34000, default, 6, '75'),
(8, 'Vasiliy', 'Vasilyev', 'Vasilyevich', 874000, 'TMP', 12, 49),
(9, 'Петр', 'Сергеев', 'Артемьевич', 349583, default, 3, 43),
(10, 'Егор', 'Вакутагин', 'Артемьевич', 35669, default, 2, 33);


/*SELECT last_name, first_name FROM professors;*/
SELECT first_name, last_name AS last_name, first_name FROM professors;

DROP table professors;

SELECT * FROM professors;