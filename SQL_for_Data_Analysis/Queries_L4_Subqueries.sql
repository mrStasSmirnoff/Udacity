-- Your First Subquery
-- Whenever we need to use existing tables to create a new table that we then want to query again, this is an indication that we will need to use some sort of subquery

-- First we write a so-called subquerie and see whether is works or not
SELECT DATE_TRUNC('day', occurred_at) as day, channel, COUNT(*) as event_count
FROM web_events
GROUP BY day, channel
ORDER BY day;

-- Now use it as a SUB-QUERY insude the main query.
SELECT channel, AVG(event_count) as avg_event_count
FROM
(SELECT DATE_TRUNC('day', occurred_at) as day, channel, COUNT(*) as event_count
FROM web_events
GROUP BY day, channel
ORDER BY day) sub
GROUP BY 1
ORDER BY 2 DESC;


-- Subqueries Part II
-- In the first subquery we wrote, we created a table that you could then query again in the FROM statement. However, if you are only returning a single value,
-- you might use that value in a logical statement like WHERE, HAVING, or even SELECT - the value could be nested within a CASE statement.

-- We start with the small subquerie to find the earliest order month
SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders

-- Now we add it to the query
SELECT AVG(standard_qty) avg_std, AVG(poster_qty) avg_pst , AVG(gloss_qty) avg_gls
  FROM orders
  WHERE DATE_TRUNC('month', occurred_at) =
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


SELECT SUM(total_amt_usd) total
  FROM orders
  WHERE DATE_TRUNC('month', occurred_at) =
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);


-- Subquery mania

-- 1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- use this result as a Subquery
SELECT region_name, MAX(total_amt) total_amt
FROM (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
  FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1,2
  ORDER BY 3 DESC) t1
GROUP BY 1;

-- So now we got the biggest sales in each of 4 regoins, and now we just need to match this data in order to get the sales rep names
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM (SELECT region_name, MAX(total_amt) total_amt
      FROM (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM region r
              JOIN sales_reps s
              ON r.id = s.region_id
              JOIN accounts a
              ON s.id = a.sales_rep_id
              JOIN orders o
              ON a.id = o.account_id
              GROUP BY 1,2
              ORDER BY 3 DESC) t1
      GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt


-- 2) For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
-- Build the basics
SELECT  r.name region_name, SUM(o.total_amt_usd) total_amt, COUNT(*) orders
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1;

-- Now we need the region with the MAX, hence
SELECT MAX(total_amt)
FROM (SELECT  r.name region_name, SUM(o.total_amt_usd) total_amt, COUNT(*) orders
  FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1) sub;

-- Finally, we want to pull the total orders for the region with this amount:
SELECT  r.name region_name, COUNT(o.total) orders
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
  SELECT MAX(total_amt)
  FROM (SELECT  r.name region_name, SUM(o.total_amt_usd) total_amt, COUNT(*) orders
  FROM region r
  JOIN sales_reps s
  ON r.id = s.region_id
  JOIN accounts a
  ON s.id = a.sales_rep_id
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1) sub);


-- 3) For the name of the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
-- we want to find the account that had the most standard_qty paper. The query here pulls that account, as well as the total amount:
SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Now we need to pull all account with more ( > ) total sales  than obtained result
SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total
                                FROM (SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                                FROM accounts a
                                JOIN orders o
                                ON o.account_id = a.id
                                GROUP BY 1
                                ORDER BY 2 DESC
                                LIMIT 1 ) inner_tab);


-- This gives a list  of all the accounts (3) with more total orders. We can get the count with just another simple subquery.
SELECT COUNT(*)
FROM (SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total
                                FROM (SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
                                FROM accounts a
                                JOIN orders o
                                ON o.account_id = a.id
                                GROUP BY 1
                                ORDER BY 2 DESC
                                LIMIT 1 ) inner_tab) ) counter_tab;

-- Returns simply 161


-- 4) For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

