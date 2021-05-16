-- Interview questions and practice problems for SQL

-- display Nth row of a table/query:
-- way 1:
select * from emp limit 4
except
select all from emp limit 3;

-- way 2:
select * from (select id, emp.* from emp) where id = 4;


-- Find Nth highest value from a table:
SELECT Salary FROM
(
    SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT 10
) AS Emp ORDER BY Salary LIMIT 1;
-- another way:
SELECT DISTINCT salary from Employee ORDER BY salary DESC LIMIT 1 OFFSET 9;

-- union vs union all
/*
UNION merges the contents of two structurally-compatible tables into a single combined table. The difference between UNION 
and UNION ALL is that UNION will omit duplicate records whereas UNION ALL will include duplicate records.
*/

-- given the following tables what will be the result of query below?
sql> SELECT * FROM runners;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | John Doe     |
|  2 | Jane Doe     |
|  3 | Alice Jones  |
|  4 | Bobby Louis  |
|  5 | Lisa Romero  |
+----+--------------+

sql> SELECT * FROM races;
+----+----------------+-----------+
| id | event          | winner_id |
+----+----------------+-----------+
|  1 | 100 meter dash |  2        |
|  2 | 500 meter dash |  3        |
|  3 | cross-country  |  2        |
|  4 | triathalon     |  NULL     |
+----+----------------+-----------+

SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races)
-- If the set being evaluated by the SQL NOT IN condition contains any values that are null, then the outer query here 
-- will return an empty set.
-- to fix such issues:
SELECT * FROM runners WHERE id NOT IN (SELECT winner_id FROM races WHERE winner_id IS NOT null)


-- Assume a schema of Emp ( Id, Name, DeptId ) , Dept ( Id, Name). If there are 10 records in the Emp table and 5 records 
-- in the Dept table, how many rows will be displayed in the result of the following SQL query:
select * from Emp, Dept;
-- The query will result in 50 rows as a “cartesian product” or “cross join”, which is the default whenever the ‘where’ 
-- clause is omitted.


-- Write a query to fetch values in table test_a that are and not in test_b without using the NOT keyword.
create table test_a(id numeric);
create table test_b(id numeric);

insert into test_a(id) values
  (10), (20), (30), (40), (50)

insert into test_b(id) values
  (10), (30), (50);

-- answer:
select * from test_a except select * from test_b;


-- given the following tables:
SELECT * FROM users;
/*
user_id  username
1        John Doe                                                                                            
2        Jane Don                                                                                            
3        Alice Jones                                                                                         
4        Lisa Romero
*/
SELECT * FROM training_details;
/*
user_training_id  user_id  training_id  training_date
1                 1        1            "2015-08-02"
2                 2        1            "2015-08-03"
3                 3        2            "2015-08-02"
4                 4        2            "2015-08-04"
5                 2        2            "2015-08-03"
6                 1        1            "2015-08-02"
7                 3        2            "2015-08-04"
8                 4        3            "2015-08-03"
*/
--- Write a query to to get the list of users who took the a training lesson more than once in the same 
-- day, grouped by user and training lesson, each ordered from the most recent lesson date to oldest date.
select
    u.user_id,
    username,
    training_id,
    training_date,
    count(user_training_id) as count
from users u join training_details t 
on t.user_id = u.user_id
group by u.user_id, username, training_id, training_date
Having count(user_training_id) > 1
order by training_date desc;

-- execution plan in SQL
/*
An execution plan is basically a road map that graphically or textually shows the data retrieval methods chosen by the 
SQL server’s query optimizer for a stored procedure or ad hoc query. Execution plans are very useful for helping a 
developer understand and analyze the performance characteristics of a query or stored procedure */

