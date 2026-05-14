/* HOW TO USE SET OPERATORS EFFECTIVELY IN PROJECTS
1.COMBINE SIMILAR INFO BEFORE ANALYZING USING UNION OR UNION ALL
2. USE SQL QUERY ON THE NEW BIGGER TABLE FOR THE REPORTS

TASK: ORDERS ARE STORED IN SEPARATE TABLES(ORDERS, ORDERARCHIVE).
COMBINE ALL ORDERS INTO ONE REPORT WITHOUT DUPLICATES
*/

SELECT *
FROM Sales.Orders

SELECT *
FROM Sales.OrdersArchive

SELECT 
 'ORDERS' AS SOURCE_TABLE,
  OrderID,
  ProductID,
  CustomerID,
  SalesPersonID,
  OrderDate,
  ShipDate,
  OrderStatus,
  ShipAddress,
  BillAddress,
  Quantity,
  Sales,
  CreationTime
FROM Sales.Orders

union

SELECT 
'ORDERSARCHIVE' AS SOURCE_TABLE,
  OrderID,
  ProductID,
  CustomerID,
  SalesPersonID,
  OrderDate,
  ShipDate,
  OrderStatus,
  ShipAddress,
  BillAddress,
  Quantity,
  Sales,
  CreationTime
FROM Sales.OrdersArchive

ORDER BY OrderID