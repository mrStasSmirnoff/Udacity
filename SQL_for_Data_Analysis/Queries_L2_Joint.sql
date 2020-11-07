-- Write Your First JOIN
-- Below we see an example of a query using a JOIN statement. Let's discuss what the different clauses of this query mean.
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- As we've learned, the SELECT clause indicates which column(s) of data you'd like to see in the output. The FROM clause indicates the first table from which we're pulling data,
-- and the JOIN indicates the second table. The ON clause specifies the column on which you'd like to merge the two tables together. Try running this query yourself below.

-- Additional Information
-- If we wanted to only pull individual elements from either the orders or accounts table, we can do this by using the exact same information in the FROM and ON statements. However, in your SELECT statement, you will need to know how to specify tables and columns in the SELECT statement:
-- a) The table name is always before the period.
-- b) The column you want from that table is always after the period.
-- Ex1: For example, if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns, we can do this with the following query:
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Ex2: This query only pulls two columns, not all the information in these two tables. Alternatively, the below query pulls all the columns from _ both_ the 'accounts' and 'orders' table.
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Ex3: And the first query you ran pull all the information from only the orders table:
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- First JOIN
-- 1) Try pulling all the data from the accounts table, and all the data from the orders table.
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON accounts.id = orders.id;

-- 2) Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.
SELECT orders.standard_qty, orders.gloss_qty, orders.gloss_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON accounts.id = orders.id;

-- Keys
-- Primary Key (PK)
-- A primary key is a unique column in a particular table. This is the first column in each of our tables. Here, those columns are all called id, but that doesn't necessarily have to be the name.
-- It is common that the primary key is the first column in our tables in most databases.

-- Foreign Key (FK)
-- A foreign key is a column in one table that is a primary key in a different table


-- JOIN more than  TWO Tables
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id


-- 1) Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel
-- for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.
SELECT accounts.name, accounts.primary_poc,web_events.channel, web_events.occurred_at
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
WHERE accounts.name IN ("Walmart");

-- 2) Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name,
-- and the account name. Sort the accounts alphabetically (A-Z) according to account name.
-- Have to use aliasing, since in the result we have 3 columns with the "same" name: "name"
SELECT region.name region, sales_reps.name rep, accounts.name account
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
ORDER BY accounts.name;

-- 3) Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns:
-- region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
SELECT region.name region,accounts.name account, orders.total_amt_usd/(orders.total + 0.01)  unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id;

-- INNER/OUTER JOINS, along with LEFT/RIGHT Joins

-- useful video: https://www.youtube.com/watch?v=4edRxFmWUEw
-- INNER JOINs
-- Notice every JOIN we have done up to this point has been an INNER JOIN. That is, we have always pulled rows only if they exist as a match across two tables. Our new JOINs (LEFT/RIGHT) allow
-- us to pull rows that might only exist in one of the two tables. This will introduce a new data type called NULL.

-- OUTER JOINS
-- The last type of join is a full outer join. This will return the inner join result set, as well as any unmatched rows from either of the two tables being joined. Again this returns rows
-- that do not match one another from the two tables. The use cases for a full outer join are very rare.
-- details: https://www.w3resource.com/sql/joins/perform-a-full-outer-join.php
-- usability cases: https://stackoverflow.com/questions/2094793/when-is-a-good-situation-to-use-a-full-outer-join

--  Last Check, basically just a bunch of small requests

-- 1) Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns:
-- the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT region.name region, sales_reps.name rep, accounts.name account
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE region.name = 'Midwest'
ORDER BY accounts.name;

-- 2) Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S
-- and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to account name.
SELECT region.name region, sales_reps.name rep, accounts.name account
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE (region.name = 'Midwest') AND (sales_reps.name LIKE 'S%')
ORDER BY accounts.name;

-- 3) Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K
-- and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to account name.
SELECT region.name region, sales_reps.name rep, accounts.name account
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
JOIN accounts
ON accounts.sales_rep_id = sales_reps.id
WHERE (region.name = 'Midwest') AND (sales_reps.name LIKE '% K%')
ORDER BY accounts.name;

--4) Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results
-- if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01
-- to the denominator here is helpful total_amt_usd/(total+0.01).
SELECT region.name region, accounts.name account, orders.total_amt_usd/(orders.total + 0.01)  unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE orders.standard_qty > 100;

-- 5) Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results
-- if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price.
-- Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT region.name region, accounts.name account, orders.total_amt_usd/(orders.total + 0.01)  unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE (orders.standard_qty > 100) AND (orders.poster_qty > 50)
ORDER BY unit_price;

-- 6) Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results
-- if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price.
-- Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT region.name region, accounts.name account, orders.total_amt_usd/(orders.total + 0.01)  unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id
WHERE (orders.standard_qty > 100) AND (orders.poster_qty > 50)
ORDER BY unit_price DESC;

-- 7) What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels.
-- You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT accounts.name account, web_events.channel channel
FROM accounts
JOIN web_events
ON accounts.id = web_events.account_id
WHERE accounts.id = '1001';

-- 8) Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT orders.occurred_at, accounts.name, orders.total, orders.total_amt_usd
FROM accounts
JOIN orders
ON orders.account_id = accounts.id
WHERE orders.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY orders.occurred_at DESC;
