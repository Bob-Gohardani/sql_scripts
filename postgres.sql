/* 
POSTGRES
a database management system (DBMS) is a software application that interacts iwth the user, applications and the database
itself to capture and analyse data. the data stored in the database can be modified, retrieved and deleted.
and can be of any tpe like strings, numbers, images, etc... 


-- command line codes:
psql -U username databaseName  -- login to database from cmd | example : psql -U postgres

\q -- quit the database
\c databaseName -- switch to another database
\l -- shows list of all databases
\d -- shows all tables and relations in current database
\dt -- only show tables
\d tableName --describes a specific table
\i C:Users/Bob/Downloads/script.sql -- runs the sql script

-- export selected data from postgres to csv file:
\copy (select * from person) TO 'C:/Users/Bob/Downloads/results.csv' DELIMITER ',' CSV HEADER;
*/


-- create and delete database
create database database1; --create database
drop database database1; -- delete database

/*
Schema vs Database

a database is the main container, it contains data and log files, and all schemas within it, you can always backup
a database, it is a discrete unit on its own.

Schemas are like folders within a database, and are mainly used to group logical objects together, which leads to ease of
setting permissions by schema.

schema should be created inside a database. the basic syntax of CREATE SCHEMA is as follows:
CREATE SCHEMA name;
*/

create table mySchema.myTable (
...
);

create schema mySchema;

create table mySchema.company(
    ID INT NOT NULL ,
    NAME VARCHAR (20) NOT NULL ,
    AGE INT NOT NULL ,
    ADDRESS CHAR (25),
    SALARY DECIMAL (18, 2),
    PRIMARY KEY (ID));

drop schema mySchema cascade; --drop full schema with tables with rows inside
drop schema mySchema; --drop empty schema


-- create table
-- create table table_name (column_name + data_type + constraints( if any));

-- delete table
-- drop table table_name;

create table person (id int,  first_name varchar (50),
                    last_name varchar(50), gender varchar (6),
                    date_of_birth timestamp);

create table person_guarded (id bigserial not null primary key,
                       first_name varchar (50) not null,
                       las_name varchar (50) not null,
                       gender varchar(7) not null,
                       date_of_birth date  not null,
                       email varchar (100),
                       country_of_birth varchar (150) not null);

-- Data Types

bigserial -- signed integer that auto increments]

--data types of numeric type:
numeric
smallint
integer
bigint
decimal
double -- has to define precision for it

money --the money type stores a currency amount with a fixed fractional precision. values of numeric

boolean --True of False value

character varying (N)  --variable length with limit
varchar (N) --variable length with limit
text --variable with unlimited length

-- first number = how many digits before decimal point
-- second number = how many digits after decimal point
price NUMERIC (19, 2) NOT NULL

-- Serials : all serials are auto incremented
smallSerial
serial
bigSerial -- BIGSERIAL : it is same as BIGINT but has auto increment function and can also be incremented by the user if invoked.

/*
UUID = universally unique identifier uuid is a type of identifier that is pretty much impossible to be duplicate of another uuid and
can be used as primary key in postgres databases

benefits of using uuid instead of BIGINT:
    it will be harder for attackers to guess the sequence of ids in our database
    easier to migrate database to other locations
 */

create extension if not exists "uuid-ossp"; --installs uuid extension on postgres

-- setting foreign keys with uuid
update person set car_uid = '17d11cd6-a272-477d-83c3-1f164c619624' where person_uid = 'ed0fd5a9-f7db-48ed-966a-e8c9517b8276';

--Insertion into database
insert into person(first_name, last_name, gender, date_of_birth) values ('Anne', 'Smith', 'F', date '1988-01-09');
insert into person(first_name, last_name, gender, date_of_birth, email) values ('Jake', 'Sanderson', 'M', date '1992-01-12', 'jake@gmail.com');

-- Querying database
select * from table_name; -- get everything from a table
select from table_name; --get number of all rows from a table

select first_name, las_name from person;

-- ASC / DESC
-- ASC : 1 2 3 A B C
-- DESC : 321 C B A

