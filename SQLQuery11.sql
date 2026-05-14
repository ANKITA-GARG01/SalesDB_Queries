--COMBINING DATA 
--1. JOINS ARE USED FOR COMBINING COLUMNS: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN
--2. SET OPERATIONS ARE USED FOR COMBINING ROWS: UNION, UNION ALL, INTERSECT, EXCEPT
SELECT *
From customers

SELECT *
FROM persons

SELECT *
FROM orders

INSERT INTO persons (ID, person_name, birth_date, phone_number, email)
VALUES (1, 'John Doe', '1990-01-01', '123-456-7890', 'abc@gmail.com'),
       (2, 'Jane Smith', '1985-05-15', '987-654-3210', 'c@gmail.com'),
       (4, 'Alice Johnson', '1992-09-30', '555-123-4567', 'a@gmail.com')

-- INNER JOIN
SELECT *
FROM customers
INNER JOIN persons
ON customers.id = persons.ID

/* GET ALL CUSTOMERS ALONG WITH THEIR ORDER BUT
GIVE ONLY THOSE CUSTOMERS WHO HAVE PLACED AN ORDER */
SELECT 
  c.id,
  c.first_name,
  o.order_id,
  o.order_date,
  o.sales
FROM customers c
INNER JOIN orders o
ON c.id=o.customer_id

--LEFT JOIN : ALL COLUMNS FROM LEFT TABLE AND MATCHING COLUMNS FROM RIGHT TABLE
/* GET ALL CUSTOMERS ALONG WITH THEIR ORDER INCLUDING THOSE WITHOUT AN ORDER */
INSERT INTO orders (order_id, customer_id, order_date, sales)
VALUES (1007, 1, '2023-01-01', 100)
     
SELECT 
  c.id,
  c.first_name,
  o.order_id,
  o.order_date,
  o.sales
FROM customers c
LEFT JOIN orders o
ON c.id=o.customer_id
/* GET ALL CUSTOMERS ALONG WITH THEIR ORDER INCLUDING ORDERS WITHOUT MATCHING CUSTOMER USING RIGHT JOIN */
SELECT 
  c.id,
  c.first_name,
  o.customer_id,
  o.order_id,
  o.order_date,
  o.sales
FROM customers c
RIGHT JOIN orders o
ON c.id=o.customer_id
/* GET ALL CUSTOMERS ALONG WITH THEIR ORDER INCLUDING ORDERS WITHOUT MATCHING CUSTOMER USING LEFT JOIN */

SELECT 
  c.id,
  c.first_name,
  o.customer_id,
  o.order_id,
  o.order_date,
  o.sales
FROM orders o
LEFT JOIN customers c
ON c.id=o.customer_id

--GET ALL CUSTOMERS AND ALL ORDERS EVEN IF THEY DON'T MATCH USING FULL OUTER JOIN

SELECT 
  c.id,
  c.first_name,
  o.customer_id,
  o.order_id,
  o.order_date,
  o.sales
FROM orders o
FULL JOIN customers c
ON c.id=o.customer_id

--ADVANCED JOINS:LEFT ANTI JOIN, RIGHT ANTI JOIN, CROSS JOIN,
--LEFT ANTI JOIN:ALL ROWS FROM LEFT TABLE THAT DON'T HAVE A MATCH IN RIGHT TABLE
--GET ALL CUSTOMERS WHO HAVE NOT PLACED AN ORDER

SELECT 
  c.id,
  c.first_name,
  o.order_id,
  o.order_date,
  o.sales
FROM customers c
LEFT JOIN orders o
ON c.id=o.customer_id
WHERE o.customer_id IS NULL


--full anti join:ALL ROWS FROM BOTH TABLES THAT DON'T HAVE A MATCH IN OTHER TABLE
--FIND CUSTOMERS WITHOUT ORDERS AND ORDERS WITHOUT CUSTOMERS
SELECT * 
FROM customers c
FULL JOIN orders o
ON c.id=o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL



/* GET ALL CUSTOMERS ALONG WITH THEIR ORDER BUT
GIVE ONLY THOSE CUSTOMERS WHO HAVE PLACED AN ORDER WITHOUT INNER JOIN */
SELECT * 
FROM customers c
FULL JOIN orders o
ON c.id=o.customer_id
WHERE o.customer_id IS NOT NULL AND c.id IS NOT NULL

SELECT *
FROM customers c
LEFT JOIN orders o
ON c.id=o.customer_id
WHERE o.customer_id IS NOT NULL


--CROSS JOIN:ALL COMBINATIONS OF ROWS FROM BOTH TABLES
SELECT *
FROM customers c
CROSS JOIN orders o