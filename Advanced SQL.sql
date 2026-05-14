use SalesDB;

SELECT *
FROM
	(SELECT
	Price,
	Avg(Price) OVER() avgPrice
	FROM Sales.Products)t
WHERE Price>AvgPrice

--RANK CUSTOMERS BASED ON THEIT TOTAL AMOUNT OF SALES
SELECT *,
RANK() OVER (ORDER BY Total_Sales DESC) [RANK OF CUSTOMER]
FROM
(
	SELECT 
		CustomerID,
		SUM(Sales) [Total_Sales]
	FROM Sales.Orders
	GROUP BY CustomerID
	)t

--IMPORTANT CONCEPT OF CORRELATED QUERY
--GIVE ALL INFO OF CUTOMERS AND TOTAL NO. OF ORDERS OF "EACH" CUSTOMER
SELECT 
c.*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE c.CustomerID=o.CustomerID) Total_orders
FROM Sales.Customers c

--TASK: SHOW THE DETAILS OF ORDERS MADE BY CUSTOMERS IN GERMANY
SELECT
o.*,
c.Country
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID=c.CustomerID
WHERE c.Country='Germany'

SELECT
* 
FROM Sales.Orders o
WHERE CustomerID IN(
       SELECT CustomerID
	   FROM Sales.Customers 
	   WHERE Country='Germany'
			)


--Same query using correlated query
SELECT
* 

FROM Sales.Orders o
WHERE EXISTS(
       SELECT 1
	   CustomerID,
	   Country
	   FROM Sales.Customers c
	   WHERE Country='Germany' AND o.CustomerID=c.CustomerID
			)


--	RECURSIVE CTE
--TASK:Show The Employee Hierarchy By Showing each Employee's level within Organisation
WITH CTE_Emp_Hierarchy AS(
SELECT
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
Where ManagerID IS NULL
UNION ALL
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	ceh.Level+1
FROM Sales.Employees e
INNER JOIN CTE_Emp_Hierarchy ceh
ON e.ManagerID=ceh.EmployeeID

)
SELECT * FROM CTE_Emp_Hierarchy
end;

WITH CTE_Avg_Salary as
(
SELECT
EmployeeID,
 AVG(Salary) AS Avg FROM Sales.Employees
 GROUP BY EmployeeID
)
SELECT 
FirstName, 
Salary
FROM Sales.Employees e
INNER JOIN CTE_Avg_Salary a
ON e.EmployeeID =a.EmployeeID
WHERE Salary > Avg;

--TASK: FIND THE RUNNING TOTAL OF SALES FOR EACH MONTH USING CTE
WITH CTE_Month_Summary AS(
SELECT
DATETRUNC(MONTH,OrderDate) Order_Month,
SUM(Sales) Total_Sales,
SUM(OrderId) Total_Orders,
SUM(Quantity) Total_Quantity
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,OrderDate)
)
SELECT
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER(Order By Order_Month) Rolling_Total
FROM CTE_Month_Summary


--Creating View From Above CTE For Monthly Summary
CREATE VIEW V_Monthly_Summary AS
(
SELECT
DATETRUNC(MONTH,OrderDate) Order_Month,
SUM(Sales) Total_Sales,
COUNT(OrderId) Total_Orders,
SUM(Quantity) Total_Quantity
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,OrderDate)
)


--now i can directly query the view
SELECT
Order_Month,
Total_Sales,
SUM(Total_Sales) OVER(Order By Order_Month) Rolling_Total
FROM V_Monthly_Summary

CREATE VIEW Sales.V_Monthly_Summary AS
(
SELECT
DATETRUNC(MONTH,OrderDate) Order_Month,
SUM(Sales) Total_Sales,
COUNT(OrderId) Total_Orders,
SUM(Quantity) Total_Quantity
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,OrderDate)
)
--NOW WE HAVE 2 views One is UNDER Sales Schema And other is default(dbo)
--deleting default one
DROP V_Monthly_Summary;

--To ALTER VIEWS DEFINATION USING T-SQL
--T-SQL is extension to SQL that adds programming features
if OBJECT_ID('Sales.V_Monthly_Summary','V') IS NOT NULL 
DROP VIEW Sales.V_Monthly_Summary
GO
CREATE VIEW Sales.V_Monthly_Summary AS
(
SELECT
DATETRUNC(MONTH,OrderDate) Order_Month,
SUM(Sales) Total_Sales,
COUNT(OrderId) Total_Orders
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,OrderDate)
)


--provide a view thst combines information from product, orders, employee and customers
CREATE VIEW Sales.V_OrderDetails AS
(
	SELECT
	o.OrderId,
	o.OrderDate,
	p.Product,
	p.Price,
	p.Category,
	o.Sales,
	o.Quantity,
	COALESCE(c.FirstName,'') +' '+COALESCE(c.LastName,'') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName,'') +' '+COALESCE(e.LastName,'') EmployeeName,
	e.Department
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID=p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID=c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID= e.EmployeeID
)