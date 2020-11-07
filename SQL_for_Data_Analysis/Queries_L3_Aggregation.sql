-- AGGREGATION FUNCTIONS : COUNT, SUM, MIN, MAX, AVG etc.

-- COUNT. We start with COUNTing the Number of Rows in a Table
SELECT COUNT(*)
FROM accounts;

-- SUM
-- Unlike COUNT, you can only use SUM on numeric columns. However, SUM will ignore NULL values, as do the other aggregation functions you will see in the upcoming lessons.
-- Aggregation Questions (SUM):

-- 1) Find the total amount of 'poster_qty' paper ordered in the orders table.
SELECT SUM(orders.poster_qty) AS total_poster_count
FROM orders;

-- 2) Find the total amount of 'standard_qty' paper ordered in the orders table
SELECT SUM(orders.standard_qty) AS total_standart_count
FROM orders;

-- 3) Find the total dollar amount of sales using the 'total_amt_usd' in the orders table.
SELECT SUM(orders.total_amt_usd ) AS total_dollar_count
FROM orders;

-- 4) Find the total amount spent on 'standard_amt_usd' and 'gloss_amt_usd' paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT orders.standard_amt_usd + orders.gloss_amt_usd AS total_standard_gloss
FROM orders;

-- 5) Find the 'standard_amt_usd' per unit of 'standard_qty paper'. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(orders.standard_amt_usd) / SUM(orders.standard_qty) AS standard_price_per_unit
FROM orders;


-- MIN/MAX/AVG
-- Questions: MIN, MAX, & AVERAGE

-- 1) When was the earliest order ever placed? You only need to return the date.
SELECT MIN(orders.occurred_at)
FROM orders;

-- 2) Try performing the same query as in question 1 without using an aggregation function.
SELECT orders.occurred_at
FROM orders
ORDER BY orders.occurred_at
LIMIT 1;

-- 3) When did the most recent (latest) web_event occur?
SELECT MAX(web_events.occurred_at)
FROM web_events;

-- 4) Try to perform the result of the previous query without using an aggregation function.
SELECT web_events.occurred_at
FROM web_events
ORDER BY web_events.occurred_at DESC
LIMIT 1;

-- 5) Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
-- Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss,
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd,
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

-- 6) Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on
-- all orders?
SELECT COUNT(*)
FROM orders
-- returns us 6912, hence:

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
-- Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. This is the average of 2483.16 and 2482.55. This gives the median of 2482.855.
-- This obviously isn't an ideal way to compute. If we obtain new orders, we would have to change the limit. SQL didn't even calculate the median for us.
-- The above used a SUBQUERY, but you could use any method to find the two necessary values, and then you just need the average of them.


-- GROUP BY

-- GROUP BY can be used to aggregate data within subsets of the data. For example, grouping for different accounts, different regions, or different sales representatives.
-- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
-- The GROUP BY always goes between WHERE and ORDER BY.
-- ORDER BY works like SORT in spreadsheet software.

-- GROUP BY Questions:
-- 1) Which account (by name) placed the earliest order? Your solution should have the account name and the date of the orde
SELECT accounts.name, orders.occurred_at
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
ORDER BY orders.occurred_at
LIMIT 1;

-- 2) Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT SUM(orders.total_amt_usd) total_sales, accounts.name account
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY account;

-- 3) Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
-- Your query should return only three values - the date, channel, and account name.
SELECT web_events.occurred_at, web_events.channel, accounts.name
FROM web_events
JOIN accounts
ON accounts.id = web_events.account_id
ORDER BY web_events.occurred_at DESC
LIMIT 1;

-- 4) Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT web_events.channel, COUNT(*)
FROM web_events
GROUP BY web_events.channel;

-- 5) Who was the primary contact associated with the earliest web_event?
SELECT accounts.primary_poc, web_events.occurred_at
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
ORDER BY web_events.occurred_at
LIMIT 1;

-- 6) What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT MIN(orders.total_amt_usd) smallest_order, accounts.name account
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY account
ORDER BY smallest_order;

-- 7) Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

-- GROUP BY II
-- You can GROUP BY multiple columns at once, as we showed here. This is often useful to aggregate across a number of different segments.
-- The order of columns listed in the ORDER BY clause does make a difference. You are ordering the columns from left to right.

-- 1) For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the
--  average spent on each of the paper types.
SELECT accounts.name, AVG(poster_qty) poster, AVG(standard_qty) standart, AVG(gloss_qty) glossy
FROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY accounts.name;

-- 2) For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on
-- each paper type.
SELECT a.name, AVG(o.poster_amt_usd) poster, AVG(o.standard_amt_usd) standart, AVG(o.gloss_amt_usd) glossy
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- 3) Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep,
-- the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) num_events
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