select * from person order by country_of_birth asc;  -- ASC is the default so it is not necessary to write it.
select * from person order by country_of_birth desc; -- last to first

-- order by
select * from person order by id desc; -- last row first

-- when you order by descending, it will first show the rows that are empty for the descending column
select * from person order by date_of_birth; --goes from small to big so it moves from oldest to youngest person

-- DISTINCT
select distinct country_of_birth from person order by country_of_birth desc; --only unique values will be returned
select distinct country_of_birth from person;

-- WHERE | AND | OR
select * from person where gender = 'Female';
select * from person where gender = 'Male' and country_of_birth = 'Poland';
select * from person where gender = 'Male' and (country_of_birth='China' or country_of_birth='Japan');
select  * from person where gender = 'fluid' and (country_of_birth='Sweden' or country_of_birth='Denmark') and last_name='Erickson';

-- LIMIT | OFFSET
select * from person limit 10;
select * from person offset 5; -- all rows except first 5

select * from person offset 5 fetch first 5 row only; -- skip first 5 rows and limit to 5
select * from person offset 5 limit 5;  -- skip first 5 rows and limit to 5

-- IN
select * from person where country_of_birth = 'China' or country_of_birth='Brazil' or country_of_birth = 'France' limit 10;
select * from person where country_of_birth in ('China', 'Brazil', 'France') limit 10;

-- Between
select * from person where date_of_birth between date '2018-01-01' and '2018-09-30';

-- show only even or odd rows
select * from men where (rowid % 2) = 1 -- odd
select * from men where (rowid % 2) = 0 -- even

select * from person where car_id is null; -- all rows where this column is empty
select * from person where car_id is not null; -- all rows where column not empty

-- LIKE | ILIKE | wild cards
select * from person where email like '%.com';
select * from person where email like '%.ru' order by email desc;
select * from person where email like '%@bloomberg.com';
select * from person where email like '%@google.%';  -- using two wild cards, when after % is empty it means anything can go here
select * from person where email like '____@%';  -- select all people where their email has 4 characters before @
select * from person where country_of_birth like 'U%' limit 5;
select * from person where country_of_birth ilike 'u%' limit 5; -- ILIKE is same as LIKE, but it is case insensitive

-- AGGREGATE FUNCTIONS

-- COUNT
select country_of_birth from person group by country_of_birth; --make groups based on each unique value of the column

COUNT()  -- is an aggregate function and can't be used without a group by, where,...

-- count method counts number of each record for each of the groups made with group by
select country_of_birth, count(*) from person group by country_of_birth order by count(*) desc;

-- HAVING keyword should be used right after group by clause
select country_of_birth, count(*) from person group by country_of_birth having count(*) > 7 order by COUNT(*) desc;

select gender, count('Male') from person group by gender;

select count(*) from car;


-- MAX | MIN | AVG | SUM

select max(price) from car;
select min(price) from car;
select avg(price) from car;
select round(avg(price)) from car;  -- round down the value to integer

-- group by the cars by brand and model (each unique combination of brand and model is a group) and find minimum price for each of these groups
select make, model, min(price) from car group by make, model;
select make, max(price) from car group by make order by max(price) desc;

select sum(price) from car where make='Hummer'; -- adds up all values of price column for the brand hummer
select make, sum(price) from car group by make;
select make, sum(price) from car group by make order by sum(price) desc;

-- what does sql clause "GROUP BY 1" means?
-- it means group by first column from select. the same pattern could be used for order by

-- add two count(*) results together on two different tables
select
    (select count(*) from toys where little_kid_id = 900)+
    (select count(*) from games where little_kid_id in (900, 950, 1000))
as sumCount;


-- selecting count(*) with distinct
-- count all the distinct program names by program type and push number
select count(distinct program_name) as count, program_type as myType
from cm_production where push_number=@push_number group by program_type;

-- AS
select id, make, model, price AS original_price,
       round(price * 0.10,2) AS discount,
       round(price - (price * 0.10), 2) AS discounted_price
from car;

select id, make, model, price,round(price * .10, 2) from car;
select id, make, model, price, round(price - (price * 0.10), 2) from car;