-- Explain ACID concepts
/*
Atomicity, Consistency, Isolation, Durability

Atomicity => Atomicity requires that each transaction be “all or nothing”: if one part of the transaction fails, the 
entire transaction fails, and the database state is left unchanged. An atomic system must guarantee atomicity in each 
and every situation, including power failures, errors, and crashes.

Consistency => The consistency property ensures that any transaction will bring the database from one valid state to 
another. Any data written to the database must be valid according to all defined rules, including constraints, cascades, 
triggers, and any combination thereof.

Isolation => The isolation property ensures that the concurrent execution of transactions results in a system state that 
would be obtained if transactions were executed serially, i.e., one after the other. Providing isolation is the main goal
of concurrency control. Depending on concurrency control method (i.e. if it uses strict - as opposed to relaxed - serializability), 
the effects of an incomplete transaction might not even be visible to another transaction.

Durability => Durability means that once a transaction has been committed, it will remain so, even in the event of power 
loss, crashes, or errors. In a relational database, for instance, once a group of SQL statements execute, the results 
need to be stored permanently (even if the database crashes immediately thereafter). To defend against power loss, 
transactions (or their effects) must be recorded in a non-volatile memory. */


-- Given a table dbo.users where the column user_id is a unique numeric identifier, how can you efficiently select the 
-- first 100 odd user_id values from the table? (Assume the table contains well over 100 records with odd user_id values.)
SELECT TOP 100 user_id FROM dbo.users WHERE user_id % 2 = 1 ORDER BY user_id


-- What is the difference between the WHERE and HAVING clauses?
/*
When GROUP BY is not used, the WHERE and HAVING clauses are essentially equivalent
However, when GROUP BY is used:
The WHERE clause is used to filter records from a result. The filtering occurs BEFORE any groupings are made.
The HAVING clause is used to filter values from a group 
(i.e., to check conditions after aggregation into groups has been performed). */

-- Given a table Employee having columns empName and empId, what will be the result of the SQL query below?
select empName from Employee order by 2 desc; 
/* it will throw an error, because even though the table has 2 columns, here we only selected on of them */


-- Varchar vs Char
/*
When stored in a database, varchar uses only the allocated space. E.g. if you have a varchar(1999) and put 50 bytes 
in the table, it will use 52 bytes.

But when stored in a database, char always uses the maximum length and is blank-padded. E.g. if you have char(1999) 
and put 50 bytes in the table, it will consume 2000 bytes.
*/

-- The invoices table contains the reference number and due dates of invoices. After some negotiations, it was agreed 
-- that all the due dates can be shifted by 90 days. Determine the new due dates.
SELECT reference,
       due_date + interval '90 days' AS new_date   
FROM invoices
ORDER BY new_date, reference;


-- Extract the name of artists that start with a vowel ('A', 'E', 'I', 'O', 'U'). No duplicates!!
SELECT DISTINCT name
FROM artists
WHERE LEFT(name,1) IN  ('A', 'E', 'I', 'O', 'U')
ORDER BY name
LIMIT 7;


-- The songs table shows id of a song, the name of the song, the observed date, and the number of times it has been 
-- played as playbacks in millions per year. A preview of the songs table is shown.
-- Determine the total number of playbacks per year and compare that to the all time number of playbacks.
/*
id	    name	            date_observed	playbacks
3qyX4g	Soon We'll Be Found	2004-10-03	    35
04sN26	Bored	            2017-03-30	    77
*/
SELECT
	DATE_PART('year', date_observed) as yearly,
  	SUM(playbacks) AS yearly_playbacks,
    -- here we use subquery, since it won't be affected by the group by
  	(SELECT SUM(playbacks) FROM songs) AS total_playbacks
FROM songs
GROUP BY yearly
ORDER BY yearly
LIMIT 7;


-- How many missing values are in the price column of the wine table?
SELECT count(*)
FROM wine
where price is null


-- The tracks table contains information on a variety of tracks, including the artist_id and song popularity.
-- Return the artist_id and average song popularity for artists who have an average song popularity greater than 50.

/* tracks
| id     | name                | artist_id | popularity  |          
|--------|---------------------|-----------|-------------|
| 3qyX4g | Soon We'll Be Found | 5WUlDf    |    35       |
| 04sN26 | Bored               | 6qqNVT    |    77       |
| 4cCXPF | On Top Of The World | 53Xhwf    |    1        |
*/

select artist_id, avg(popularity)
from tracks
group by artist_id
having avg(popularity) > 50  -- when using groupby aggregation, use HAVING instead of WHERE
ORDER BY artist_id
LIMIT 5;


