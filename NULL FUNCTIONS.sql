

--NULL FUNCTIONS(ISNULL, COALESCE, NULLIF)
--ISNULL(expression, replacement_value) -> replaces NULL with specified replacement value
SELECT 
ShipAddress,
BillAddress,
ISNULL(ShipAddress,'No Shipping Address') AS ShipAddressWithDefault,
ISNULL(BillAddress, ShipAddress ) AS BillAddressWithShipAddress,--still getting null values because even ship address is null
COALESCE(BillAddress, ShipAddress, 'No Address Available') AS BillAddressWithCoalesce --coalesce checks multiple values and returns the first non null value
FROM Sales.Orders


--Its important to handle null values before data aggregateion for accuracy in AVg, count, min, mAx functions
--ONly count(*) counts null values while count(column_name) does not count null values



--TAsk1: FInd The Avg Score of customers
SELECT
CustomerID,
Score,
Avg(Score) Over() AVgScoreWithNull,
AVG(ISNULL(Score,0)) Over() AS AvgScorewith0
FROM Sales.Customers

--Task2 : Display full names of all Customer in one field and add 10 bonus points
SELECT
FirstName+ ''+LastName as FullName1,
CONCAT(ISNULL(FirstName,''),' ',ISNULL(LastName,'')) AS FullName,
Score,
Score+10 AS ScoreWithBonus1,
ISNULL(Score,0)+10  as ScoreWithBonus
FROM Sales.Customers

--ADVANCED USE CASE OF NULL HANDLING: BEFORE PERFORMING JOINS


--USECASE2: BEFORE SORTING:BY DEFAULT, NULL VALUES ARE SORTED FIRST IN ASCENDING ORDER AND LAST IN DESCENDING ORDER. IF YOU WANT TO CHANGE THIS DEFAULT BEHAVIOR AND SORT NULLS LAST IN ASCENDING ORDER OR FIRST IN DESCENDING ORDER, YOU CAN USE ISNULL OR COALESCE TO REPLACE NULLS WITH A VALUE THAT WILL BE SORTED ACCORDING TO YOUR PREFERENCE.
--TASK: SORT CUSTOMERS BY Score IN ASCENDING ORDER BUT NULL VALUES SHOULD BE LAST
SELECT
CustomerID,
Score,
CASE WHEN SCORE IS NULL THEN 1 ELSE 0 END  FLAG
FROM Sales.Customers
ORDER BY CASE WHEN SCORE IS NULL THEN 1 ELSE 0 END ,Score --dont write flag here
 
--NULLIF (expression1, expression2) -> returns null if both expressions are equal 
--otherwise returns the value of expression1
--usecase1: AVOID DIVISION BY ZERO ERROR
--task1 :Find the sales price of each order by dividing sales by quantity
/*SELECT
OrderID,
Sales,
Quantity,
Sales/Quantity AS SalesPrice
FROM Sales.Orders*/

SELECT
OrderID,
Sales,
Quantity,
Sales/NULLIF(Quantity,0) AS SalesPrice --logic:if quantity=0, then exchange it with null to avoid error
FROM Sales.Orders

--IS NULL :returns true if the value is null else false
--IS NOT NULL: returns true if the value is not null else false

--task: find all customers with no scores
SELECT
CustomerID,
Score
FROM Sales.Customers
WHERE Score IS NULL
--task: find all customers with no orders
SELECT*
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL --for left join Customer id will be null in orders table if there is no order for that customer

--NULL VS EMPTY VS SPACE
--NULL: represents the absence of a value or unknown value (NULL)
--EMPTY STRING: represents a string with no characters, but it is still a value('')
--SPACE: represents a string that contains only space characters, it is also a value but visually appears empty('  ')
--WE CAN CLEAR SPACES USING TRIM FUNCTION AND SPECIFY THAT DATA SHOULDNOT HAVE ANY BLANK SPACES USING DATA POLICY


--CREATING A TEMPORARY DATA
WITH ORDERS AS (
SELECT 1 id, 'A' CATEGORY UNION
SELECT 2 , NULL UNION
SELECT 3 , '' UNION
SELECT 4 , '  ' 
)

SELECT
*,
TRIM(CATEGORY) POLICY1, --NO BLANK SPACES
NULLIF(TRIM(CATEGORY),'') POLICY2, -- USE ONLY NULLS
COALESCE(NULLIF(TRIM(CATEGORY),''),'N/A') POLICY3 --DONT USE NULL, BLANK SPACES OR EMPTY
FROM Orders
--I WONDER WHATS THE DIFFERENCE -WHEN I PERFORMED POLICY 2 AND 3 WITHOUT TRIM I GOT SAME ANS

--POLICY 2 IS BEST FOR OPTIMISATION AS NULL TAKES VERY LESS SPACE
--POLICY 3 IS BEST FOR REPORTING TO AVOID CONFUSION AND IMPROVE READABILITY
 
 -----CASE STATEMENTS:EVALUATES A LIST OF VALUES AND RETURN A VALUE WHEN 1ST CONDITION IS MET
 /*SYNTAX:

 CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN condition3 THEN result3
    ...
    ELSE RESULT --- THIS IS OPTIONAL (USED ONLY WHEN ALL CONDITIONS FAIL)
END
*/
--START NEXT TIME FROM 8:15:00