
use SalesDB
--Find The Total Sales Across All Orders
SELECT
SUM(Sales) Total_Sales
FROM Sales.Orders

--Total Sales For Each Product
SELECT
ProductID,
SUM(Sales) Total_Sales
FROM Sales.Orders
Group BY ProductID

/* Total Sales For Each Product
Additionally provide details such as OrderId,OrderDate*/
SELECT
ProductID,
OrderId,
OrderDate,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

--Find the total sales by Product and Orderstatus
SELECT
ProductID,
OrderStatus,
SUM(Sales) OVER(Partition by ProductID,OrderStatus) TotalSales
FROM Sales.Orders

--Rank each order based on their sales from highest to lowest. Provide additional details as well
SELECT
ProductID,
OrderID,
OrderDate,
Sales,
RANK() OVER(Order BY Sales DESC)
FROM Sales.Orders


SELECT
ProductID,
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER(PARTITION BY OrderStatus Order BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING),
--SUM(Sales) OVER(PARTITION BY OrderStatus Order BY OrderDate ROWS 2 FOLLOWING), SHORT FORM ONLY WITH PRECEDING
SUM(Sales) OVER(PARTITION BY OrderStatus Order BY OrderDate ROWS BETWEEN  2 PRECEDING AND CURRENT ROW),
SUM(Sales) OVER(PARTITION BY OrderStatus Order BY OrderDate ROWS 2 PRECEDING)
FROM Sales.Orders

--Order By always uses a frame - if not mentioned it uses default 
--i.e. rows between unbounded preceding and current row




--aggregate functions
--COUNT can take any data types as expression 
SELECT
*,
COUNT(*) OVER() , --COUNTS ALL ROWS REGARDLESS OF NULLS
COUNT(Score)  OVER()          --COUNTS ONLY NON NULL VALUES
FROM Sales.Customers
--THUS ABOVE CODE HELPS IN QUALITY CHECK BY COMPARING TOTAL ROWS AND NON NULL ROWS 
--INFORMING HOW MANY CELLS ARE NULL


--During Analysis, we have to check if there is any duplicates,
--its not necessary that if  a colum is primary key then its unique so to check pk
SELECT 
OrderId,
COUNT(*) OVER(PARTITION BY OrderId)--If this is greater than 1 then there are duplicate rows
FROM Sales.Orders

SELECT
* 
FROM(
SELECT 
OrderId,
COUNT(*) OVER(PARTITION BY OrderId) CheckPK--If this is greater than 1 then there are duplicate rows
FROM Sales.OrdersArchive
)t WHERE CheckPk >1


--TASK: Find Total Sales Of All Products WIth data like OrderID ,OrderDate
--TASK2: Find total sales of each Product With Other Data

SELECT
OrderId,
OrderDate,
Sales,
SUM(Sales) OVER() [TOTALSUM],
SUM(Sales) OVER(PARTITION BY ProductId)
FROM Sales.Orders


--TASK: Find the contribution % of each product's sakes in total sales
SELECT
OrderId,
OrderDate,
Sales,
SUM(Sales) OVER() TOTALSALES,
ROUND(Sales*100.0/SUM(Sales) OVER(),2) Contribution
FROM Sales.Orders

--AVERAGE :ITS IMP TO HANDLE NULLS BEFORE TAKING AVERAGE

SELECT
*,
AVG(Sales) OVER(),
AVG(COALESCE(Sales,0)) OVER()
FROM Sales.Orders



--RUNNING AND ROLLIING TOTAL NOTES IN NOTEBOOK

SELECT
OrderId,
OrderDate,
Sales,
SUM(Sales) OVER(ORDER BY OrderDate) RUNNING_TOTAL,
SUM(Sales) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) ROLLING_TOTAL_3_MONTHS
FROM Sales.Orders

--MOVING AVERAGE: SAME AS RUNNING_AVG
--TASK:CALCULATE THE MOVING AVG OF SALES FOR EACH PRODUCT OVER TIME, INCLUDING ONLY THE NEXT ORDER
--since fixed window is given its same as rolling_avg 

SELECT
OrderId,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) RollingAvg
FROM Sales.Orders


--RANKING WINDOWS FUNCTIONS
--ROW_NUMBER
--TASK: RANK ORDERS BASED ON SALES
SELECT
OrderId,
OrderDate,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) as [ROW_NUMBER],--unique ranking and no skipping
RANK() OVER(ORDER BY Sales DESC) as [RANK],-- SAME RANK FOR SAME NO. ,SKIPS RANKS
DENSE_RANK() OVER(ORDER BY Sales DESC) as [DENSE_RANK]
FROM Sales.Orders

--ROW_NUMBER USE CASE: TOP-N ANALYSIS
--TASK:FIND TOP HIGHEST SALES OF EACH PRODUCT
SELECT * FROM(
SELECT 
OrderId,
OrderDate,
Sales,
ProductId,
ROW_NUMBER() OVER(PARTITION BY ProductId ORDER BY Sales DESC) as RankByProductSales
FROM Sales.Orders)t WHERE RankByProductSales =1

--BOTTOM-N ANALYSIS
--TASK:FIND LOWEST 2 CUSTOMERS BASED ON THEIR TOTAL SALES