-- Using the artists and tracks tables, return the name of every artist and the count of songs they perform from the 
--tracks table.
/*
--artists
| id     | followers | name          | popularity |
|--------|-----------|---------------|------------|
| 1uNFoZ | 44606973  | Justin Bieber | 100        |
| 06HL4z | 38869193  | Taylor Swift  | 98         |
| 3TVXtA | 54416812  | Drake         | 98         |

--tracks
| id     | name                | artist_id | release_date |
|--------|---------------------|-----------|--------------|
| 3qyX4g | Soon We'll Be Found | 5WUlDf    | 2004-10-03   |
| 04sN26 | Bored               | 6qqNVT    | 2017-03-30   |
| 4cCXPF | On Top Of The World | 53Xhwf    | 2021-04-09   |
*/
SELECT artists.name AS artist_name, COUNT(tracks.name)
FROM tracks 
LEFT JOIN artists 
ON tracks.artist_id = artists.id 
GROUP BY artists.name  -- groupby name of the artist, since we will aggregate it with COUNT(tracks.name) function
ORDER BY COUNT(*) DESC 
LIMIT 5;


-- aliasing
select sal as salary, comm as commission 
from emp;

select * -- this is needed because where clasue is executed before subquery select
from (select sal as salary, comm as commission from emp) x   -- inline view aliased as x
where salary < 5000;

select ename||' works as a '||job as msg
from emp
where deptno = 10   -- CLARK works as a MANAGER

-- random set of records
select ename, job from emp order by random() limit 5;

select coalesce(comm, 0) from emp; -- replaces null with 0

select empno, deptno, sal, ename, job
from emp
order by deptno, sal desc;  -- deptno will order asc, since it was not mentioned

select ename, job from emp
order by substr(job,length(job)-1)  -- sort by last two characters of job

-- order by deptno (numerical)
select data from V order by
replace(data, 
        replace(
                translate(data, '0123456789', '##########'), '#', ''), '');

-- null values are smaller than 0 so they will be last here (no sorting for them)
select ename, sal, comm, from emp order by 3;


-- Case Practice
select ename, sal,
       case when sal <= 2000 then 'underpaid'
            when sal >= 4000 then 'overpaid'
            else 'ok'
       end as status  -- name of new column alias is status
from emp;

SELECT date, id, home_goal, away_goal
FROM match 
WHERE season = '2013/2014';

SELECT date, id, home_goal, away_goal
FROM match 
WHERE season = '2013/2014' AND home_team_goal > away_team_goal;

-- non null comm sorted asc, all nulls last
select ename, sal, comm 
from (
    select ename, sal, comm,
    case when comm is null then 0 else 1 end as is_null from emp
) x
order by is_null desc, comm

CASE WHEN x = 1 THEN 'a'      
     WHEN x = 2 THEN 'b'     
     ELSE 'c' ENDAS new_column

SELECT id, home_goal, away_goal, 
       CASE WHEN home_goal > away_goal THEN 'Home Team Win'
       WHEN home_goal < away_goal THEN 'Away Team Win'
       ELSE 'Tie' END AS outcome 
FROM match 
WHERE season = '2013/2014';

-- for barca only
SELECT 
	m.date,
	t.team_long_name AS opponent,
	case when m.home_goal > m.away_goal then 'Barcelona win!'
         when m.home_goal < m.away_goal then 'Barcelona loss :(' 
         else 'Tie' end as outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
WHERE m.hometeam_id = 8634; 

-- Select matches where Barcelona was the away team
SELECT  
	m.date,
	t.team_long_name AS opponent,
	case when m.home_goal < m.away_goal then 'Barcelona win!'
         WHEN m.home_goal > m.away_goal then 'Barcelona loss :(' 
         else 'Tie' end as outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;


select date, home_team_id, awayteam_id,
       case when home_team_id = 8455 and home_goal > away_goal then 'Chelsea home win!'
            when awayteam_id = 8455 and home_goal < away_goal then 'Chelsea away win'
            else 'loss or tie!' end as outcome
