# 📊 SQL Practice — Advanced T-SQL Queries (MS SQL Server)

A structured collection of SQL scripts covering beginner to advanced T-SQL concepts using a **SalesDB** database.  
Topics range from basic SELECT queries to advanced Window Functions, Recursive CTEs, Views, and real-world analytical use cases.

---

## 🗂️ Project Structure

```
📁 SQL-Practice/
│
├── SQLQuery1.sql           → DISTINCT & TOP clause
├── SQLQuery2.sql           → SELECT basics & static queries
├── SQLQuery3.sql           → DDL Statements (CREATE, ALTER, DROP)
├── SQLQuery4.sql           → GROUP BY & Aggregations
├── SQLQuery5.sql           → Basic SELECT
├── SQLQuery6.sql           → Filtering columns from Orders
├── SQLQuery7.sql           → WHERE clause & Conditional Filtering
├── SQLQuery9.sql           → ORDER BY (ASC, DESC, Nested)
├── SQLQuery10.sql          → HAVING clause
├── SQLQuery11.sql          → JOINs (All types) & Set Operators
├── SQLQuery12.sql          → Multi-table JOINs
├── SQLQuery13.sql          → SET Operators (UNION, INTERSECT, EXCEPT)
├── SQLQuery14.sql          → Delta Detection (EXCEPT operator)
├── SQLQuery15.sql          → String & Numeric Functions
├── NULL_FUNCTIONS.sql      → NULL Handling (ISNULL, COALESCE, NULLIF)
├── DATETIME_FUNCTIONS.sql  → DateTime Functions
├── WINDOW_FUNCTION.sql     → Window Functions
├── Advanced_SQL.sql        → CTEs, Views, Subqueries, Correlated Queries
└── LEETCODE_QUERY.sql      → LeetCode SQL Problem
```

---

## 🗄️ Database Used

**Database:** `SalesDB`  
**Schema:** `Sales`

**Tables:**
| Table | Description |
|-------|-------------|
| `Sales.Orders` | Order transactions data |
| `Sales.OrdersArchive` | Archived orders |
| `Sales.Customers` | Customer information |
| `Sales.Products` | Product catalog |
| `Sales.Employees` | Employee and manager data |

---

## 📌 Topics Covered

### 1. 🔤 Basic SQL (SQLQuery1 - SQLQuery7)
- `SELECT`, `DISTINCT`, `TOP` clause
- `WHERE` clause for conditional filtering
- `ORDER BY` — single and nested sorting (ASC/DESC)
- `GROUP BY` with aggregate functions (`SUM`, `COUNT`, `AVG`)
- `HAVING` — filtering after aggregation
- Static/fixed query construction

```sql
-- Example: Top 3 customers by score
SELECT TOP 3 *
FROM customers
ORDER BY score DESC
```

---

### 2. 🔗 JOINs (SQLQuery11, SQLQuery12)
- **INNER JOIN** — only matching rows
- **LEFT JOIN** — all left rows + matching right rows
- **RIGHT JOIN** — all right rows + matching left rows
- **FULL OUTER JOIN** — all rows from both tables
- **LEFT ANTI JOIN** — rows in left with no match in right
- **FULL ANTI JOIN** — unmatched rows from both tables
- **CROSS JOIN** — all combinations of rows

```sql
-- Example: All customers with their orders (including no orders)
SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
```

---

### 3. ➕ Set Operators (SQLQuery12, SQLQuery13)
- `UNION` — combine rows, remove duplicates
- `UNION ALL` — combine rows, keep duplicates (better performance)
- `INTERSECT` — common rows in both queries
- `EXCEPT` — rows in first query not in second (Delta Detection)

```sql
-- Example: Employees who are NOT customers
SELECT FirstName, LastName FROM Sales.Employees
EXCEPT
SELECT FirstName, LastName FROM Sales.Customers
```

---

### 4. 🧵 String & Numeric Functions (SQLQuery15)
| Function | Purpose |
|----------|---------|
| `TRIM`, `LTRIM`, `RTRIM` | Remove leading/trailing spaces |
| `UPPER`, `LOWER` | Change case |
| `LEN` | String length |
| `CONCAT` | Combine strings |
| `REPLACE` | Replace characters |
| `SUBSTRING` | Extract part of string |
| `LEFT`, `RIGHT` | Extract from left/right |
| `ROUND` | Round numbers |
| `ABS` | Absolute value |

