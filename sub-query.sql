-- Sub Queries

select column
from (select column_2 from table) as subquery;


--where home goals are higher than the averge that we have
select home_goal from match
where home_goal > (select AVG(home_goal) from match);


SELECT date, home_goal, away_goal
FROM  matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_goal + away_goal) > (SELECT 3 * AVG(home_goal + away_goal)
FROM matches_2013_2014); 


SELECT 
	team_long_name,
	team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id not in (select DISTINCT hometeam_id  FROM match);


SELECT
	team_long_name,
	team_short_name
FROM team
-- Filter for teams with 8 or more home goals
WHERE team_api_id in
	  (SELECT hometeam_id 
       FROM match
       WHERE home_goal >= 8);


select team, home_avg
from (select 
        t.team_long_name as team, 
        AVG(m.home_goal) as home_avg
      from match as m
      left join team as t
      on m.hometeam_id = t.team_api_id
      where season = '2011/2012'
      group by team) as subquery
order by home_avg desc
limit 3;

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


SELECT
    country,
    date,
    home_goal,
    away_goal
FROM
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subquery
WHERE total_goals >= 10;


select date,
       (home_goal+away_goal) as goals,
       (home_goal+away_goal) - 
       (select avg(home_goal+away_goal)
       from match
       where season = '2011/2012') as diff
from match
where season = '2011/2012';


SELECT 
    l.name AS league,
    ROUND(avg(m.home_goal + m.away_goal), 2) AS avg_goals,
    (SELECT ROUND(avg(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY league;

-- When writing queries in SELECT, it's important to remember that filtering the main query does not filter the subquery and vice versa.

SELECT
	name AS league,
	ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
	ROUND(AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'), 2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY l.name;


SELECT 
    m.stage,
    ROUND(avg(m.home_goal + m.away_goal),2) AS avg_goals,
    ROUND((SELECT avg(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'), 2) AS overall
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
    ROUND(s.avg_goals,2) AS avg_goal,
    (select avg(home_goal + away_goal) from match WHERE season = '2012/2013') AS overall_avg
FROM 
	(SELECT
	 stage,
         avg(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT avg(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');
