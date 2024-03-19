--1.Creating Database as ecommerce 

CREATE DATABASE ecommerce

/* 2.Creating 4 tables (gold_member_users, users, sales, product)
under the above database(ecommerce) */

CREATE TABLE gold_members(userid int,"user_name" char(20),signup_date date)
CREATE TABLE users(userid int,"user_name" varchar(20),signup_date date)
CREATE TABLE sales(userid int,"user_name" varchar(20),created_date date,product_id int)
CREATE TABLE product(product_id int,product_name varchar(20),price int)

--3.Insert the values provided above with respective datatypes

INSERT INTO gold_members(userid,"user_name",signup_date) VALUES (001,'John','09-22-2017'), (002,'Mary','04-21-2017')

INSERT INTO users(userid,"user_name",signup_date) VALUES (001,'John','09-02-2014'), (003,'Michel','01-15-2015'), (002,'Mary','04-11-2014')

INSERT INTO sales(userid,"user_name",created_date,product_id) VALUES
(001,'John','04-19-2017',2), (002,'Mary','12-18-2019',1), (003,'Michel','07-20-2020',3), 
(001,'John','10-23-2019',2), (001,'John','03-19-2018',3), (002,'Mary','12-20-2016',2), 
(001,'John','11-09-2016',1), (001,'John','05-20-2016',3), (002,'Michel','09-24-2017',1),
(001,'John','03-11-2017',2), (001,'John','03-11-2016',1), (002,'Mary','11-10-2016',1),
(002,'Mary','12-07-2017',2), (003,'Michel','05-20-2020',1), (003,'Michel','01-20-2020',3)

INSERT INTO product(product_id,product_name,price) VALUES (1,'Mobile',980), (2,'Ipad',870), (3,'Laptop',330)

---- 4.Count all the records of all four tables using single query
SELECT
    'gold_member_users' AS table_name,
    COUNT(*) AS record_count
FROM gold_members
UNION ALL
SELECT
    'users' AS table_name,
    COUNT(*) AS record_count
FROM users
UNION ALL
SELECT
    'sales' AS table_name,
    COUNT(*) AS record_count
FROM sales
UNION ALL
SELECT
    'product' AS table_name,
    COUNT(*) AS record_count
FROM product;

--5.Total amount each customer spent on ecommerce company

SELECT sales."user_name",SUM(price) AS Total_spent
   FROM sales right join product on sales.product_id=product.product_id
 GROUP BY sales."user_name"

 -- 6.Distinct dates of each customer visited the website:

SELECT DISTINCT s.created_date AS date, u.user_name AS customer_name
FROM sales s INNER JOIN users u
ON s.userid=u.userid

-- 7.First product purchased by each customer using 3 tables(users, sales, product)

WITH RankedPurchases AS (
    SELECT 
        u.user_name AS customer_name, 
        p.product_name AS product_purchased,
        ROW_NUMBER() OVER (PARTITION BY u.userid ORDER BY s.created_date) AS purchase_rank
    FROM users u
    INNER JOIN sales s ON u.userid = s.userid
    INNER JOIN product p ON s.product_id = p.product_id
)
SELECT customer_name, product_purchased
FROM RankedPurchases
WHERE purchase_rank = 1

/*8.Most purchased item of each customer and how many times the customer has purchased it:
output should have 2 columns count of the items as item_count and customer name*/

SELECT COUNT(*) AS item_count, user_name AS customer_name
FROM sales
GROUP BY user_name

--9.Customer who is not the gold_member_user

SELECT u.user_name AS customer_name
FROM users u LEFT JOIN gold_members g ON u.userid=g.userid
WHERE g.userid IS NULL

--10.Amount spent by each customer when he was the gold_member user

SELECT 
    g.user_name AS customer_name, 
    SUM(p.price) AS total_amount_spent
FROM 
    gold_members g
INNER JOIN 
    sales s ON g.userid = s.userid
    AND s.created_date >= g.signup_date -- Consider only sales made after becoming a gold member
INNER JOIN 
    product p ON s.product_id = p.product_id
GROUP BY 
    g.user_name;

--11.Finding the Customers names whose name starts with M

SELECT user_name
FROM users
WHERE user_name LIKE 'M%'

--12.Finding the Distinct customer Id of each customer

SELECT DISTINCT userid AS customer_id, user_name
FROM users

--13.Changing the Column name from product table as price_value from price
EXEC sp_rename 'product.price','price_value','COLUMN'

--14.Changing the Column value product_name � Ipad to Iphone from product table

UPDATE product
SET product_name = 'Iphone'
WHERE product_name = 'Ipad'

--15.Changing the table name of gold_member_users to gold_membership_users

EXEC sp_rename 'gold_members','gold_memberships_users'

/*16.Creating a new column as Status in the table crate above gold_membership_users
the Status values should be 2 Yes and No 
if the user is gold member, then status should be Yes else No.*/

ALTER TABLE gold_membership_users
ADD status VARCHAR(3) DEFAULT 'No'
+++++++++++
UPDATE gold_membership_users
SET status = CASE
     WHEN signup_date IS NOT NULL THEN 'Yes'
     ELSE 'No'
END;
++++++
SELECT u.user_name,COALESCE(g.status, 'No') AS status
FROM users u LEFT JOIN gold_membership_users g ON u.userid = g.userid

/*17.Delete the users_ids 1,2 from users table and roll the back changes
once both the rows are deleted one by one mention the result when performed roll back*/

BEGIN TRANSACTION

DELETE FROM users
WHERE userid = 1

DELETE FROM users
WHERE userid = 2

SELECT * FROM users

ROLLBACK

--18.Insert one more record as same (3,'Laptop',330) as product table

INSERT INTO product VALUES(3,'Laptop',330)

SELECT * FROM product

--19.Query to find the duplicates in product table

SELECT product_id,product_name, COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id,product_name
HAVING count(*)>1