-- 4) Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name,
-- the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;


-- DISTINCT
-- 1) Use DISTINCT to test if there are any accounts associated with more than one region.
-- The below two queries have the same number of resulting rows (351), so we know that every account is associated with only one region. If each account was associated with more than one region,
-- the first query should have returned more rows than the second query.

SELECT a.id as "account id", r.id as "region id", a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;

-- 2) Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

SELECT DISTINCT id, name
FROM sales_reps;


-- HAVING
-- HAVING is the “clean” way to filter a query that has been aggregated, but this is also commonly done using a subquery. Essentially, any time you want to perform a WHERE on an element
-- of your query that was created by an aggregate, you need to use HAVING instead.
-- Questions:

-- 1) How many of the sales reps have more than 5 accounts that they manage?
SELECT s.name, s.id, COUNT(*) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.name, s.id
HAVING COUNT(*) > 5
ORDER BY num_accounts;

-- 2) How many accounts have more than 20 orders?
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

-- 3) Which account has the most orders?
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
ORDER BY num_orders DESC
LIMIT 1;

-- 4) How many accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

-- 5) How many accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

-- 6) Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
ORDER BY total_spent DESC
LIMIT 1;

-- 7) Which account has spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id,a.name
ORDER BY total_spent
LIMIT 1;

-- 8) Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.name, a.id, w.channel, COUNT(*) use_of_channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY a.name, a.id, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

-- 9) Which account used facebook most as a channel?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

-- 10) Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;


-- DATE (YYYY--MM--DD)

-- DATE_TRUNC
-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. Common trunctions are 'day', 'month', and 'year'. Here is a great blog post by
-- Mode Analytics on the power of this function: https://mode.com/blog/date-trunc-sql-timestamp-function-count-on/

-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order.
-- Rather you are grouping for certain components regardless of which year they belonged in.

-- For additional functions you can use with dates, check out the documentation here(https://www.postgresql.org/docs/9.1/functions-datetime.html),
-- but the DATE_TRUNC and DATE_PART functions definitely give you a great start!
-- You can reference the columns in your select statement in GROUP BY and ORDER BY clauses with numbers that follow the order they appear in the select statement.
-- Questions:

-- 1) Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) ord_year, SUM(orders.total_amt_usd) total_spent
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 2) Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
-- Sinice in 2013 there is only 12th month shown, and in 2017 only 1st, we wont take them into consideretion.
SELECT DATE_PART('month', occurred_at) ord_month, SUM(orders.total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

-- 3) Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 4) Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
-- To make a fair comparison from one month to another 2017 and 2013 data were removed.
SELECT DATE_PART('month', occurred_at) ord_year, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;


-- 5) In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', occurred_at) ord_date, SUM(orders.gloss_amt_usd) gloss_tot_spend
FROM orders
JOIN accounts
ON accounts.id = orders.account_id
WHERE accounts.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC;


-- CASE

-- The CASE statement always goes in the SELECT clause.
-- CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.
-- You can make any conditional statement using any conditional operator (like WHERE) between WHEN and THEN. This includes stringing together multiple conditional statements using AND and OR.
-- You can include multiple WHEN statements, as well as an ELSE statement again, to deal with any unaddressed conditions.

-- 1) Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $500 or more,
-- or less than $500.
SELECT o.account_id, o.total,
CASE WHEN o.total > 500 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders o;

-- 2) Write a query to display the number of orders in each of three categories, based on the 'total' amount of each order. The three categories are:  'At Least 2000',
-- 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN o.total >= 2000 THEN 'At Least 2000'
    WHEN o.total >= 1000 AND o.total < 2000  THEN 'Between 1000 and 2000'
    ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders o
GROUP BY 1;

-- 3) We would like to understand 3 different branches of customers based on the amount associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first
SELECT a.name, SUM(o.total_amt_usd),
  CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top' WHEN SUM(o.total_amt_usd) > 100000 THEN 'Middle' ELSE 'low' END As customer_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2;


-- 4) We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017.
-- Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT a.name, SUM(o.total_amt_usd),
  CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'Top' WHEN SUM(o.total_amt_usd) > 100000 THEN 'Middle' ELSE 'low' END As customer_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2;

-- 5) We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders,
-- and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(*) num_orders,
  CASE WHEN COUNT(*) > 200 THEN 'top' ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;

-- 6) The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table.
SELECT s.name, COUNT(*) num_orders, SUM(o.total_amt_usd) total_spent,
  CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) >750000 THEN 'top'
  WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) >500000 THEN 'middle'
  ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 3 DESC;