```sql
-- Example: Find customers with leading/trailing spaces
SELECT FirstName, TRIM(FirstName),
       LEN(FirstName) - LEN(TRIM(FirstName)) AS FLAG
FROM Sales.Customers
```

---

### 5. 📅 DateTime Functions (DATETIME_FUNCTIONS.sql)
| Category | Functions |
|----------|-----------|
| Part Extraction | `DAY()`, `MONTH()`, `YEAR()`, `DATEPART()`, `DATENAME()`, `DATETRUNC()`, `EOMONTH()` |
| Formatting | `FORMAT()`, `CONVERT()`, `CAST()` |
| Calculations | `DATEADD()`, `DATEDIFF()` |
| Validation | `ISDATE()` |

```sql
-- Example: Average shipping duration per month
SELECT MONTH(OrderDate),
       AVG(DATEDIFF(Day, OrderDate, ShipDate)) AS AvgShippingDuration
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
```

---

### 6. ⬛ NULL Functions (NULL_FUNCTIONS.sql)
| Function | Purpose |
|----------|---------|
| `ISNULL(expr, val)` | Replace NULL with a value |
| `COALESCE(a, b, c...)` | Return first non-NULL value |
| `NULLIF(a, b)` | Return NULL if both values are equal |

**Key Use Cases:**
- Avoid division by zero errors using `NULLIF`
- Handle NULL values before aggregation (`AVG`, `COUNT`)
- Custom NULL sorting using `CASE` + `ORDER BY`
- Data standardization using `COALESCE(NULLIF(TRIM(col), ''), 'N/A')`

```sql
-- Example: Avoid division by zero
SELECT Sales / NULLIF(Quantity, 0) AS SalesPrice
FROM Sales.Orders
```

---

### 7. 🪟 Window Functions (WINDOW_FUNCTION.sql)

#### Aggregate Window Functions
```sql
SUM()   OVER(PARTITION BY ...)
AVG()   OVER(PARTITION BY ...)
COUNT() OVER(PARTITION BY ...)
MIN()   OVER(PARTITION BY ...)
MAX()   OVER(PARTITION BY ...)
```

#### Ranking Functions
| Function | Behavior |
|----------|---------|
| `ROW_NUMBER()` | Unique rank, no ties, no skipping |
| `RANK()` | Same rank for ties, skips next rank |
| `DENSE_RANK()` | Same rank for ties, no skipping |
| `NTILE(N)` | Divides rows into N equal buckets |

#### Value Functions
| Function | Purpose |
|----------|---------|
| `LEAD(col, offset)` | Access next row's value |
| `LAG(col, offset)` | Access previous row's value |
| `FIRST_VALUE()` | First value in window |
| `LAST_VALUE()` | Last value in window |

#### Frame Clauses
```sql
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- Running Total
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW          -- Rolling 3-row window
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING          -- Forward window
```

**Real-World Use Cases Practiced:**
- Running & Rolling Total of Sales
- MoM (Month-over-Month) % change in sales
- Customer retention analysis — avg days between orders
- Duplicate detection using `ROW_NUMBER() OVER(PARTITION BY OrderId)`
- Data segmentation (High/Medium/Low) using `NTILE(3)`
- ETL Load Balancing — dividing data into batches using `NTILE(2)`
- Top-N and Bottom-N analysis per product/customer

```sql
-- Example: Month-over-Month % change in sales
SELECT *,
  ROUND(CAST((CURRENT_TOTAL_SALES - LAST_MONTH_SALE) AS FLOAT)
        / LAST_MONTH_SALE * 100, 2) AS [%CHANGE]
FROM (
  SELECT MONTH(OrderDate) AS ORDER_MONTH,
         SUM(Sales) AS CURRENT_TOTAL_SALES,
         LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS LAST_MONTH_SALE
  FROM Sales.Orders
  GROUP BY MONTH(OrderDate)
) t
```

---

### 8. 🧠 Advanced SQL (Advanced_SQL.sql)