-- using math
select 10^2;
select 10+2;
select 10!; -- factorial
select 10 % 3;

SQRT() -- square root of a number
POWER(m, n); -- number m to the power of n


-- COALESCE | NULLIF
-- COALESCE will return second (or third) value if first (or first and second) value is null
select coalesce(1);
select coalesce(null, null, 1) as number;
select coalesce(email, 'email not provided') from person;

select nullif(10, 10); -- returns true when both values are same
select nullif(10, 3); -- returns false when values are different
select COALESCE(10 / nullif(0, 0), 0); -- this way postgres won't throw error for division by zero

-- DATE and TIME

select NOW(); -- returns timestamp
select NOW()::DATE; -- returns date only
select NOW()::TIME; -- returns time only

select NOW() - interval '1 YEAR'; -- go back in time one year
select NOW() - interval '10 DAYS';
SELECT NOW() - interval '3 MONTHS';
select NOW() + interval '6 MONTHS'; -- go ahead 6 months from now
select (NOW() + interval '6 MONTHS')::DATE;

select EXTRACT(YEAR FROM NOW()); -- returns only year
select EXTRACT(CENTURY from NOW());

select first_name, last_name, AGE(NOW()::DATE, date_of_birth) AS age from person;

-- date_trunc("month", min(occurred_at)) : find the month for earliest date of a row, first occurrence
select *
from demo.orders
where date_trunc("month", occured_at) = (select date_trunc("month", min(occured_at)) from demo.orders)
order by occured_at;


-- PRIMARY KEY: is a unique key for each row of the table and can't be repeated since its unique.
-- you can't add primary key to a table when there are duplicate rows.

alter table person add primary key (id); -- add primary key
alter table person drop constraint person_pkey;  -- how to remove a primary key


-- ALTER TABLE

--adding column to a table
alter table table_name add column_name data_type;

-- drop column from table
alter table table_name drop column column_name;

-- change datatype of a column
alter table table_name alter column column_name type data_type;

-- set column to not null
alter table table_name modify column_name data_type not null;

-- adding unique constraint, so there won't be any repetition in the column cells
alter table table_name add constraint MyUniqueConstraint UNIQUE(column1, column2, column3);

-- add check constraint
alter table table_name add constraint MyUniqueConstraint CHECK(condition);


-- INDEX
/*
Indexes are special lookup tables that the database search engine can use to speed up data retrieval. Simply put, an index is a
pointer to data in a table. An index in a database is very similar to an index in the back of a book. For example, if you want
to reference all pages in a book that discusses a certain topic, you have to first refer to the index, which lists all topics
alphabetically and then refer to one or more specific page numbers. An index helps to speed up SELECT queries and WHERE clauses;
however, it slows down data input, with UPDATE and INSERT statements. Indexes can be created or dropped with no effect on the data.
*/

CREATE INDEX index_name ON table_name
[USING method]
(
    column_name [ASC | DESC] [NULL {FIRST | LAST}],
    ...
);

/* First, specify the index name after the "CREATE INDEX" clause. The index name should be meaningful and easy to remember.
Second, specify the name of the table to which the index belongs to. Third, specify the index method such as btree, hash,
gist, spgist, gin, and brin.
POSTGRES uses btree by default.
Fourth, list one or more columns that to be stored in the index. The ASC and DESC specify the sort order.
ASC is the default. NULLS FIRST or NULLS LAST specifies nulls sort before or after non-nulls.
The NULLS FIRST is the default when DESC is specified and NULLS LAST is the default when DESC is not specified.
 */

create index idx_model on car(model);  -- this way search will give results much faster when searching for model of a car
create index index_name on table_name (column_name1, column_name2); -- multi-column indexing


-- CONSTRAINTS | UNIQUE | CHECK

-- check if there are any duplicate emails
select email, count(*) from person group by email HAVING count(*) > 1;
-- Using this has similar results as above except that the rows with empty email will return 0:
select email, count(email) from person group by email;

-- Add unique constraint to emails, here we gave it a name but it is not necessary:
-- unique constraint can’t be used to identify rows (unlike primary key)
alter table person add constraint unique_email unique (email);

