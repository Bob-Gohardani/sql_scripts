-- here we see amount of items sold for every row and also the total of items sold from first day adding up to today
-- OVER uses aggregation without using groupBy
select standard_qty,
       sum(standard_qty) over (order by occured_at) as running_total
from demo.orders;


-- here we do same thing as above but we start from zero at beginning of each month
-- PARTITION BY divides the data into smaller chunks
select standard_qty,
       DATE_TRUNC('month', occured_at),
       sum(standard_qty) over (PARTITION BY DATE_TRUNC('month', occured_at) order by occured_at) as running_total
from demo.orders;


-- if we remove order by each row of each month will have same value (total for the whole month)
select standard_qty,
       DATE_TRUNC('month', occured_at),
       sum(standard_qty) over (PARTITION BY DATE_TRUNC('month', occured_at)) as running_total
from demo.orders;


--  create a running total of standard_amt_usd (in the orders table) over order time with no date truncation
select standard_amt_usd,
    sum(standard_amt_usd) over (order by occured_at) as running_total
from orders;


-- same as above, but in yearly partitions
SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;


-- row_number() function orders resulting rows by number starting from 1
select id,
       account_id,
       occured_at,
       row_number() over (order by occured_at) as row_num
from demo.orders;


-- here we partition the results based on account_id, so each time this number changes, we start from 1 again
select id,
       account_id,
       occured_at,
       row_number() over (partition by account_id order by occured_at) as row_num
from demo.orders;


-- rank() is similar to row_number() but here if two rows have same occurred_at value, we give them same rank number,
-- but then jumps to next rank 1,2,2,4
select id,
       account_id,
       occured_at,
       rank() over (partition by account_id order by occured_at) as row_num
from demo.orders;


-- Select id, account_id, and total variable from the orders table, then create a column called total_rank that ranks
-- this total amount of paper ordered (from highest to lowest) for 'each account' using a partition
-- in here the row with highest amount in each account_id gets the rank 1
select id,
       account_id,
       total,
       RANK() over (partition by account_id order by total desc) as total_rank
from orders;


-- aggregate methods with window functions : sum(), count(), avg(), min(), max()
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;


-- what happens when you remove "order by column" from a window function??

-- The ORDER BY clause is one of two clauses integral to window functions. The ORDER and PARTITION define what is referred
-- to as the “window”—the ordered subset of data over which calculations are made. Removing ORDER BY just leaves an unordered
-- partition; in our query's case, each column's value is simply an aggregation (e.g., sum, count, average, minimum, or maximum)
-- of all the standard_qty values in its respective account_id.


-- using aliases for easier readability, WINDOW main_window as ...
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER main_window AS dense_rank,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG(standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW main_window as (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at));

-- comparing a row to previous row, LAG(), LEAD() functions
-- the source table that we get our data for lag/lead is the subquery that we call 'sub'
-- lag() : pulls from previous rows
-- lead() : pulls from following rows
-- in example below we get the lag and lead from 1 row in each direction, and each row is a unique standard_sum value because we are windowing over this column
select account_id,
       standard_sum,
       lag(standard_sum) over (order by standard_sum) as lag,
       lead(standard_sum) over (order by standard_sum) as lead
from (
    select account_id,
           sum(standard_qty) as standard_sum
    from demo.orders
    group by 1) sub;


-- we can extend the above query to compare value of each row to next and previous row
select account_id,
       standard_sum,
       lag(standard_sum) over (order by standard_sum) as lag,
       lead(standard_sum) over (order by standard_sum) as lead,
       standard_sum - lag(standard_sum) over (order by standard_sum) as lag_difference,
       standard_sum - lead(standard_sum) over (order by standard_sum) as lead_difference
from (
    select account_id,
           sum(standard_qty) as standard_sum
    from demo.orders
    group by 1) sub;


-- you want to determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.
-- You'll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so.
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders
 GROUP BY 1
) sub;


-- Percentiles, N-tiles
-- here we compare each row's standard_qty to all other rows then decide at which n-tile it is located, for ntile(4) we have : 1,2,3,4 tiles
select id,
       account_id,
       occured_at,
       standard_qty,
       ntile(4) over (order by standard_qty) as quartile,
       ntile(5) over (order by standard_qty) as quintile,
       ntile(100) over (order by standard_qty) as percentile
from demo.orders
order by standard_qty desc;

-- determine the largest orders (in terms of quantity) a specific customer has made to encourage them to order more similarly sized large orders.
-- You only want to consider the NTILE for that customer's account_id

-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased,
-- and one of four levels in a standard_quartile column
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders
 ORDER BY account_id DESC;


-- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty
-- paper purchased, and one of two levels in a gloss_half column.
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) over (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC;

-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased,
-- and one of 100 levels in a total_percentile column.
SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) over (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC;