/*Finding for each date the number of different products sold and their names. 
table name = product_details
Column names: (sell_date, product) */

CREATE DATABASE product

-- Creating table product_details

CREATE TABLE product_details(sell_date date,product varchar(20))

-- Inserting data into product_details

INSERT INTO product_details VALUES('2020-05-30', 'Headphones'),
('2020-06-01','Pencil'),
('2020-06-02','Mask'),
('2020-05-30','Basketball'),
('2020-06-01','Book'),
('2020-06-02', ' Mask '),
('2020-05-30','T-Shirt')

--Finding for each date the number of different products sold and their names

SELECT
    sell_date,
    COUNT(product) AS num_sold,
    STRING_AGG(product, ', ') AS product_list
FROM
    product_details
GROUP BY
    sell_date
