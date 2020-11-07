-- Lesson 1

-- Order by
-- The ORDER BY statement allows us to sort our results using the data in any column. If you are familiar with Excel or Google Sheets, using ORDER BY is similar to sorting a sheet using a column.
--  A key difference, however, is that using ORDER BY in a SQL query only has temporary effects, for the results of that query, unlike sorting a sheet by column in Excel or Sheets.


-- 1) Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- 2) Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- 3) Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- Order by II
-- We can ORDER BY more than one column at a time. When you provide a list of columns in an ORDER BY command, the sorting occurs using the leftmost column in your list first,
-- then the next column from the left, and so on. We still have the ability to flip the way we order using DESC.

-- 1) Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount
-- (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id , total_amt_usd DESC;

-- 2) Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account
--  ID (in ascending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;


-- Where
-- Using the WHERE statement, we can display subsets of tables based on conditions that must be met. You can also think of the WHERE command as filtering the data.
-- Common symbols used in WHERE statements include:
-- '>' (greater than)
-- '<' (less than)
-- '>=' (greater than or equal to)
-- '<=' (less than or equal to)
-- '=' (equal to)
-- '!=' (not equal to)

-- 1) Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
-- Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- 2) Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;


-- WHERE to non-numerical data
-- The WHERE statement can also be used with non-numeric data. We can use the '=' and '!=' operators here.

-- 1) Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website,primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';


-- Derived columns
-- Creating a new column that is a combination of existing columns is known as a derived column (or "calculated" or "computed" column).
-- Usually you want to give a name, or "alias," to your new column using the AS keyword.
-- Example
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

-- 1) Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order.
-- Limit the results to the first 10 orders, and include the id and account_id fields.
SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

-- 2) Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd.
-- (Try to do this without using the total column.) Display the id and account_id fields also.
SELECT id, account_id,
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;


-- Introduction to Logical Operators
-- In the next concepts, you will be learning about Logical Operators. Logical Operators include:

-- 'LIKE'
-- This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.

-- 'IN'
-- This allows you to perform operations similar to using WHERE and =, but for more than one condition.

-- 'NOT'
-- This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.

-- 'AND & BETWEEN'
-- These allow you to combine operations where all combined conditions must be true.

-- 'OR'
-- This allow you to combine operations where at least one of the combined conditions must be true.


-- LIKE
-- The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %.
-- The % tells us that we might want any number of characters leading up to a particular set of characters or following a certain set of characters,
-- as we saw with the google syntax above. Remember you will need to use single quotes for the text you pass to the LIKE operator, because of this lower and uppercase letters are not the same
--  within the string.

-- 1) All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

-- 2) All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';

-- 3) All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';

-- IN
-- The IN operator is useful for working with both numeric and text columns. This operator allows you to use an '=', but for more than one item of that particular column.
-- We can check one, two or many column values for which we want to pull data, but all within the same query. In the upcoming concepts, you will see the OR operator that would also allow us
-- to perform these tasks, but the IN operator is a cleaner way to write these queries.

-- 1) Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name,primary_poc,sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

-- 2) Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords');


-- NOT
-- The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE. By specifying NOT LIKE or NOT IN, we can grab all of the rows
-- that do not meet a particular criteria.

-- 1) Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name,primary_poc,sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart','Target','Nordstrom');

-- 2) Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods
SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

-- 3) Use the accounts table to find:
-- a) All the companies whose names do not start with 'C'
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%'

-- b) All companies whose names do not contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';

-- c) All companies whose names do not end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE '%s';

-- AND / BETWEEN

-- AND
-- The AND operator is used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND,
-- you will need to specify the column you are interested in looking at. You may link as many statements as you would like to consider at the same time. This operator works with all of the
-- operations we have seen so far including arithmetic operators (+, *, -, /). LIKE, IN, and NOT logic can also be linked together using the AND operator.


-- BETWEEN
-- BETWEEN Operator
-- Sometimes we can make a cleaner statement using BETWEEN than we can using AND. Particularly this is true when we are using the same column for different parts of our AND statement.
-- In the previous video, we probably should have used BETWEEN.

-- 1) Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

-- 2) Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

-- 3) When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? Figure out the answer to this important question by writing a query that
-- displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. Then look at your output to see if the BETWEEN operator included the begin and end values or not.
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty DESC;

-- 4) Use the web_events table to find all information regarding individuals who were contacted via the 'organic' or 'adwords' channels, and started their account at any point in 2016,
-- sorted from newest to oldest.
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;

-- OR
-- Similar to the AND operator, the OR operator can combine multiple statements. Each time you link a new statement with an OR, you will need to specify the column you are interested in looking at.
--  You may link as many statements as you would like to consider at the same time. This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /),
-- LIKE, IN, NOT, AND, and BETWEEN logic can all be linked together using the OR operator.

-- 1) Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-- 2) Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.
SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

-- 3) Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
           AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
           AND primary_poc NOT LIKE '%eana%');
