--ORDER BY:sorts data
--in ascending order by default. 
--To sort data in descending order, use the DESC keyword after the column name.
SELECT *
FROM customers
ORDER BY score ASC

SELECT *
FROM customers
ORDER BY score 

SELECT *
FROM customers
ORDER BY score DESC

--NESTED(ORDER BY): sorts data based on multiple columns.
SELECT *
FROM customers
ORDER BY country  -- the score within two customers from the same country will be sorted in ascending order by default

SELECT *
FROM customers
ORDER BY country DESC-- the score within two customers from the same country will be sorted in descending order by default

SELECT *
FROM customers
ORDER BY country ASC, score DESC-- the score within two customers from the same country will be sorted in descending order
--THE ABOVE QUERIES WORK ONLY WHEN THE ORDER BY CLAUSE1 HAS MORE THAN 1 COLUMNS WHICH ARE SAME 
