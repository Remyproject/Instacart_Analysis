-- Create a database fro the project
Use Sql_project;

-- Create and upload all tables to the database

CREATE TABLE PRODUCT (product_id INT, product_name VARCHAR(256),	aisle_id INT,	department_id INT);

BULK INSERT PRODUCT
FROM 'C:\Users\HP\Desktop\SQL PRO\product.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');

	
create table ORDERS ( order_id int,	user_id int, eval_set varchar(10), order_number int, order_dow int,	order_hour_of_day Int,	days_since_prior_order int );

BULK INSERT ORDERS
FROM 'C:\Users\HP\Desktop\SQL PRO\orders.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');

CREATE TABLE DEPARTMENTS (department_id INT, department VARCHAR(20));

BULK INSERT DEPARTMENTS
FROM 'C:\Users\HP\Desktop\SQL PRO\departments.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');

CREATE TABLE AISLES (aisle_id INT, aisle VARCHAR(40));

BULK INSERT AISLES
FROM 'C:\Users\HP\Desktop\SQL PRO\aisles.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');

CREATE TABLE order_product_prior (order_id int,	product_id int,	add_to_cart_order int,	reordered int
);

BULK INSERT order_product_prior
FROM 'C:\Users\HP\Desktop\SQL PRO\order_products__prior.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');

CREATE TABLE order_product_train (order_id int,	product_id int,	add_to_cart_order int,	reordered int
);

BULK INSERT order_product_train
FROM 'C:\Users\HP\Desktop\SQL PRO\order_products__train.csv'
WITH (FORMAT = 'CSV'
	, FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '0x0a');


-- DATA CLEANING AND DATA EXPLORATION

-- Checking for missing Value

SELECT COUNT(*) AS MissingValues
FROM ORDERS
WHERE days_since_prior_order IS NULL;

-- Remove duplicate rows from tables, if any, to ensure data integrity.

