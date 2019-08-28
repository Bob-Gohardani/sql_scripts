-- for optimizations we reduce the amount of calculations that a query needs to perform
-- the bigger the table size, the slower the query
-- joins between tables slows down queries
-- aggregation functions slow down queries
-- distinct count() is significantly slower than count() since it has to compare all rows to find unique ones.


-- opt1 : filtering the data to only include the rows that you actually need
-- if you have a big dataset, do explarotary queires on a small portion, then do the final query on the whole dataset
select *
from demo.orders
where occured_at >= '2016-01-01' and occured_at < '2016-05-31'

-- here the limit part is "useless" as limit clause runs AFTER sum() aggregation
select sum(poster_qty) as sum_poster_qty
from demo.orders
where occured_at >= '2016-01-01' and occured_at < '2016-05-31'
group by 1
limit 10;

-- instead of limit, get data from a limited subquery
select sum(poster_qty) as sum_poster_qty
from (select * from demo.orders limit 10) sub
where occured_at >= '2016-01-01' and occured_at < '2016-05-31'
group by 1;


-- opt2 : reduce number of rows evaluated during join (make it less complicated)
select accounts.name,
       count(*) as web_events
    from demo.accounts accounts
    join demo.web_events_full events
    on events.account_id = accounts.id
order by 1
group by 2;

-- optimize it by aggregating the second table before the join
select a.name,
       sub.web_events
    from (select account_id, count(*) as web_events from demo.web_events_full group by 1) sub
    join demo.accounts a
    on a.id = sub.account_id
order by 2;

-- opt3 : adding EXPLAIN to start of query shows how it is executed
explain
select *
from demo.orders
where occured_at >= '2016-01-01' and occured_at < '2016-05-31';


-- joining subqueries
-- what we are doing here is joining every row for one day from one table to another table (data explosion)
-- so if each has 20 rows for a given day, we would get 400 rows!!
select date_trunc('day', o.occurred_at) as date,
       count(distinct a.sales_rep_id) as active_sales_reps,
       count(distinct o.id) as orders,
       count(distinct we.id) as web_visits,
    from demo.accounts a
    join demo.orders o
    on o.account_id = a.id
    join demo.web_events_full we
    on date_trunc('day', we.occured_at) = date_trunc('day', o.occurred_at)
group by 1
order by 1 desc;


-- use subqueries to lower the amount of calculations
select coalesce(orders.date, web_events.date) as date, 
       orders.active_sales_reps,
       orders.orders,
       web_events.web_visits
from 
    
    (select date_trunc('day', o.occurred_at) as date,
        count(a.sales_rep_id) as active_sales_reps, -- since we count before joining on dates, there is no need for distinct
        count(o.id) as orders,
        from demo.accounts a
        join demo.orders o
        on o.account_id = a.id
    group by 1 ) orders

full join 

    (select date_trunct('day', we.occured_at) as date,
            count(we.id) as web_visits -- since we count before joining on dates, there is no need for distinct
        from demo.web_events_full we
    group by 1 ) web_events
-- because we did the aggergation before, there are far less rows here for joining
on web_events.date = orders.date
order by 1 desc;

-- If a group of columns are defined as a primary key, they are called a composite key. 
-- That means the combination of values in these columns will uniquely identify the rows in the table.
CREATE TABLE IF NOT EXISTS customer_transactions (
    customer_id int, 
    store_id int, 
    spent numeric,
    PRIMARY KEY (customer_id, store_id)
);