-- we first want to pull the customer with the most spent in lifetime value.
SELECT a.id, a.name, SUM(total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- We want to look at the number of events on each channel
SELECT a.id, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id and a.id = (SELECT id
                                  FROM (SELECT a.id, a.name, SUM(total_amt_usd) tot_spent
                                  FROM orders o
                                  JOIN accounts a
                                  ON a.id = o.account_id
                                  GROUP BY 1,2
                                  ORDER BY 3 DESC
                                  LIMIT 1) inner_tab )
GROUP BY 1,2
ORDER BY 3 DESC;

-- Another way to do so but with HAVING
SELECT a.id, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1,2
HAVING a.id = (SELECT id
                FROM (SELECT a.id, a.name, SUM(total_amt_usd) tot_spent
                FROM orders o
                JOIN accounts a
                ON a.id = o.account_id
                GROUP BY 1,2
                ORDER BY 3 DESC
                LIMIT 1) inner_tab )
ORDER BY 3 DESC;

-- 5) What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT a.id, a.name, SUM(total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

-- Next thing is to take average
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 3 DESC
      LIMIT 10) sub;


-- 6) What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.

--we want to pull the average of all accounts in terms of total_amt_usd:
SELECT AVG(o.total_amt_usd) avg_all
FROM orders o

-- Pull acounts with more than average amounts
SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all FROM orders o);

-- Average of these values
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
      FROM orders o
      GROUP BY 1
      HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all FROM orders o)) sub;


--  Common Table Expression (CTE) / WITH
-- We can rewrite each subquery that we wrote before in more compact way with WITH. Now lets rewrite queries from the previous task , but now with WITH.

--1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
-- We should start with the total_amt_usd totals associated with each sales rep and region they are located.
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1,2
ORDER BY 3 DESC;

--Now use this query as a subquery but with WITH expression now.
WITH t1 AS (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM region r
            JOIN sales_reps s
            ON r.id = s.region_id
            JOIN accounts a
            ON s.id = a.sales_rep_id
            JOIN orders o
            ON o.account_id = a.id
            GROUP BY 1,2
            ORDER BY 3 DESC),
    t2 AS (
            SELECT region_name, MAX(total_amt) total_amt
            FROM t1
            GROUP BY 1)

SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;


-- 2) For the region with the largest sales total_amt_usd, how many total orders were placed?
-- First we need to pull the total_amt_usd for each region.
SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1;

-- Then we just want the region with the max amount from this table. Pull the max using a subquery
WITH t1 AS (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1)
SELECT MAX(total_amt)
FROM t1;

-- Finally, we want to pull the total orders for the region with this amount:
WITH t1 AS (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY 1),
    t2 AS (
            SELECT MAX(total_amt)
            FROM t1)

SELECT r.name, COUNT(*) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2)

--3) For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?
-- We want to find the account that had the most standard_qty paper
SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Now we use this to pull all the accounts with more total sales:
WITH t1 AS (SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
            FROM orders o
            JOIN accounts a
            ON o.account_id = a.id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1)

SELECT a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total FROM t1);

-- This is now a list of all the accounts with more total orders. We can get the count with just another simple subquery
WITH t1 AS (SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
            FROM orders o
            JOIN accounts a
            ON o.account_id = a.id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1),
    t2 AS (SELECT a.name
            FROM orders o
            JOIN accounts a
            ON o.account_id = a.id
            GROUP BY 1
            HAVING SUM(o.total) > (SELECT total FROM t1))

SELECT COUNT(*)
FROM t2;


-- 4) For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
-- We first want to pull the customer with the most spent in lifetime value.
SELECT a.id, a.name account_name, SUM(o.total_amt_usd) tot_spent
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- We want to look at the number of events on each channel this company had, which we can match with just the id
WITH t1 AS (SELECT a.id, a.name account_name, SUM(o.total_amt_usd) tot_spent
            FROM web_events w
            JOIN accounts a
            ON w.account_id = a.id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY 1,2
            ORDER BY 3 DESC
            LIMIT 1)

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;


-- 5) What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
-- First, we just want to find the top 10 accounts in terms of highest total_amt_usd.
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;

-- Now just simply take average
WITH t1 AS (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY a.id, a.name
            ORDER BY 3 DESC
            LIMIT 10)

SELECT AVG(tot_spent)
FROM t1;


-- 6) What is the lifetime average amount spent in terms of total_amt_usd for only the companies that spent more than the average of all orders.
-- We want to pull the average of all accounts in terms of total_amt_usd:
SELECT AVG(o.total_amt_usd) avg_all
FROM orders o

WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;