DELETE FROM PRODUCT
WHERE product_id NOT IN (
    SELECT MIN(product_id)
    FROM PRODUCT
    GROUP BY product_name
);
DELETE FROM PRODUCT
WHERE product_id NOT IN (
    SELECT MIN(product_id)
    FROM PRODUCT
    GROUP BY product_name;

UPDATE ORDERS
SET days_since_prior_order = NULL
WHERE days_since_prior_order = '';

UPDATE ORDERS
SET order_hour_of_day = NULL
WHERE order_hour_of_day = '';



--PROJECTS ANALYSIS

--- 1. Market Basket Analysis:

-- Question 1: What are the top 10 product pairs that are most frequently purchased together?

WITH ProductPairs AS (
    SELECT
        op1.product_id AS product_id_1,
        op2.product_id AS product_id_2,
        COUNT(*) AS frequency
    FROM
        order_product_prior AS op1
        INNER JOIN order_product_prior AS op2
        ON op1.order_id = op2.order_id AND op1.product_id < op2.product_id
    GROUP BY
        op1.product_id,
        op2.product_id
)
SELECT TOP 10
    pp.product_id_1,
    pp.product_id_2,
    p1.product_name AS product_name_1,
    p2.product_name AS product_name_2,
    pp.frequency
FROM
    ProductPairs AS pp
    INNER JOIN PRODUCT AS p1
    ON pp.product_id_1 = p1.product_id
    INNER JOIN PRODUCT AS p2
    ON pp.product_id_2 = p2.product_id
ORDER BY
    pp.frequency DESC;

-- What are the top 5 products that are most commonly added to the cart first?

WITH CombinedOrderProducts AS (
    SELECT product_id, add_to_cart_order
    FROM order_product_prior
    UNION ALL
    SELECT product_id, add_to_cart_order
    FROM order_product_train
)

SELECT TOP 5 cc.product_id, pp.product_name, COUNT(*) AS AddToCartCount
FROM CombinedOrderProducts cc
JOIN PRODUCT pp ON pp.product_id = cc.product_id
WHERE add_to_cart_order = 1
GROUP BY cc.product_id, pp.product_name
ORDER BY AddToCartCount DESC;

--How many unique products are typically included in a single order?

SELECT
    order_id,
	COUNT(DISTINCT product_id) AS unique_product_count

FROM
	order_product_prior
GROUP BY
    order_id
ORDER BY
    unique_product_count DESC;

-- 2. Customer Segmentation

-- Categorize customers based on the total amount they've spent on orders?

WITH CustomerSpending AS (
    SELECT
        user_id,
        COUNT(order_id) AS total_order
    FROM
        ORDERS 
    GROUP BY
        user_id
)
SELECT
    user_id,
    total_order,
    CASE
        WHEN total_order >= 80 THEN 'High Spender'
        WHEN total_order >= 30 AND total_order < 80 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_category
FROM
    CustomerSpending;


		-- What are the different customer segments based on purchase frequency?

WITH CustomerPurchaseFrequency AS (
    SELECT
        user_id,
        COUNT(order_id) AS purchase_count
    FROM
        ORDERS
    GROUP BY
        user_id
)

SELECT
    user_id,
    purchase_count,
    CASE
        WHEN purchase_count >= 10 THEN 'Frequent Buyer'
        WHEN purchase_count >= 5 AND purchase_count < 10 THEN 'Regular Buyer'
        ELSE 'Occasional Buyer'
    END AS customer_segment
FROM
    CustomerPurchaseFrequency;


-- 3. Seasonal Trends Analysis

-- What is the distribution of orders placed on different days of the week?

SELECT
    order_dow,
    COUNT(*) AS order_count
FROM
	ORDERS
GROUP BY
    order_dow
ORDER BY
    order_dow;
-- Average number of orders per customer

SELECT AVG(orders_per_customer) AS AverageOrdersPerCustomer
FROM (
    SELECT user_id, COUNT(DISTINCT order_id) AS orders_per_customer
    FROM ORDERS
    GROUP BY user_id
) AS Subquery;


-- 4. Customer Churn Prediction

-- Question 1: Calculate the number of customers who haven't placed an order in the last 30 days

SELECT COUNT(DISTINCT user_id) AS InactiveCustomers
FROM (
    SELECT user_id, MAX(days_since_prior_order) AS max_days_since_prior
    FROM Orders
    GROUP BY user_id
) AS Subquery
WHERE max_days_since_prior >= 30 OR max_days_since_prior IS NULL;

--- Calculate the customer churn rate

WITH InactiveCustomers AS (
    SELECT COUNT(DISTINCT user_id) AS InactiveCount
    FROM (
        SELECT user_id, MAX(days_since_prior_order) AS max_days_since_prior
        FROM Orders
        GROUP BY user_id
    ) AS Subquery
    WHERE max_days_since_prior >= 30 OR max_days_since_prior IS NULL
)

SELECT 
    InactiveCount * 100.0 / NULLIF((SELECT COUNT(DISTINCT user_id) FROM Orders), 0) AS ChurnRate
FROM InactiveCustomers;


-- 5. Product Association Rules

-- What are the top 5 product combinations that are most frequently purchased together?

WITH ProductPairs AS (
    SELECT
        p1.product_id AS product1,
        p2.product_id AS product2
    FROM
        order_product_prior p1
    INNER JOIN
        order_product_prior p2 ON p1.order_id = p2.order_id AND p1.product_id < p2.product_id
)

SELECT TOP 5
    product1,
    product2,
    COUNT(*) AS frequency
FROM
    ProductPairs
GROUP BY
    product1, product2
ORDER BY
    frequency DESC;


 -- Can we find products that are often bought together on weekends vs. weekdays?

WITH WeekendOrders AS (
    SELECT
        o.order_id,
        op.product_id AS product_id1,
        p1.product_name AS product_name1
    FROM
        ORDERS o
    INNER JOIN
        order_product_prior op ON o.order_id = op.order_id
    JOIN 
        PRODUCT p1 ON p1.product_id = op.product_id
    WHERE
        o.order_dow IN (5, 6) -- Weekend (5 = Saturday, 6 = Sunday)
),

WeekdayOrders AS (
    SELECT
        o.order_id,
        op.product_id AS product_id2,
        p2.product_name AS product_name2
    FROM
        ORDERS o
    INNER JOIN
        order_product_prior op ON o.order_id = op.order_id
    JOIN
        PRODUCT p2 ON p2.product_id = op.product_id
    WHERE
        o.order_dow IN (0, 1, 2, 3, 4) -- Weekdays (0 = Monday, 1 = Tuesday, ..., 4 = Friday)
)

SELECT TOP 10
    'Weekend' AS day_type,
    p1.product_name1 AS product_name1,
    p2.product_name1 AS product_name2,
    COUNT(*) AS frequency
FROM
    WeekendOrders p1
INNER JOIN
    WeekendOrders p2 ON p1.order_id = p2.order_id AND p1.product_id1 < p2.product_id1
GROUP BY
    p1.product_name1, p2.product_name1

UNION ALL

SELECT TOP 10
    'Weekday' AS day_type,
    p1.product_name2 AS product_name1,
    p2.product_name2 AS product_name2,
    COUNT(*) AS frequency
FROM
    WeekdayOrders p1
INNER JOIN
    WeekdayOrders p2 ON p1.order_id = p2.order_id AND p1.product_id2 < p2.product_id2
GROUP BY
    p1.product_name2, p2.product_name2
ORDER BY
    day_type, frequency DESC;

	   	 
-- 7. Product Affinity:

-- Aisle and Department Analysis

SELECT
	d.Department_id,
    d.Department,
    COUNT(o.order_id) AS TotalSales
FROM
    ORDERS o
JOIN
    order_product_prior op ON o.order_id = op.order_id
JOIN
    PRODUCT p ON p.product_id = op.product_id
JOIN
    AISLES a ON p.aisle_id = a.aisle_id
JOIN
    DEPARTMENTS d ON p.department_id = d.department_id
GROUP BY
    d.department_id, d.Department
ORDER BY
    TotalSales DESC;

-- Aisle

SELECT
	a.aisle_id,
    a.aisle,
    COUNT(o.order_id) AS TotalSales
FROM
    ORDERS o
JOIN
    order_product_prior op ON o.order_id = op.order_id
JOIN
    PRODUCT p ON p.product_id = op.product_id
JOIN
    AISLES a ON p.aisle_id = a.aisle_id
JOIN
    DEPARTMENTS d ON p.department_id = d.department_id
GROUP BY
    a.aisle_id, a.aisle
ORDER BY
    TotalSales DESC;



	