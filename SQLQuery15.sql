/* row functions can be single row functions like UPPER, LOWER, LEN, etc. or multi row functions like SUM, AVG, COUNT, etc. 
SINGLE ROW FUNCTIONS ARE FURTHER DEVIDED INTO STRING FUNCTION, NUMERIC FUNCTION, DATE TIME FUNCTION AND NULL FUNCTION
MULTI ROW FUNCTIONS ARE FURTHER DIVIDED INTO AGGREGATE FUNCTION AND WINDOW FUNCTION*/

INSERT INTO Sales.Customers (CustomerID, FirstName, LastName, Country, Score)
VALUES
( 7, ' Jane  ','Smith', 'UK', 90),
( 8, '   Michael','Johnson', 'Canada', 78),
( 9, ' Emily  ','Davis', 'Australia', 92),
(10, ' David ','Wilson', 'Germany', 80)
    

-- STRING FUNCTION(REPLACE, CONCAT, TRIM, REPLACE, LEN, LEFT, RIGHT, SUBSTRING)
SELECT 
     REPLACE('123-456-7890','-', ' ') AS Replaced_Phone,
         CONCAT(FirstName,' ' , LastName) AS Full_Name,
         LEFT(TRIM(CONCAT(FirstName,' ' , LastName)), 5) AS Left5_Full_Name,
         RIGHT(TRIM(CONCAT(FirstName,' ' , LastName)), 5) AS RIGHT5_Full_Name,
        UPPER(FirstName) AS UPPER_FirstName,
         LOWER(LastName) AS LOWER_LastName,
         LEN(FirstName) AS FirstName_Length,
       --  LTRIM(FirstName) AS LTRIM_FirstName,
       --  LEN(LTRIM(FirstName))AS LTRIM_FirstNameLen,
       --  RTRIM(FirstName) AS RTRIM_FirstName,
        -- LEN(RTRIM(FirstName))AS RTRIM_FirstNameLen,
         TRIM(FirstName) AS TRIM_FirstName,
         LEN(TRIM(FirstName))AS TRIM_FirstNameLen,
         [Country],
         REPLACE(Country,'Germany','AUSTRALIA') AS Replaced_Country

FROM Sales.Customers

SELECT
  FirstName,
  SUBSTRING(FirstName, 4, 1) AS First_Char,--SUBSTRING(string, start_position, length)--> it will return the substring of the string starting from the start_position and of the specified length
  SUBSTRING(FirstNAme, 4, LEN(FirstName)) AS Middle_Chars
  FROM Sales.Customers



--TASK: FIND CUSTOMERS WHOSE FIRST NAME HAS TRAILING OR LEADING SPACES AND REMOVE THEM
SELECT
FirstName,
TRIM(FirstName) AS Trimmed_FirstName,
LEN(FirstName)-LEN(TRIM(FirstName)) AS FLAG-- if FLAG<>0 then there are leading or trailing spaces
FROM Sales.Customers
--WHERE TRIM(FirstName) <> FirstName

--NUMERIC FUNCTION( ROUND,ABS)
SELECT
 3.516,
 ROUND(3.516, 2) AS Rounded_2_Decimals,
 ROUND(3.516, 1) AS Rounded_1_Decimal,
 ROUND(3.516, 0) AS Rounded_0_Decimals,
 ROUND(3.516, -1) AS Rounded_Negative_1_Decimal

 SELECT
  -5.7,
  ABS(-5.7) AS Absolute_Value,
  4.8 ,
   ABS(4.8) AS Absolute_Value2
