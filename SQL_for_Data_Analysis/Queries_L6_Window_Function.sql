-- A window function call always contains an OVER clause directly following the window function's name and argument(s).
-- This is what syntactically distinguishes it from a regular function or aggregate function. The OVER clause determines exactly how the rows of the query are split up for processing by the
-- window function. The PARTITION BY list within OVER specifies dividing the rows into groups, or partitions, that share the same values of the PARTITION BY expression(s).
-- For each row, the window function is computed across the rows that fall into the same partition as the current row.
-- EXAMPLE: SELECT depname, empno, salary, avg(salary) OVER (PARTITION BY depname) FROM empsalary;
-- Documentation: https://www.postgresql.org/docs/9.1/tutorial-window.html

-- A window function performs a calculation across a set of table rows that are somehow related to the current row. This is comparable to the type of calculation that can be done with an
-- aggregate function. But unlike regular aggregate functions, use of a window function does not cause rows to become grouped into a single output row — the rows retain their separate identities.
-- Behind the scenes, the window function is able to access more than just the current row of the query result.

-- Creating a Running Total Using Window Functions
SELECT standard_amt_usd, SUM(o.standard_amt_usd) OVER (ORDER BY o.occurred_at) AS running_total
FROM orders o;

-- Creating a Partitioned Running Total Using Window Functions
SELECT standard_amt_usd, DATE_TRUNC('year', occurred_at) as year,
       SUM(o.standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY o.occurred_at) AS running_total
FROM orders o;

-- Also quite useful example of Window fucntions are given here : https://stackoverflow.com/questions/561836/oracle-partition-by-keyword


-- ROW_NUMBER & RANK
-- Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest)
--  for each account using a partition. Your final table should have these four columns.
SELECT o.id, o.account_id, o.total,
      RANK() OVER (PARTITION BY o.account_id ORDER BY o.total DESC) AS total_rank
FROM orders o;


-- Aggregates in Window Functions with and without ORDER BY
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

-- Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below.
-- ""The easiest way to think about this - leaving the ORDER BY out is equivalent to "ordering" in a way that all rows in the partition are "equal" to each other.
-- Indeed, you can get the same effect by explicitly adding the ORDER BY clause like this: ORDER BY 0 (or "order by" any constant expression), or even, more emphatically, ORDER BY NULL.""
-- Evaluate your new query, compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.
SELECT id,
       account_id,
       standard_qty,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders;


-- Aliasing of WINDOWS functions
-- Initial QUERY
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders;
-- Now with aliasing
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window  AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window  AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window  AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window  AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window  AS max_total_amt_usd
FROM orders
WINDOW account_year_window  AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));

-- LAG and LEAD functions
-- You can use LAG and LEAD functions whenever you are trying to compare the values in adjacent rows or rows that are offset by a certain number.
-- Example: Comparing a Row to Previous Row

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders
 GROUP BY 1
 ) sub


-- Percentiles
-- Are done through NTILE window func.

-- Example: Percentiles with Partitions
--You can use partitions with percentiles to determine the percentile of a specific subset of all rows. Imagine you're an analyst at Parch & Posey and you want to determine the largest orders
-- (in terms of quantity) a specific customer has made to encourage them to order more similarly sized large orders. You only want to consider the NTILE for that customer's account_id.
-- 1) Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id,
-- the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.
SELECT o.account_id, o.occurred_at, o.standard_qty,
        NTILE(4) OVER (PARTITION BY account_id ORDER BY o.standard_qty) AS standart_quartile

FROM orders o
ORDER BY account_id DESC;

-- 2) Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id,
-- the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.
SELECT o.account_id, o.occurred_at, o.gloss_qty,
        NTILE(2) OVER (PARTITION BY account_id ORDER BY o.gloss_qty) AS gloss_half

FROM orders o
ORDER BY account_id DESC;

-- 3) Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id,
-- the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
SELECT o.account_id, o.occurred_at, o.total_amt_usd,
        NTILE(100) OVER (PARTITION BY account_id ORDER BY o.total_amt_usd) AS total_percentile

FROM orders o
ORDER BY account_id DESC;
