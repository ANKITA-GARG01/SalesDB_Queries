  --DISTINCT: removes duplicate rows from the result set.
  --dont use distinct unless necessary, as it can impact performance. Instead, consider using GROUP BY or other methods to achieve the desired results without unnecessary overhead.
  SELECT DISTINCT country
  FROM customers

  --Top (Limit): limits the number of rows returned by a query.
  SELECT TOP 3 *
  FROM customers

    SELECT TOP 3 *
  FROM customers
 ORDER BY score DESC 

  SELECT TOP 2 *
  FROM customers
 ORDER BY score ASC