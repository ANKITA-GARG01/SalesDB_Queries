--using WHERE for conditional deletion of records
SELECT *
FROM customers
WHERE score>500

SELECT 
	first_name,
	country
FROM customers
WHERE score>500

SELECT *
FROM customers
WHERE score!=0

SELECT 
	first_name,
	score
FROM customers
WHERE country='Germany'