from match
where home_team_id = 8455 or awayteam_id = 8455;


SELECT 
	date,
	case when hometeam_id = 8634 then 'FC Barcelona' else 'Real Madrid CF' end as home,
	case when awayteam_id = 8634 then 'FC Barcelona' else 'Real Madrid CF' end as away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634) AND (awayteam_id = 8633 OR hometeam_id = 8633);


SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	case when home_goal > away_goal and hometeam_id = 8634 then 'Barcelona win!'
         WHEN home_goal > away_goal and hometeam_id = 8633 then 'Real Madrid win!'
         WHEN home_goal < away_goal and awayteam_id = 8634 then 'Barcelona win!'
         WHEN home_goal < away_goal and awayteam_id = 8633 then 'Real Madrid win!'
         else 'Tie!' end as outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634) AND (awayteam_id = 8633 OR hometeam_id = 8633);

-- In R or Python, you have the ability to calculate a SUM of logical values (i.e., TRUE/FALSE) directly. 
-- In SQL, you have to convert these values into 1 and 0 before calculating a sum.

-- Sum the total records in each season where the home team won in each country
select c.name as country,
        sum(case when m.season = '2012/2013' and m.home_goal > m.away_goal then 1 else 0 end) as matches_2012_2013,
        sum(case when m.season = '2013/2014' and m.home_goal > m.away_goal then 1 else 0 end) as matches_2013_2014,
        sum(case when m.season = '2014/2015' and m.home_goal > m.away_goal then 1 else 0 end) as matches_2014_2015
from country as c
join match as m
on c.id = m.country_id
group by country;

SELECT 
    c.name AS country,
    -- Count the home wins, away wins, and ties in each country
	count(case when m.home_goal > m.away_goal THEN m.id END) AS home_wins,
	count(case when m.home_goal < m.away_goal THEN m.id END) AS away_wins,
	count(case when m.home_goal = m.away_goal THEN m.id END) AS ties
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