-- make sure salary input is above 0 by CHECK constraint
create table company (
    id int primary key not null,
    name text not null,
    salary real check(salary > 0)
);

-- making sure a column has only 3 input options
ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK (gender = 'Female' or gender = 'Male', gender='Other');


-- INTERSECT
-- fetch common records from two tables using INTERSECT
select column1, column2 from table_1 where condition
INTERSECT
select column1, column_2 from table_2 where condition;

select studentID from students
intersect
select grades from exams


-- String Functions
-- The Postgres length() function is used to find the length of a string i.e. number of characters in the given string.
select length('w3resource') AS "length of string";

-- get first character of a string in SQL
LEFT(my_column, 1);
SUBSTRING(my_column, 1, 1);

-- add text to column's select statement
select 'Please try after' + CAST((1328724983-time)/60/60 as varchar(80)) AS status FROM voting where account = 'ThElitEyeS' and vid = 1;

-- Remove certain characters from a string
REPLACE('Your String with cityName here', 'cityName', 'xyz')  --Results : 'Your String with xyz here'


-- DELETE
-- delete all rows where this condition applies:
delete from person where first_name = 'Noemi';
delete form person where firs_name = 'Cass';
delete from person; -- deletes everything from table
delete from person where id = 1;
delete from person where gender =  'Female' and country_of_birth = 'Nigeria';

-- how to delete only 1 row:
delete from person where ctid in (select citid from person where gender='Female' limit 1);


-- Truncate
/*
The PostgreSQL TRUNCATE TABLE command is used to delete complete data from an existing table. You can also use DROP TABLE
command to delete complete table but it would remove table structure from the database and you would need to re-create this
table once again if you wish to store some data.
It has the same effect as DELETE on each table, but since it does not actually scan the tables, it is faster. Furthermore,
it reclaims disk space immediately, rather than requiring a subsequent VACUUM operation. This is most useful on large tables.

TRUNCATE TABLE  table_name;
*/


-- UPDATE
update person set email = 'babak@gmail.com' where id = 18;
update person set first_name = 'babak', country_of_birth = 'Iran' where id = 18;

-- IF in 'SELECT' statement - choose output value based on column values
select id,
    IF(type = 'P', amount, amount * -1) as amount  --if type is P select amount else select amount * -1
from report;


-- SubQuery
/*
a subquery or inner query or nested query is a query within another PostgreSQL query and embedded within the where clause.
a subquery is used to return data that will be used in the main query as a condition to further restrict the data to be retrieved.
 */
select * from company where ID in (select id from company where salary > 45000);

insert into company_two (select * from company where id in (select id from company where salary < 10000));

update company set salary = salary * 0.5 where age in (select age from company_bkp where age >= 27);

delete from company where age in (select age from company_bkp where age > 27);


-- dealing with ERROR | ON CONFLICT
-- if there is error for duplicate id do nothing(will skip this error):
insert into person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)
            values (18,'Willie', 'Cherrett', 'Male', 'wcherrett0@slate.com', '2018-06-18', 'Indonesia')
            ON CONFLICT (id) DO NOTHING;

-- whenever you want to use ON CONFLICT make sure column is unique or primary key.
-- If there is a conflict of ID when inserting, do nothing except updating the email:
insert into person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)
            values (18,'Willie', 'Cherrett', 'Male', 'wcherrett0@slate.com', '2018-06-18', 'Indonesia')
            ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;

-- If there is a conflict of ID when inserting, do nothing except updating the first_name:
insert into person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth)
            values (18, 'Willie', 'Cherrett', 'Male', 'wcherrett0@slate.com', '2018-06-18', 'Indonesia')
            ON CONFLICT (id) DO UPDATE SET first_name= EXCLUDED.first_name;

-- USING
-- when both keys are same you can use the 'USING' keyword:
select * from person left join car on car.car_uid = person.car_uid;
-- same as:
select * from person left join car USING (car_uid);


-- NULL values
/*
NULL is the term used to represent a missing value. a NULL value in a table is a value in a field that appears to be blank.
a field with a NULL value is a field with no value. it is very important to understand that a null value is different from a zero value
or a field that contains space.  */

