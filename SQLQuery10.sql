--Having : filter data after aggregation
SELECT
	country,
	Sum(Score) as Total_Score
FROM customers
GROUP BY country
Having Sum(Score)>800

--avg score for each country considering customers with score not equal to 0
SELECT
	country,
	AVG(score) as Average_Score
FROM customers
WHERE score != 0
GROUP BY country
--avg score for each country considering customers with score not equal to 0 and return only those countries with avaerage score greater than 430 
SELECT
	country,
	AVG(score) as Average_Score
FROM customers
WHERE score != 0
GROUP BY country
Having AVG(score) >430
