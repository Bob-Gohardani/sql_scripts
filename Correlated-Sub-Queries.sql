-- Correlated Sub Queries
-- Correlated subqueries are evaluated in SQL "once per row" of data retrieved 

select c.name as country,
AVG(m.home_goal + m.away_goal) as avg_goals
from country as c
left join match as m
on c.id = m.country_id
group by country;


-- same as above, but with a correlated subquery
select c.name as country, 
       (select AVG(m.home_goal + m.away_goal) from match as m where m.country_id = c.id) as avg_goals
from country as c
group by country;


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


-- what was the highest scoring match for each country, in each season?
select main.country_id, main.date, main.home_goal, main.away_goal
from match as main 
where (home_goal + away_goal) = 
      (select max(sub.home_goal+sub.away_goal) from match as sub where main.country_id = sub.country_id and main.season = sub.season);


-- Nested Subqueries
select 
    season, 
    -- max goals for each season
    max(home_goal+away_goal) as max_goals,
    -- overall max goals
    (select max(home_goal+away_goal) from match) as overall_max_goal,
    -- max goals in july
    (select max(home_goal+away_goal) from match where id in 
        (select id from match where extract(month from date) = 07)) as july_max_goal
from match
group by season;

-- how many matches happened per season, country where there was > 5 goals by a team
select country_id, season, count(id) as matches
from (select country_id, season, id from match where home_goal >=5 or away_goal >=5) as subquery
group by country_id, season;


-- join the above query with country table to get the name of each nation, then group by it to get avg of scores by each
SELECT
	c.name AS country,
	avg(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
left join (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  GROUP BY country_id, season) as outer_s
ON c.id = outer_s.country_id
GROUP BY country;


-- Common Table Expression (CTE)

-- Set up your CTE
with match_list as (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)

SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


with match_list as (
    select 
        l.name as league,
        m.date,
        m.home_goal,
        m.away_goal,
        (m.home_goal + m.away_goal) as total_goals
    from match as m
    -- each country has only one league
    left join league as l on m.country_id = l.id)

select league, date, home_goal, away_goal
from match_list
where total_goals >= 10;


with match_list as (
    select
        country_id,
        (home_goal+away_goal) as goals
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
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
from home 
inner join away
on home.id = away.id