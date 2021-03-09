-- WINDOW FUNCTIONS
-- The OVER() clause offers significant benefits over subqueries in select -- namely, your queries will run faster

select 
    date,
    (home_gaol + away_goal) as goals,
    -- instead of writing subquery to calculate the aggregate, user OVER()
    AVG(home_goal+away_goal) over() as overall_goal
from match
where season = '2011/2012';


select
date,
(home_goal+away_goal) as goals,
-- which rank to give to a match based on number of goals
RANK() OVER(order by home_goal+away_goal desc) as goal_rank
from match
where season = '2011/2012';


select 
m.id, 
c.name as country, 
m.season, 
m.home_goal, 
m.away_goal,
-- this will make aggregation over the whole dataset (all the rows of this query)
avg(m.home_goal+ m.away_goal) over() as overall_avg
from match as m
left join country as c on m.country_id = c.id;


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


-- Partition by
avg(home_goal) over(partion by season)

select 
    date, 
    (home_goal+away_goal) as goals, 
    avg(home_goal+away_goal) over(partion by season) as overall_avg
from match;


select
    date,
    season,
    home_goal,
    away_goal,
    case when hometeam_id = 8673 then 'home'
         else 'away' end as warsaw_location,
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


-- Sliding Windows

select 
    date, 
    home_goal, 
    away_goal, 
    -- all home goals from first row until current one sumed up
    sum(home_goal) over(order by date rows between unbounded preceding and current row) as running_total
from match
where hometeam_id = 8456 and season = '2011/2012';


select 
    date, 
    home_goal, 
    away_goal, 
    sum(home_goal) over(order by date rows between unbounded preceding and current row) as running_total,
    avg(home_goal) over(order by date rows between unbounded preceding and current row) as running_avg
from match
where hometeam_id = 9908 and season = '2011/2012';


SELECT 
	date,
	home_goal,
	away_goal,
    SUM(home_goal) OVER(ORDER BY date DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_total,
    AVG(home_goal) OVER(ORDER BY date DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_avg
FROM match
WHERE awayteam_id = 9908 AND season = '2011/2012';