UPDATE person SET first_name= NULL, email= NULL where ID in (6,7,8);
select id, name, age, address, salary from company where salary is not null;
select id, name, age, address, salary from company where salary is null;


-- RELATIONSHIPS
-- there are 3 types of relationships in a relational database.
-- one-to-one : A user has ONE address
-- one-to-many : A book has MANY reviews
-- many-to-many : A user has MANY books and a book has MANY users


-- one-to-one
/* primary key and foreign key both have same type. (here is One-To-One relationship): means id column in car table should have same
data type as car_id foreign key in person table */
create table car (
    id bigserial not null primary key,
    make varchar (100) not null,
    model varchar (100) not null,
    price numeric (19, 2) not null
);

-- we create car table first because the person table needs the foreign key from car table
create table person (
    id big serial not null primary key,
    first_name varchar (50) not null,
    last_name varchar (50) not null,
    email varchar (100),
    car_id bigint REFERENCES car (id),
    UNIQUE(car_id)
);

-- Add foreign key between car and person tables, car_id is same as id column in car table:
update person set car_id = 2 where id = 1;
update person set car_id = 1 where id = 2;

-- since this is a 1-to-1 relationship, each item can only connect to one other row of other table


-- one-to-many
/*
A one-to-many relationship exists between two entities if an entity instance in one of the tables can be associated with multiple
records (entity instances) in the other table. The opposite relationship does not exist; that is, each entity instance in the second table
can only be associated with one entity instance in the first table.
*/

CREATE TABLE users (
  id serial,
  username VARCHAR(25) NOT NULL,
  enabled boolean DEFAULT TRUE,
  last_login timestamp NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id));

