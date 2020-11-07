-- FULL OUTER JOIN
-- A common application of this is when joining two tables on a timestamp. Let’s say you’ve got one table containing the number of item 1 sold each day, and another containing the number
-- of item 2 sold. If a certain date, like January 1, 2018, exists in the left table but not the right, while another date, like January 2, 2018, exists in the right table but not the left.
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
--If you wanted to return unmatched rows only, which is useful for some cases of data assessment, you can isolate them by adding the following line to the end of the query:
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

-- Usage cases: https://stackoverflow.com/questions/2094793/when-is-a-good-situation-to-use-a-full-outer-join
-- write a query with FULL OUTER JOIN to fit the above described Parch & Posey scenario (selecting all of the columns in both of the relevant tables, 'accounts' and 'sales_reps')
SELECT *
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
-- unmatched rows (there are no unmatched rows)
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;

-- Inequality JOINs
-- write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name
-- A bit more explanation: https://stackoverflow.com/questions/26080187/sql-string-comparison-greater-than-and-less-than-operators/26080240#26080240
-- and here: https://dev.mysql.com/doc/refman/5.5/en/comparison-operators.html
SELECT a.name account_name, a.primary_poc poc_name, s.name sales_rep_name
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name;


-- Self JOINs
-- One of the most common use cases for self JOINs is in cases where two events occurred, one after another. As you may have noticed in the previous video,
-- using inequalities in conjunction with self JOINs is common.
-- Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the same interval analysis except for the web_events table. Also:
-- *change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
-- *add a column for the channel variable in both instances of the table in your query
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at;


-- UNIONs
-- SQL's two strict rules for appending data:
-- *Both tables must have the same number of columns.
-- *Those columns must have the same data types in the same order as the first table.
-- Appending Data via UNION (UNION only appends distinct values.)
-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.
SELECT *
    FROM accounts

UNION ALL

SELECT *
  FROM accounts;
-- The result is two accounts tables appended vertically.

-- Pretreating Tables before doing a UNION
-- Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney.
-- Inspect the results then answer the subsequent quiz.

SELECT *
    FROM accounts
    WHERE name = 'Walmart'
UNION ALL

SELECT *
  FROM accounts
  WHERE name = 'Disney';


-- Performing Operations on a Combined Dataset
-- Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and name it double_accounts.
-- Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name.

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC
