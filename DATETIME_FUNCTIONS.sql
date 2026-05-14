  --DATE TIME FUNCTION(GETDATE(),PART EXTRACTION,FORMAT&CASTING, CALCULATIONS ,VALIDATION)
  --PART EXTRACTION(DAY,MONTH,YEAR,DATEPART,DATENAME,DATETRUNC,EOMONTH)
  --FORMING &CASTING(FORMAT,CONVERT,CAST)
  --CALCULATIONS(DATEADD, DATEDIFF)
  --VALIDATION(ISDATE)

  
  SELECT
    GETDATE() AS CurrentDateTime,-- provides the current datetime when the query is executed.
  OrderDate
  FROM Sales.Orders

  --PART EXTRACTION(DAY,MONTH,YEAR,DATEPART,DATENAME,DATETRUNC,EOMONTH)
  SELECT
      OrderDate,
      DAY(OrderDate) AS Order_DaY,
      MONTH(OrderDate) AS Order_Month,
      YEAR(OrderDate) AS Order_Year,
      EOMONTH(CreationTime) AS EndOfMonth,
      CAST(DATETRUNC(Month,CreationTime)AS DATE) StartOfMonth,
      DATETRUNC(Month,CreationTime) AS Creation_MonthTrunc,
      DATETRUNC(Hour,CreationTime) AS Creation_HourTrunc,
      DATETRUNC(MINUTE,CreationTime) AS Creation_MinsTrunc,
      CreationTime,
      DATEPART(HOUR, CreationTime) AS Creation_Hour,
  --datepart stores the extracted part as an integer while datename stores the extracted part as a string
      DATEPART(MONTH, CreationTime) AS Creation_Month,
      DATEPART(QUARTER, CreationTime) AS Creation_quarter,
      DATEPART(WEEK, CreationTime) AS Creation_Week,       
      DATENAME(WEEKDAY, CreationTime) AS Order_Weekday,
      DATENAME(MONTH, CreationTime) AS Order_MonthName
FROM Sales.Orders


--PART EXTRACTION USE CASE1:DATA AGGREGATION
--HOW MANY ORDERS WERE PLACED IN EACH YEAR?
SELECT
  YEAR(OrderDate),
  COUNT(*) TOTAL_ORDERS
  FROM Sales.Orders
  GROUP BY YEAR(OrderDate) 

--HOW Many irders were placed in each month?
SELECT
  DATENAME(MONTH, OrderDate) MONTH ,
  COUNT(*) TOTAL_ORDERS
  FROM Sales.Orders
  GROUP BY DATENAME(MONTH, OrderDate) 

 
--PART EXTRACTION USE CASE2:DATA FILTERING
--SHOW ALL ORDER PLACED IN THE MONTH OF FEBRUARY
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2
--USING INT VALUES IS ALWAYS MORE EFFCIENT THAN USING STRING VALUES IN FILTERING BECAUSE THE DATABASE ENGINE CAN OPTIMIZE THE QUERY BETTER WITH INT VALUES
--THEREFORE TRY TO USE DATEPART INSTEAD OF DATENAME IN FILTERING UNLESS YOU NEED TO DISPLAY THE MONTH NAME IN THE RESULT


--PART EXTRACTION USE CASE3:FUNCTION COMPARISON
-- DAY MONTH YEAR DATEPART-> INTEGER
--DATENAME-> STRING
--DATETRUNC-> DATETIME
--EOMONTH-> DATE


--FORMING &CASTING(FORMAT,CONVERT,CAST)
--FORMATTING CHANGES THE FORMAT BUT CASTING CHANGES THE DATA TYPE
/*DATE FORMATS
ISO 8601:yyyy-MM-dd -> SQL SERVER FOLLOWS THIS ONE
USA STANDARD: MM-dd-yyy
EUROPEAN: dd-MM-yyyy
*/

SELECT
      OrderID,
      CreationTime,
      FORMAT(CreationTime, 'MM-dd-yyyy') USA_STANDARD,
      FORMAT(CreationTime, 'dd') dd,
      FORMAT(CreationTime, 'ddd') ddd,
      FORMAT(CreationTime, 'dddd') dddd,
      FORMAT(CreationTime, 'MM')  MM,
      FORMAT(CreationTime, 'MMM') MMM,
      FORMAT(CreationTime, 'MMMM') MMMM,
      FORMAT(12343.49,'N' ) AS FormattedNumberN,-- formatting Numbers with N format specifier
      FORMAT(12343.49,'C' ) AS FormattedNumber$-- formatting Numbers with C format specifier
FROM  Sales.Orders
                              
--TASK: SHOW CREATIONTIME USING FOLLOWING FORMAT: Day Wed Jan Q1 2025 12:23:56 PM

SELECT
CreationTime,
'Day '+ FORMAT(CreationTime, 'ddd MMM')+ ' Q'+ DATENAME(QUARTER, CreationTime) + FORMAT(CreationTime, ' yyyy hh:mm:ss tt')
FROM Sales.Orders

--FORMATTING USE CASE-1: DATA AGGREGATIONS
--JAN 25 FORMAT
SELECT
   FORMAT( OrderDate,'MMM yy') ORDER_DATE,
   COUNT(*) NO_OFORDERS
FROM Sales.Orders
GROUP BY  FORMAT( OrderDate,'MMM yy')
 
--FORMATTING USE CASE-2: DATA STANDARDIZATIONS
--DATA COMES FROM DIFFERENT SOURCES LIKE APIS , DATABASES OR CSV FILES IN DIFFERENT FPRMATS WHICH CANT BE USED FOR REPORT SO STANDARD FORMAT IS SPECIFIED 

--CONVERT(date_type, value [,style]) it cant both convert and style
SELECT
 CONVERT(INT, '123') AS[ STRING TO INT],
 CONVERT(DATE,CreationTime) [DATETIME TO DATE],
 CONVERT(VARCHAR,CreationTime,32) [USA STANDARD STYLE:32],
 CONVERT(VARCHAR,CreationTime,34) [EUROPE STANDARD STYLE:34]
FROM Sales.Orders


--CAST(value AS data_type) it can only convert the data type but cant style the output
SELECT
CAST('123' AS INT) AS[ STRING TO INT],
CAST(CreationTime AS DATE) [DATETIME TO DATE]
FROM Sales.Orders


--CALCULATIONS(DATEADD, DATEDIFF)

SELECT
OrderID,
DATEADD(Year ,2, OrderDate) After2Years,
DATEADD(MONTH ,-10, OrderDate) before10Months,
DATEADD(Day ,20, OrderDate) After20Days,
OrderDate,
ShipDate,
DATEDIFF(Day,OrderDate,ShipDate)
FROM Sales.Orders
--find age of employees
SELECT
EmployeeID,
DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM Sales.Employees

--find avg shipping duration for each month

SELECT
Month(OrderDate),
AVG(DATEDIFF(Day,OrderDate,ShipDate)) AS AvgShippingDuration
FROM Sales.Orders
Group BY Month(OrderDate)
--Time Gap Analysis
--Find the number od days between each order and previous order

SELECT
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER(ORDER BY OrderDate) AS PreviousOrderDate,
DATEDIFF(Day,LAG(OrderDate) OVER(ORDER BY OrderDate),OrderDate) AS DaysSincePreviousOrder
FROM Sales.Orders

--VALIDATION(ISDATE):Checks if a value is a date, Returns 1 if string value is a valid date
--validates only ISO 8601 format (yyyy-MM-dd) and not other formats like MM-dd-yyyy or dd-MM-yyyy
SELECT
ISDATE('2025-08-20') DateCheck1,
ISDATE('20-08-2020') DateCheck2,
ISDATE('2022-30-24') DateCheck3,
ISDATE('2022') DateCheck4,
ISDATE('08') DateCheck5

SELECT
  --CAST(OrderDate AS Date) OrderDate
  OrderDate,
  ISDATE(OrderDate) AS IsValidDate ,
  CASE WHEN ISDATE(OrderDate)=1 THEN CAST(OrderDate AS DATE)
  END NewOrderDate
FROM
(
SELECT '2025-08-20' AS OrderDate 
UNION
SELECT '2022-08-22' UNION
SELECT '2022-12-24' UNION
SELECT '2022-12' ) t

