-- LEFT/ RIGHT

-- 1) In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is
-- provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(a.website,3) AS domain, COUNT(*) num_companies
FROM accounts a
GROUP BY 1;

-- 2) There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution
-- of company names that begin with each letter (or number).
SELECT LEFT(UPPER(a.name),1) first_letter, COUNT(*) num_companies
FROM accounts a
GROUP BY 1
ORDER BY 2 DESC;

-- 3) Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter.
-- What proportion of company names start with a letter?
SELECT a.name,
CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
CASE WHEN LEFT(UPPER(a.name), 1)  IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
FROM accounts a;

WITH t1 AS (SELECT a.name,
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num,
            CASE WHEN LEFT(UPPER(a.name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
            FROM accounts a)

SELECT SUM(num) nums, SUM(letter) letters
FROM t1;
-- There are 350 company names that start with a letter and 1 that starts with a number. This gives a ratio of 350/351 that are company names that start with a letter or 99.7%.

--4) Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?
SELECT a.name,
CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS num,
CASE WHEN LEFT(UPPER(a.name), 1)  IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS letter
FROM accounts a;


WITH t1 AS (SELECT a.name,
            CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowel,
            CASE WHEN LEFT(UPPER(a.name), 1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS other
            FROM accounts a)

SELECT SUM(vowel) vowels, SUM(other) others
FROM t1;
-- There are 80 company names that start with a vowel and 271 that start with other characters. Therefore 80/351 are vowels or 22.8%. Therefore, 77.2% of company names do not start with vowels.


-- POSITION & STRPOS

-- POSITION takes a character and a column, and provides the index where that character is for each row. The index of the first position is 1 in SQL.
-- If you come from another programming language, many begin indexing at 0. Here, you saw that you can pull the index of a comma as POSITION(',' IN city_state).
-- STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different as shown here: STRPOS(city_state, ',').


-- 1) Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT primary_poc
FROM accounts;


SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

-- 2) Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;


-- CONCAT

-- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
      RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(name, ' ')) last_name,
      name
FROM accounts;

WITH t1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(name, ' ')) last_name,
            name
            FROM accounts)
SELECT first_name, last_name, CONCAT(first_name,'.', last_name,'@',name,'.com')
FROM t1;

-- You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address.
-- See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1.
--  Some helpful documentation is here (replace( 'abcdefabcdef', 'cd', 'XX'))
WITH t1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(name, ' ')) last_name,
            name
            FROM accounts)
SELECT first_name, last_name, CONCAT(first_name,'.', last_name,'@',REPLACE(name,' ',''),'.com')
FROM t1;

-- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase),
-- then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name,
-- the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

WITH t1 AS (SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) first_name,
            RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(name, ' ')) last_name,
            name
            FROM accounts)
SELECT first_name, last_name, CONCAT(first_name,'.', last_name,'@',REPLACE(name,' ',''),'.com'), LEFT(LOWER(first_name),1) || RIGHT(LOWER(first_name),1) || LEFT(LOWER(last_name),1) || RIGHT(LOWER(last_name),1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '') AS password
FROM t1;

-- CAST (change the column type)

-- Custom dataset is given
SELECT date original_date, (SUBSTR(date,7,4) || '-' || LEFT(date,2) || '-' || SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data
LIMIT 10;

SELECT date original_date, (SUBSTR(date,7,4) || '-' || LEFT(date,2) || '-' || SUBSTR(date, 4, 2)) new_date,
                          (SUBSTR(date,7,4) || '-' || LEFT(date,2) || '-' || SUBSTR(date, 4, 2)) ::DATE new_Format_date
FROM sf_crime_data
LIMIT 10;


-- COALESCE (Returns the first non-null value passed for each row)
SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