SELECT 
	c.name AS country,
	round(avg(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	round(avg(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;


-- Sub query practice

SELECT date, home_goal, away_goal
FROM  matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_goal + away_goal) > (SELECT 3 * AVG(home_goal + away_goal)
FROM matches_2013_2014); 

SELECT team_long_name, team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id not in (select DISTINCT hometeam_id  FROM match);

-- how many matches in each country where there where more than 10 total goals
SELECT
    c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
inner join (SELECT country_id, id 
           FROM match
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;

SELECT country, date, home_goal, away_goal
FROM
	(SELECT c.name AS country, m.date, m.home_goal, m.away_goal, (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subquery
WHERE total_goals >= 10;

select date,
       (home_goal+away_goal) as goals,
       (home_goal+away_goal) - (select avg(home_goal+away_goal) from match where season = '2011/2012') as diff
from match
where season = '2011/2012';

SELECT 
    l.name AS league,
    ROUND(avg(m.home_goal + m.away_goal), 2) AS avg_goals,
    (SELECT ROUND(avg(home_goal + away_goal), 2) FROM match WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY league;

SELECT 
    m.stage,
    ROUND(avg(m.home_goal + m.away_goal),2) AS avg_goals,
    ROUND((SELECT avg(home_goal + away_goal) FROM match WHERE season = '2012/2013'), 2) AS overall
FROM match AS m
WHERE season = '2012/2013'
GROUP BY stage;

-- SELECT avg(home_goal + away_goal) FROM match WHERE season = '2012/2013'  : total avg of goals for the season
-- get all stages in 2012/2013 season where avg goals was higher than the general avg goals
SELECT 
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goals
FROM 
	(SELECT stage, avg(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	s.avg_goals > (SELECT avg(home_goal + away_goal) FROM match WHERE season = '2012/2013');

SELECT 
    s.stage,
    ROUND(s.avg_goals, 2) AS avg_goal,
    (select avg(home_goal + away_goal) from match WHERE season = '2012/2013') AS overall_avg
FROM 
	(SELECT stage, avg(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT avg(home_goal + away_goal) FROM match WHERE season = '2012/2013');


-- Correlated Subqueries Practice
-- examine matches with scores that are extreme outliers for each country
SELECT 
	main.country_id,
    main.date,
    main.home_goal, 
    main.away_goal
FROM match AS main
WHERE 
	(home_goal + away_goal) > 
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         -- the join clause basically works as the group by of a normal sub query
         WHERE main.country_id = sub.country_id);

-- how many matches happened per season, country where there was > 5 goals by a team
select country_id, season, count(id) as matches
from (select country_id, season, id from match where home_goal >=5 or away_goal >=5) as subquery
group by country_id, season;

-- Common Table Expression Practice
with match_list as (
    select country_id, (home_goal+away_goal) as goals
    from match
    where id in (
        select id 
        from match
        where season = '2013/2014' and extract(month from date) =  08))

select l.name, avg(match_list.goals)
from league as l
left join match_list
on l.id = match_list.country_id
group by l.name;

-- get name of both teams playing in a match
-- subquery way
select m.date, home.hometeam, away.awayteam, m.home_goal, m.away_goal
from match as m
left join (
    select match.id, team.team_long_name as hometeam
    from match
    left join team
    on match.hometeam_id= team.team_api_id) as home
on m.id = home.id

left join (
    select match.id, team.team_long_name as awayteam
    from match
    left join team
    on match.awayteam_id= team.team_api_id) as away
on m.id = away.id

-- correlated subqueries way (slower than join)
SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     m.home_goal,
     m.away_goal
FROM match AS m;

-- CTE way (similar to subquery but easier to read)
with home as (
    select m.id, m.date, t.team_long_name as hometeam, mn.home_goal
    from match as m
    left join team as t
    on m.hometeam_id = team.team_api_id),
away as (
    select m.id, m.date, t.team_long_name as awayteam, m.away_goal
    from match as m
    left join team as t
    on m.hometeam_id = team.team_api_id)
-- since we have all data, there is no need to rejoin to match table again
SELECT 
	home.date, home.hometeam, away.awayteam, home.home_goal, away.away_goal
from home 
inner join away
on home.id = away.id


-- Sliding Windows Practice
-- rank football leagues based on their seasonal averge goal
select 
    l.name as league, 
    avg(m.home_goal+m.away_goal) as avg_goals,
    rank() over(order by avg(m.home_goal+m.away_goal)) as league_rank
from league as l
left join match as m
on l.id = m.country_id
where season='2011/2012'
group by l.name
order by rank;

SELECT 
    l.name AS league,
    avg(m.home_goal + m.away_goal) AS avg_goals,
    rank() over(order by avg(m.home_goal + m.away_goal) desc) AS league_rank
FROM league AS l
LEFT JOIN match AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
order by league_rank;

select
    date,
    season,
    home_goal,
    away_goal,
    case when hometeam_id = 8673 then 'home' else 'away' end as warsaw_location,
    -- avg of home goals in a particular season (same season as the game's row)
    avg(home_goal) over(PARTITION by season) as season_homeavg,
    avg(away_goal) over(PARTITION by season) as season_awayavg
from match 
where hometeam_id = 8673 or awayteam_id = 8673
order by (home_goal+away_goal) desc;

SELECT 
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home' 
        ELSE 'away' END AS warsaw_location,
         -- partition by each season and each month
    avg(home_goal) over(partion by season, extract(month from date)) as season_mo_home,
    avg(away_goal) over(partition by season, extract(month from date)) as season_mo_away
from match
where hometeam_id = 8673 or awayteam_id = 8673
order by (home_goal+away_goal) desc;

select 
    date, 
    home_goal, 
    away_goal, 
    sum(home_goal) over(order by date rows between unbounded preceding and current row) as running_total,
    avg(home_goal) over(order by date rows between unbounded preceding and current row) as running_avg
from match
where hometeam_id = 9908 and season = '2011/2012';


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

-- DATABASE DESIGN
/*	Write SQL queries (ideally in MySQL format) that create DB schema to store people
located all over the world, data to store:
    a. Name
    b. Surname
    c. Citizenship
then Write SQL queries (ideally in MySQL format) that add parents information (mother,father) to existing schema */
			 
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