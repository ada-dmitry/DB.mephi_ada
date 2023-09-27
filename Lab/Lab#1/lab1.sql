CREATE table countries (
  id numeric(3) PRIMARY KEY NOT NULL,
  
  name_country varchar(64) NOT NULL
);

CREATE table schedules (
  id integer PRIMARY KEY,
  
  dt_dep timestamp without time zone NOT NULL,
  dt_arr timestamp without time zone NOT NULL,
  
  plс_of_dep varchar(2000) NOT NULL default 'Москва',
  plc_of_arr varchar(2000) NOT NULL,
  
  tpe varchar(9) NOT NULL
  CHECK(tpe = 'Скорый' OR tpe = 'Фирменный' OR tpe = 'Обычный'),
  
  cnt_stops integer CHECK(cnt_stops > 0),
  
  id_oper numeric(3) references countries(id) not null
);

INSERT into countries 
  VALUES 
  (321, 'Россия');
  
INSERT into schedules
  VALUES(1, '1999-01-08 04:05:06',
  '1999-01-08 04:05:06', default, 'СПб', 'Скорый', 40, 321);

SELECT * FROM countries;
SELECT * FROM schedules;
