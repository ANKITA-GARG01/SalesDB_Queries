--Group By:Aggregate Your Data
-- combines rows with same values and aggregates a column by another column
-- Total Score By Country
SELECT
    country,
    Sum(Score) 
FROM customers
GROUP BY country-- each country will be shouwn once 

SELECT
    country,
    Sum(Score) as Total_Score
FROM customers
GROUP BY country

-- Total score and total number of customers by country
SELECT 
    country,
    COUNT(first_name) as Total_Customers,
    SUM(score) as Total_Score
FROM customers
GROUP BY country

