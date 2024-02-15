CREATE table students(
  id integer primary key,
  f_name varchar(20) NOT NULL,
  l_name varchar(20) NOT NULL,
  age integer CHECK(age >= 18) NOT NULL,
  grp char(7) NOT NULL,
  code_spec char(8)
);

INSERT into students VALUES 
(1, 'Vasya', 'Pupkin', 20, 'C21-712', '10.05.04'),
(2, 'Vasya', 'Pupkin', 20, 'C21-712', '10.05.04'),
(3, 'Ivan', 'Ivanov', 30, 'A12-456', '15.06.11'),
(4, 'Sasha', 'Smirnova', 19, 'C12-987', '11.07.08'),
(5, 'Natasha', 'Nikitina', 28, 'D21-654', '03.03.10'),
(6, 'Nikita', 'Orlov', 23, 'E11-345', '19.08.05'),
(7, 'Olga', 'Petrova', 22, 'F22-876', '22.05.12'),
(8, 'Elena', 'Efimova', 33, 'G11-234', '13.09.01');

/*SELECT f_name AS l_name, l_name AS f_name, age AS grp, grp AS age,code_spec
FROM students;*/

ALTER TABLE students ADD gender char(1);

ALTER TABLE students ADD CONSTRAINT gender SET UNIQUE;

INSERT into students VALUES 
(1, 'Vasya', 'Pupkin', 20, 'C21-712', '10.05.04', 'm');

SELECT * FROM students;