--Creating the table sales_data

CREATE TABLE sales_data (product_id int, sale_date date,quantity_sold int)

--Inserting sample data into the table

INSERT INTO sales_data (product_id, sale_date, quantity_sold)
VALUES
    (1, '2022-01-01', 20),
    (2, '2022-01-01', 15),
    (1, '2022-01-02', 10),
    (2, '2022-01-02', 25),
    (1, '2022-01-03', 30),
    (2, '2022-01-03', 18),
    (1, '2022-01-04', 12),
    (2, '2022-01-04', 22)

--Assigning rank by partition based on product_id and find the latest product_id sold

SELECT product_id, sale_date
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY sale_date DESC) AS rnk
    FROM 
        sales_data
) AS ranked_sales
WHERE 
    rnk = 1

--Retrieve the quantity_sold value from a previous row and compare the quantity_sold

SELECT 
    product_id,
    sale_date,
    quantity_sold,
    quantity_sold - LAG(quantity_sold) OVER (PARTITION BY product_id ORDER BY sale_date) AS change_in_quantity
FROM 
    sales_data

--Partition based on product_id and return the first and last values in ordered set

SELECT 
    product_id,
    MIN(quantity_sold) AS first_quantity_sold,
    MAX(quantity_sold) AS last_quantity_sold
FROM 
    sales_data
GROUP BY 
    product_id