-- one to one: User has one address
CREATE TABLE addresses (
  user_id int NOT NULL,
  street VARCHAR(30) NOT NULL,
  city VARCHAR(30) NOT NULL,
  state VARCHAR(30) NOT NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE books (
  id serial,
  title VARCHAR(100) NOT NULL,
  author VARCHAR(100) NOT NULL,
  published_date timestamp NOT NULL,
  isbn int,
  PRIMARY KEY (id),
  UNIQUE (isbn)
);

-- one to many: Book has many reviews
drop table if exists reviews;
create table reviews (
    id serial,
    book_id int not null,
    user_id int not null,
    review_content varchar (255),
    rating int,
    published_date timestamp DEFAULT CURRENT_TIMESTAMP,
    primary key (id),
    foreign key (book_id) references books(id) on delete cascade,
    foreign key (user_id) references users(id) on delete cascade
);

/*
when rows have relation with another table (foreign key) you can’t normally delete them.first delete the
row that contains the foreign key, then u can delete the row that is being referenced in other table.

** with cascading, when you delete a row the related row with foreign key in other table will also be
deleted. (its considered a bad practise)
*/


-- many-to-many
/*
A many-to-many relationship exists between two entities if for one entity instance there may be multiple records in the other table and vice versa.
Example: A user has many books checked out or may have checked them out in the past. A book has many users that have checked a book out.
In the database world, this sort of relationship is implemented by introducing a third cross-reference table, that holds the relationship
between the two entities, which is the PRIMARY KEY of the books table and the PRIMARY KEY of the user table.
*/

create table users_books (
    user_id int not null,
    book_id int not null,
    checkout_date timestamp,
    return_date timestamp,
    primary key (user_id, book_id),
    foreign key (user_id) references users(id) on update cascade,
    foreign key (book_id) references books(id) on update cascade
);


-- JOINS

-- INNER JOIN : happens when two different tables have something in common (usually a foreign key or row)
select person.first_name, car.make, car.model from person join car on person.car_id = car.id;

-- LEFT JOIN : gets everything from table A + rows from table B that have something in common with A.
select * from person LEFT JOIN car ON car.id = person.car_id;
-- Exactly same as, order of tables in equation doesnt matter :
select * from person LEFT JOIN car ON person.car_id = car.id;

-- Get everything where table A has nothing in common with B
Select * from person LEFT JOIN car ON car.id = person.car_id WHERE car.* IS NULL;  -- gets all the people who dont own a car

-- CROSS JOIN :
/* a CROSS JOIN matches every row of the first table with every row of the second table. If the input tables have x and y columns,
respectively, the resulting table will have x+y columns. Because CROSS JOINs have the potential to generate extremely large tables,
care must be taken to use them only when needed  */
select * from person CROSS JOIN car;

-- RIGHT JOIN : same as left join but instead selects all rows from B table and common rows from A.
select * from person RIGHT JOIN ar on car.car_uid = person.car_uid;

-- FULL JOIN (OUTER JOIN)
/* PostgreSQL FULL OUTER JOIN returns all rows from both the participating tables, extended
with nulls if they do not have a match on the opposite table.
The FULL OUTER JOIN combines the results of both left and right (outer) joins and returns all
(matched or unmatched) rows from the tables on both sides of the join clause.
 */
select * from person FULL JOIN car on car.car_uid = person.car_uid;
select car.model, person.email from person FULL JOIN car on car.car_uid = person.car_uid;

-- join two tables but only get unmatched rows
FULL OUTER JOIN Table_B where table_a.column_name is null or table_b.column_name is null;

-- Finding Matched Rows with FULL OUTER JOIN
select *
    from accounts
full join sales_reps on accounts.sales_rep_id = sales_reps.id

-- unmatched rows with full outer join
SELECT *
  FROM accounts
FULL JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL;


-- UNION
/* The PostgreSQL UNION clause/operator is used to combine the results of two or more SELECT statements without returning any duplicate rows.
To use UNION, each SELECT must have the same number of columns selected, the same number of column expressions, the same data type and have
them in the same order but they do not have to be the same length.

The UNION ALL operator is used to combine the results of two SELECT statements including duplicate rows
 */
select column1 [, column2]
from table1 [, table2]
[where condition]

UNION

SELECT column1 [, column2 ]
FROM table1 [, table2 ]
[WHERE condition]

select first_name, email from person where first_name = 'Jal'
union
select first_name, email from person where first_name = 'Bob';


-- inequality joins (with comparison operator)
SELECT accounts.name as account_name,
       accounts.primary_poc as poc_name,
       sales_reps.name as sales_rep_name
  FROM accounts
  LEFT JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
   AND accounts.primary_poc < sales_reps.name;

-- the "join" clause is evaluated before the "where" clause, filtering in the join clause will eliminate rows before
-- they are joined, while filtering in the WHERE clause will leave those rows in and produce some nulls.
select orders.id,
       orders.occured_at as order_date,
       events.*
from orders
left join web_events_full events
on events.account_id = orders.account_id
and events.occured_at < orders.occured_at
where date_trunc("month", orders.occured_at) = (select date_trunc("month", min(occured_at)) from orders)
order by orders.account_id ,orders.occured_at;


-- SELF JOIN
-- One of the most common use cases for self JOINs is in cases where two events occurred, one after another
-- finding out which account made multiple orders within 30 days
select o1.id as o1_id,
       o1.account_id as o1_account_id,
       o1.occured_at as o1_occured_at,
       o2.id as o2_id,
       o2.account_id as o2_account_id,
       o2.occured_at as o2_occured_at,
from demo.orders o1
    left join demo.orders o2
    on o1.account_id = o2.account_id -- we want the same account
    and o2.occured_at > o1.occured_at -- we need an account with at least two different orders
    and o2.occured_at <= o1.occured_at + interval '28 days' -- but the second orders date must be less than 29 days after first one
order by o1.account_id, o1.occured_at;


-- EXTENSIONS
select * from pg_available_extensions; -- shows list of all extensions available to install in postgres



-- TRANSACTION
/*
A transaction is a unit of work that is performed against a database. Transactions are units or sequences of work accomplished in a
logical order, whether in a manual fashion by a user or automatically by some sort of a database program.

A transaction is the propagation of one or more changes to the database. For example, if you are creating a record, updating a record,
or deleting a record from the table, then you are performing transaction on the table. It is important to control transactions to
ensure data integrity and to handle database errors.
 */
BEGIN; --or BEGIN TRANSACTION;
DELETE FROM COMPANY WHERE AGE = 25;
COMMIT;
--or END TRANSACTION;
--or ROLLBACK; --this one will get to situation before transaction



-- FUNCTION | Stored Procedure
/*
functions, also known as Stored Procedures, allow you to carry out operations that would normally take several queries and round
trips in a single function within the database. Functions allow database to reuse as other applications can interact directly with your
stored procedures instead of a middle-tier or duplicating code.

There are several built-in postgres functions: Count - Max - Min - Avg - Sum - Array - Numeric
PostgreSQL ARRAY_AGG function is used to concatenate the input values including null into an array.
SELECT ARRAY_AGG(SALARY) FROM COMPANY; => {20000,15000,20000,65000,85000,45000,10000}
 */

-- Custom Function
CREATE [OR REPLACE] FUNCTION function_name (arguments)
RETURNS return_datatype AS $variable_name$
   DECLARE
      declaration;
      [...]
   BEGIN
      < function_body >
      [...]
      RETURN { variable_name | value }
   END; LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION totalRecords ()
RETURNS integer AS $total$
declare
	total integer;
BEGIN
   SELECT count(*) into total FROM COMPANY;
   RETURN total;
END;
$total$ LANGUAGE plpgsql;

-- Execute the above function:
select totalRecords();


-- Trigger
/* Triggers are database callback functions, which are automatically performed/invoked when a specified database event occurs.
triggers in SQL are spacial type of store procedures that are defined to execute automatically in place or after data modifications. it allows you
to execute a batch of code when an insert, update or any other query is executed against the table.

before insert : activated before data is inserted into the table
after insert : activated after data is inserted into the table
before update : activated before data in the table is updated
after update : activated after data in the table is updated
before delete : activated before data is removed from the table
after delete : activated after data is removed from the table

A trigger that is marked FOR EACH ROW is called once for every row that the operation modifies. In contrast, a trigger that is marked
FOR EACH STATEMENT only executes once for any given operation, regardless of how many rows it modifies.
If multiple triggers of the same kind are defined for the same event, they will be fired in alphabetical order by name.
The BEFORE, AFTER or INSTEAD OF keyword determines when the trigger actions will be executed relative to the insertion,
modification or removal of the associated row
Triggers are automatically dropped when the table that they are associated with is dropped.
event_name could be INSERT, DELETE, UPDATE, and TRUNCATE
*/

create TRIGGER trigger_name [BEFORE|AFTER|INSTEAD OF] event_name
on table_name
[
  -- Trigger logic goes here ...
];

create table employees (
    id int4 serial primary key,
    first_name varchar (40) not null,
    last_name varchar (40) not null
);

CREATE TABLE employee_audits (
   id int4 serial primary key,
   employee_id int4 NOT NULL,
   last_name varchar(40) NOT NULL,
   changed_on timestamp (6) NOT NULL
);

-- create a trigger function:
create or replace function log_last_name_changes()
    returns trigger as
$BODY$
begin
if new.last_name <> old.last_name then
insert into employee_audits(employee_id, last_name, changed_on)
values (old.id, old.last_name, now());
end if;

return new;
end;
$BODY$

-- we bind the trigger function to the employees table. The trigger name is last_name_changes
create trigger last_name_changes
before update
on employees
for each row
execute procedure log_last_name_changes();


-- VIEWS
/* Views are pseudo-tables. That is, they are not real tables; nevertheless appear as ordinary tables to SELECT.
A view can represent a subset of a real table, selecting certain columns or certain rows from an ordinary table. A view
can even represent joined tables. Because views are assigned separate permissions, you can use them to restrict table
access so that the users see only specific rows or columns of a table.

view is a virtual table which consists of a subset of data contained in a table. since views are not present, it takes less
space to store. Views can have data of one or more tables combined and it depends on the relationship.
 */

create [temp | temporary] view view_name as
select column1, column2, ...
from table_name
where [condition];

create view company_view as select id, name, age from company_table;

drop view company_view;


-- INTO
/*
The "SELECT INTO" statement allows you to create a new table and inserts data returned by a query.
The new table columns have name and data types associated with the output columns of the SELECT clause. Unlike the
SELECT statement, the SELECT INTO statement does not return data to the client.
 */

SELECT
    column_list
INTO [ TEMPORARY | TEMP | UNLOGGED ] [ TABLE ] new_table_name
FROM
    table_name
WHERE
    condition;

select
    film_id,
    title,
    rental_rate
into table film_r
from
    film
where
    rating = 'R'
and rental_duration = 5
order by
    title;

-- The following statement creates a temporary table named short_film that contains all films whose lengths
-- are under 60 minutes.
select film_id,
       title,
       film_length
into temp table short_film
from
    film
where
    film_length < 60
order by
    title;


 -- if-then-else logic in SQL
IF ((SELECT COUNT(*) FROM table1 WHERE project = 1) > 0)
    SELECT product, price FROM table1 WHERE project = 1
ELSE IF ((SELECT COUNT(*) FROM table1 WHERE project = 2) > 0)
    SELECT product, price FROM table1 WHERE project = 2
ELSE IF ((SELECT COUNT(*) FROM table1 WHERE project = 3) > 0)
    SELECT product, price FROM table1 WHERE project = 3



-- CASE
CASE
    WHEN condition_1  THEN result_1
 	WHEN condition_2  THEN result_2
 	[WHEN ...]
 	[ELSE result_n]
END


select
sum (case
    when rental_rate = 0.99 then 1
    else 0
    end) as "Mass",
sum (case
    when rental_rate = 2.99 then 1
    else 0
    end) as "Economic",
sum (case
    when rental_rate = 4.99 then 1
    else 0
    end) as "Luxury"
from film;


select
CASE
    WHEN Grade >= 8 THEN Name
    WHEN Grade < 8 THEN NULL
END AS NAME
, Grade, Marks
FROM Students LEFT JOIN Grades on Students.Marks BETWEEN Grades.Min_Mark AND Grades.Max_Mark
ORDER BY Grade desc,
CASE
    WHEN Grade >= 8 THEN Name
    WHEN Grade < 8 THEN Marks
END ASC;


-- interview problem
			 
/* 
			 
'job_postings' table

col             type
--------------------
id              integer
job_id          integer
user_id        integer
date_posted     datetime

given  a table of job postings, write a query to breakdown the number of users that have posted their jobs once
versus number of users that have posted at least one job several times.
*/

with user_job as (
    select user_id, job_id, count(distinct date_posted) as num_posted
    from job_postings
    group by user_id, job_id
)

select
    SUM(case when avg_num_posted > 1 then 1 end) as posted_several_times,
    SUM(case when avg_num_posted = 1 then 1 end) as posted_once
from (
    select
        user_id,
        AVG(num_posted) as avg_num_posted   -- can also be MAX(...)
    from user_job
    group by user_id, job_id
) as t
			 
---------------------------
/*	
			 
Write SQL queries (ideally in MySQL format) that create DB schema to store people
located all over the world, data to store:
a. Name
b. Surname
c. Citizenship

Write SQL queries (ideally in MySQL format) that add parents information (mother,father) to existing schema
			 
*/
			 
create schema mySchema;
			 
CREATE TABLE mySchema.countries(
  ID INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
);
			 
create table mySchema.people(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    Name VARCHAR (50) NOT NULL ,
    Surname VARCHAR (50) NOT NULL ,
    country_id int not null,
    PRIMARY KEY (ID),
    foreign key (country_id) references countries(id) on delete cascade
);
			 
ALTER TABLE mySchema.people ADD Father BIGINT;
ALTER TABLE mySchema.people ADD CONSTRAINT foreign key (Father) references people(id);

ALTER TABLE mySchema.people ADD Mother BIGINT;
ALTER TABLE mySchema.people ADD CONSTRAINT foreign key (Mother) references people(id);
			 
			 
-- find all the people who are father or mother to another person in this table
SELECT distinct(p2.id), p2.Name, p2.Surname FROM mySchema.people as p1 inner join mySchema.people as p2 on
p2.Father = p1.ID or
p2.Mother = p1.ID;
