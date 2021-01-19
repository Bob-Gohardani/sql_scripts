-- CASE Statement

SELECT user_id, SUM(sales) 
FROM sales_data
WHERE user_id BETWEEN 300 AND 400 
GROUPBY user_id;


SELECT c.country, c.team, SUM(m.goals)
FROM countries AS c 
LEFTJOIN matches AS m
ON c.team_id = m.home_team_id
WHERE m.year > 1990
GROUPBY c.country, c.team;


SELECT l.name AS league,
       COUNT(m.country_id) as matches
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
GROUPBY l.name;


SELECT date, id, home_goal, away_goal
FROM match 
WHERE season = '2013/2014';


SELECT date, id, home_goal, away_goal
FROM match 
WHERE season = '2013/2014'
      AND home_team_goal > away_team_goal;


CASE WHEN x = 1 THEN 'a'      
     WHEN x = 2 THEN 'b'     
     ELSE 'c' ENDAS new_column

SELECT id, home_goal, away_goal, 
       CASE WHEN home_goal > away_goal THEN 'Home Team Win'
       WHEN home_goal < away_goal THEN 'Away Team Win'
       ELSE 'Tie' END AS outcome 
FROM match 
WHERE season = '2013/2014';


SELECT
	team_long_name,
	team_api_id
FROM teams_germany
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');


SELECT 
	CASE when hometeam_id = 10189 then 'FC Schalke 04'
         when hometeam_id = 9823 then 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
GROUP BY home_team;


SELECT 
	date,
	case when home_goal > away_goal then 'Home win!'
        when home_goal < away_goal then 'Home loss :(' 
        else 'Tie' end as outcome
FROM matches_spain;


SELECT 
	m.date,
	t.team_long_name AS opponent, 
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
         WHEN m.home_goal < m.away_goal THEN 'Home loss :('
         ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t
-- we join on 'awayteam_id' because we want to show name of the oponents
ON m.awayteam_id = t.team_api_id;

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
       case when home_team_id = 8455 and home_goal > away_goal
                 then 'Chelsea home win!'
        when awayteam_id = 8455 and home_goal < away_goal
                then 'Chelsea away win'
        else 'loss or tie!' end as outcome
from match
where home_team_id = 8455 or awayteam_id = 8455;


SELECT 
	date,
	case when hometeam_id = 8634 then 'FC Barcelona' 
        else 'Real Madrid CF' end as home,
	case when awayteam_id = 8634 then 'FC Barcelona' 
        else 'Real Madrid CF' end as away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);


SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	case when home_goal > away_goal and hometeam_id = 8634 then 'Barcelona win!'
        WHEN home_goal > away_goal and hometeam_id = 8633 then 'Real Madrid win!'
        WHEN home_goal < away_goal and awayteam_id = 8634 then 'Barcelona win!'
        WHEN home_goal < away_goal and awayteam_id = 8633 then 'Real Madrid win!'
        else 'Tie!' end as outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);


SELECT *
FROM table
WHERE 
    CASE WHEN a > 5 THEN 'Keep'
         WHEN a <= 5 THEN 'Exclude' END = 'Keep';       


SELECT
	team_long_name,
	team_api_id
FROM teams_italy
-- Filter for team name
WHERE team_long_name = 'Bologna';


-- contains 
SELECT 
	season,
	date,
	case when hometeam_id = 9857 and home_goal > away_goal then 'Bologna Win'
		when awayteam_id = 9857 and away_goal > home_goal then 'Bologna Win' 
		end AS outcome
FROM matches_italy;


-- Exclude games not won by Bologna
SELECT season, date, home_goal, away_goal
FROM matches_italy
WHERE case when hometeam_id = 9857 and home_goal > away_goal then 'Bologna Win'
		when awayteam_id = 9857 and away_goal > home_goal then 'Bologna Win' 
		end IS NOT NULL;  -- IS NOT NULL

select season,
        count(case when home_team_id= 8650 and home_goal > away_goal then id end) as home_wins
        count (case when awayteam_id = 8650 and away_goal > home_goal then id end) as away_wins
from match
group by season;


SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	count(case when m.season = '2012/2013' 
        	then m.id ELSE Null END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
group by country;


SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	count(case when m.season = '2012/2013' then m.id end) AS matches_2012_2013,
	count(case when m.season = '2013/2014' then m.id end) AS matches_2013_2014,
	count(case when m.season = '2014/2015' then m.id end) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
group by country;


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