#### Subqueries
- Scalar subqueries in SELECT
- Subqueries in WHERE using `IN`
- Correlated subqueries using `EXISTS`

```sql
-- Correlated subquery: Total orders per customer
SELECT c.*,
  (SELECT COUNT(*) FROM Sales.Orders o WHERE c.CustomerID = o.CustomerID) AS Total_Orders
FROM Sales.Customers c
```

#### CTEs (Common Table Expressions)
- Simple CTEs for readability
- CTEs for pre-aggregation before joining
- Running totals using CTE + Window Function

```sql
-- Example: Running total of monthly sales
WITH CTE_Month_Summary AS (
  SELECT DATETRUNC(MONTH, OrderDate) AS Order_Month,
         SUM(Sales) AS Total_Sales
  FROM Sales.Orders
  GROUP BY DATETRUNC(MONTH, OrderDate)
)
SELECT Order_Month, Total_Sales,
       SUM(Total_Sales) OVER(ORDER BY Order_Month) AS Rolling_Total
FROM CTE_Month_Summary
```

#### Recursive CTEs
- Employee hierarchy with levels

```sql
-- Employee hierarchy
WITH CTE_Emp_Hierarchy AS (
  SELECT EmployeeID, FirstName, ManagerID, 1 AS Level
  FROM Sales.Employees WHERE ManagerID IS NULL
  UNION ALL
  SELECT e.EmployeeID, e.FirstName, e.ManagerID, ceh.Level + 1
  FROM Sales.Employees e
  INNER JOIN CTE_Emp_Hierarchy ceh ON e.ManagerID = ceh.EmployeeID
)
SELECT * FROM CTE_Emp_Hierarchy
```

#### Views
- Creating Views from CTEs
- Schema-specific Views (`Sales.V_Monthly_Summary`)
- Multi-table Views combining Orders, Products, Customers, Employees
- Dropping and recreating Views using `OBJECT_ID` check

---

### 9. 🧩 DDL Statements (SQLQuery3)
```sql
CREATE TABLE persons (
  ID INT NOT NULL,
  person_name VARCHAR(50) NOT NULL,
  birth_date DATE,
  CONSTRAINT pk_persons PRIMARY KEY(ID)
)

ALTER TABLE persons ADD email VARCHAR(50) NOT NULL
ALTER TABLE persons DROP COLUMN phone_number
DROP TABLE persons
```

---

### 10. 💡 LeetCode Problem (LEETCODE_QUERY.sql)
**Problem:** Count how many times each student attended each subject exam.

**Approach:** Used `CROSS JOIN` between Students and Subjects to generate all combinations, then `LEFT JOIN` with Examinations to count attendance.

```sql
SELECT st.student_id, su.subject_name, COUNT(ex.student_id)
FROM Students st
CROSS JOIN Subjects su
LEFT JOIN Examinations ex
  ON st.student_id = ex.student_id
  AND su.subject_name = ex.subject_name
GROUP BY st.student_id, su.subject_name
ORDER BY st.student_id, su.subject_name
```

---

## 🛠️ Tools & Environment

- **Database:** Microsoft SQL Server
- **Language:** T-SQL (Transact-SQL)
- **IDE:** SQL Server Management Studio (SSMS)

---

## 💡 Key Concepts & Takeaways

| Concept | Insight |
|---------|---------|
| `DISTINCT` vs `GROUP BY` | GROUP BY is more performant for deduplication |
| `UNION` vs `UNION ALL` | UNION ALL is faster; use UNION only when duplicates matter |
| `ISNULL` vs `COALESCE` | COALESCE checks multiple values; more flexible |
| `RANK` vs `DENSE_RANK` | DENSE_RANK doesn't skip numbers after ties |
| Window vs Aggregate | Window functions don't collapse rows |
| `DATEPART` vs `DATENAME` | DATEPART returns INT (faster for filtering); DATENAME returns STRING |
| NULL sorting | NULLs sort first in ASC, last in DESC by default |

---

## 👤 Author

**Ankita Garg**  
📧 ankitagarg327@gmail.com  
🔗 [LinkedIn](www.linkedin.com/in/ankita-garg-a80817212)  
🐙 [GitHub](https://github.com/ANKITA-GARG01)