SELECT
CustomerId,
SUM(Sales) TOTAL_SALES,
ROW_NUMBER() OVER( ORDER BY SUM(Sales)) AS RANKBYCUSTOMER
From Sales.Orders
GROUP BY CustomerID
--columns used in group by and windows must be same

--usecase3: ASSIGN UNIQUE ROW:
--TABLE ORDERARCHIVE HAS NO PRIMARY KEY
--UNIQUECOLUMN ALSO HELPS IN PAGINATING
SELECT
ROW_NUMBER() OVER(ORDER BY OrderId,OrderDate) AS PRIMARY_KEY,
*
FROM Sales.OrdersArchive

--USE_CASE4: IDENTIFYING DUPLICATES AND REMOVING THEM FOR CLEAN DATA
SELECT * FROM(
SELECT
ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY CreationTime DESC) RN,--to save last record
*
from Sales.OrdersArchive)t WHERE RN=1

--NTILE(N)
SELECT
OrderId,
Sales,
NTILE(1) OVER(ORDER BY Sales) AS [NTILE_1_BUCKET],
NTILE(2) OVER(ORDER BY Sales) AS [NTILE_2_BUCKET],
NTILE(3) OVER(ORDER BY Sales) AS [NTILE_3_BUCKET],
NTILE(4) OVER(ORDER BY Sales) AS [NTILE_4_BUCKET]
FROM Sales.Orders
--NTILE USE CASE1 : DATA SEGMENTATION FOR DATA ANALYSTS AND (ETL PROCESSING AND LOAD BALANCING) FOR DATA ENGINEER
--DATA SEGEMENTATION TASK: SEGMENT ALL ORDERS INTO 3 CATEGORIES: HIGH , MEDIUM LOW BASE ON SALES
SELECT
*,
CASE
   WHEN BUCKETS=1 THEN 'HIGH'
   WHEN BUCKETS=2 THEN 'MEDIUM'
   WHEN BUCKETS=3 THEN 'LOW'
END SEGMENTS FROM
(
SELECT 
OrderId,
Sales,
NTILE(3) OVER(Order by Sales DESC) BUCKETS
FROM Sales.Orders
)t

--USECASE2 :LOAD BALANCING -WHEN MOVING FULL LOAD FROM DATABASE A TO B , IT MIGHT TAKE A LOT OF TIME AND NETWORK MAY EVEN BREAK
--IN BETWEEN, TO REDUCE THE LOAD OR BALANCE IT , ITS DIVIDED INTO BUCKETS SO AVOID STRESSING NETWORK
--TASK1:IN ORDER TO EXPORT DATA, DIVIDE ORDERS INTO 2 GROUPS which can be combined  later using union
SELECT 
NTILE(2) OVER(Order by OrderId) BUCKETS,
*
FROM Sales.Orders

---NEXT TOPIC-----------------------------------------------------------------------------------------
--VALUE WINDOW FUCNTIONS(LEAD,LAG, FIRST_VALUE, LAST_VALUE)

--LEAD/LAG(exp,offset,default)
SELECT
ProductID,
Sales,
LEAD(Sales,2,10) OVER(PARTITION BY ProductID ORDER BY OrderDate)
FROM Sales.Orders

--TIME SERIES ANALYSIS:THE PROCESS OF ANALYSING THW DATA TO UNDERSTAND PATTERNS , TRENDS AND BEHAVIOURS OVEE TIME
--YOY(YEAR OVER YEAR):ANALYSE THE OVERALL GROWTH OR DECLINE OF THE BUSINESS'S PERFORMANCE OVER TIME
--MOM(MONTH OVER MONTH): ANALYSE SHORT-TERM TRENDS AND DISCOVER PATTERNS IN SEASONALITY
--TASK1: Analyse the mom performance by finding the % change in sales
--between current and previous months
SELECT * ,
ROUND(CAST((CURRENT_TOTAL_SALES-LAST_MONTH_SALE) AS FLOAT)/LAST_MONTH_SALE*100,2) [%CHANGE]
FROM
(
SELECT
MONTH(OrderDate) as [ORDER_MONTH],
SUM(Sales) as CURRENT_TOTAL_SALES,
LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) AS LAST_MONTH_SALE
FROM Sales.Orders
GROUP BY MONTH(OrderDate))t


--MIN/MAX USE CASE od lead/lag
--CUSTOMER RETENTION ANALYSIS:MEASURE CUSTOMERS'S BEHAVIOUR AND LOYALITY TO HELO BUSINESSES BUILT STRONG RELATIONSHIPS WITH CUSTOMERS
--ANALYSE CUSTOMER LOYALITY BY RANKING CUSTOMERS BASED ON AVG NO. OF DAYS BETWEEN ORDERS
SELECT
CustomerID,
AVG(days_btw_orders) AvgDays,
RANK() OVER(ORDER BY COALESCE(AVG(days_btw_orders),999999999)) [RANK]
FROM(
	SELECT
	OrderID,
	CustomerID,
	OrderDate,
	LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) AS [LAST_ORDER_DATE],
	DATEDIFF(DAY,LAG(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate),OrderDate) [days_btw_orders]
	FROM Sales.Orders
	
)t
GROUP BY CustomerID

