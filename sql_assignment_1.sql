--1.Create Database as ecommerce 

CREATE DATABASE ecommerce

/* 2.Create 4 tables (gold_member_users, users, sales, product)
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

---- 5.Count all the records of all four tables using single query
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

--6.What is the total amount each customer spent on ecommerce company

SELECT sales."user_name",SUM(price) AS Total_spent
   FROM sales right join product on sales.product_id=product.product_id
 GROUP BY sales."user_name"

 -- 7.Find the distinct dates of each customer visited the website: 

 SELECT 