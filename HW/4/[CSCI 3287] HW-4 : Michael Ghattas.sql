
/* 
Class:			CSCI-3287
Semester:		Spring-2023
Assignment:		HW-4
Name:			Michael Ghattas
SID:			109200649
*/

/* Write SQL scripts for below questions: */
USE HW_4_SQL;

-- 1. Show a list the Company Name and Country for all Suppliers located in Japan or Germany.
SELECT CompanyName AS "Company Name", Country
FROM hwSuppliers
WHERE Country IN ('Japan', 'Germany')
;

-- 2. Show a list of Product Name, Quantity per Unit and Unit Price for products with a Unit Price less than $7 but more than $ 4.
SELECT ProductName AS "Product Name", QuantityPerUnit AS "Quantity Per Unit",  UnitPrice AS "Unit Price"
FROM hwProducts
WHERE UnitPrice BETWEEN 4 AND 7 
ORDER BY UnitPrice
;

-- 3. Show a list of Company Name, City and Country for Customers whose Country is USA and City is Portland, OR Country is Canada and City is Vancouver.
SELECT CompanyName AS "Company Name", City, Country
FROM hwCustomers
WHERE (Country = 'USA' AND City = 'Portland') OR (Country = 'Canada' AND City = 'Vancouver')
;

-- 4. Show a list the Contact Name and Contact Title for all Suppliers with a SupplierID from 5 to 8 (inclusive) and sort in descending order by ContactName.
SELECT ContactName AS "Contact Name", ContactTitle AS "Contact Title"
FROM hwSuppliers
WHERE SupplierID BETWEEN 5 AND 8 
ORDER BY ContactName DESC
;

-- 5. Show a product name and unit price of the least expensive product (i.e., lowest unit price)? You MUST use a Sub Query.
SELECT ProductName AS "Product Name", UnitPrice AS "Unit Price"
FROM
(
	SELECT ProductName, UnitPrice,
		RANK() OVER (ORDER BY UnitPrice) AS Rnk
	FROM hwProducts
) AS final
WHERE final.Rnk = 1
;

-- 6. Display Ship Country and their Order Count for all Ship Country except USA for Shipped Date between May 4th and 10th 2015 whose Order Count is greater than 3.
SELECT ShipCountry AS "Ship Country", COUNT(*) AS OrderCount
FROM hwOrders
WHERE ShipCountry != 'USA' AND ShippedDate BETWEEN '2015-05-04' AND '2015-05-10'
GROUP BY ShipCountry
HAVING OrderCount > 3
;

-- 7. Show a list of all employees with their first name, last name and hiredate (formated to mm/dd/yyyy) who are NOT living in the USA and have been employed for at least 5 years.
SELECT FirstName AS "First Name", LastName AS "Last Name", DATE_FORMAT(HireDate, "%m/%d/%Y") AS "Hire Date"
FROM hwEmployees
WHERE Country <> 'USA' AND HireDate <= DATE_SUB(NOW(), INTERVAL 5 YEAR)
;

-- 8. Show a list of Product Name and their 'Inventory Value' (Inventory Value = units in stock multiplied by their unit price) for products whose 'Inventory Value' is over 3000 but less than 4000.
SELECT ProductName, (UnitsInStock * UnitPrice) AS InventoryValue
FROM hwProducts
WHERE UnitsInStock * UnitPrice > 3000 AND UnitsInStock * UnitPrice < 4000
ORDER BY InventoryValue DESC
;

-- 9. Show a list of Products' product Name, Unit in Stock and ReorderLevel level whose Product Name starts with 'S' that are currently in stock (i.e., at least one Unit in Stock) and Unit in Stock is at or below the reorder level.
SELECT ProductName AS "Product Name", UnitsInStock AS "Units In Stock", ReorderLevel AS "Reorder Level"
FROM hwProducts
WHERE ProductName LIKE 'S%' AND UnitsInStock > 0 AND UnitsInStock <= ReorderLevel
;

-- 10. Show a list of Product Name, Unit Price and Quantity Per Unit for all products, whose Quantity Per Unit has/measure in 'box' that have been discontinued (i.e., discontinued = 1).
SELECT ProductName AS "Product Name", UnitPrice AS "Unit Price", QuantityPerUnit AS "Quantity Per Unit"
FROM hwProducts
WHERE QuantityPerUnit LIKE '%box%' AND Discontinued = 1
;

-- 11. Show a list of Product Name and their TOTAL inventory value (inventory value = UnitsInStock * UnitPrice) for Supplier's Country from Japan.
SELECT ProductName AS "Product Name", (p.UnitsInStock * p.UnitPrice) AS "Total Inventory Value"
FROM hwProducts p
INNER JOIN hwSuppliers s ON p.SupplierID = s.SupplierID AND s.Country = 'Japan'
;

-- 12. Show a list of customer's country and their count that is greater than 8.
SELECT Country AS "Customer's Country", COUNT(CustomerID) AS "Customers Count"
FROM hwCustomers
GROUP BY Country
HAVING COUNT(CustomerID) > 8
;

-- 13. Show a list of Orders' Ship Country, Ship City and their Order count for Ship Country 'Austria' or 'Argentina'.
SELECT ShipCountry AS "Ship Country", ShipCity AS "Ship City", COUNT(*) AS "Number of Orders"
FROM hwOrders
WHERE ShipCountry IN ('Austria', 'Argentina')
GROUP BY ShipCountry, ShipCity
;

-- 14. Show a list of Supplier's Company Name and Product's Product Name for supplier's country from Spain.
SELECT s.CompanyName AS "Company Name", p.ProductName AS "Product Name"
FROM hwSuppliers s
INNER JOIN hwProducts p ON s.SupplierID = p.SupplierID
WHERE s.Country = 'Spain'
;

-- 15. What is the 'Average Unit Price' (rounded to two decimal places) of all the products whose ProductName ends with 'T'?
SELECT ROUND(AVG(UnitPrice), 2) AS "Average Unit Price", ProductName AS "Product Name"
FROM hwProducts
WHERE ProductName LIKE '%T'
GROUP BY ProductName
;

-- 16. Show a list of employee's full name (i.e., firstname, lastname, e.g., Harrison Ford), title and their Order count for employees who has more than 120 orders.
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS "Full Name", e.Title AS "Title", COUNT(o.OrderID) AS "Number of Orders"
FROM hwEmployees e
JOIN hwOrders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID
HAVING COUNT(o.OrderID) > 120
;

-- 17. Show a list customer's company Name and their country who has NO Orders on file (i.e., NULL Orders).
SELECT c.CompanyName AS "Company Name", c.Country AS "Country"
FROM hwCustomers c
LEFT JOIN hwOrders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
;

-- 18. Show a list of Category Name and Product Name for all products that are currently out of stock (i.e. UnitsInStock = 0).
SELECT c.CategoryName AS "Category Name", p.ProductName AS "Product Name"
FROM hwProducts p
INNER JOIN hwCategories c ON p.CategoryID = c.CategoryID
WHERE p.UnitsInStock = 0
GROUP BY c.CategoryName, p.ProductName
;

-- 19. Show a list of products' Product Name and Quantity Per Unit, which are measured in 'pkg' or 'pkgs' or 'jars' for a supplier’s country from Japan.
SELECT ProductName AS "Product Name", QuantityPerUnit AS "Quantity Per Unit"
FROM hwProducts
WHERE (QuantityPerUnit LIKE '%pkg' OR QuantityPerUnit LIKE '%pkgs' OR QuantityPerUnit LIKE '%jars')
AND SupplierID IN (SELECT SupplierID FROM hwSuppliers WHERE Country = 'Japan')
;

-- 20. Show a list of customer's company name, Order’s ship name and total value of all their orders (rounded to 2 decimal places) for customers from Mexico. (value of order = (UnitPrice * Quantity) less discount. Discount is given in % e.g., 0.10 means 10%).
SELECT c.CompanyName AS "Company Name", o.ShipName AS "Ship Name", ROUND(SUM((r.UnitPrice * r.Quantity) * (1 - r.Discount)), 2) AS "Total Orders Value"
FROM hwCustomers c
JOIN hwOrders o ON c.CustomerID = o.CustomerID
JOIN hwOrderDetails r ON o.OrderID = r.OrderID
WHERE c.Country = 'Mexico'
GROUP BY c.CompanyName, o.ShipName
;

-- 21. Show a list of products' Product Name and suppliers' Region whose product name starts with 'L' and Region is NOT blank/empty.
SELECT p.ProductName AS "Product Name", s.Region AS "Supplier Region"
FROM hwProducts p
INNER JOIN hwSuppliers s ON p.SupplierID = s.SupplierID
WHERE p.ProductName LIKE 'L%' AND s.Region IS NOT NULL AND s.Region <> ''
GROUP BY p.ProductName, s.Region
;

-- 22. Show a list of Order's Ship Country, Ship Name and Order Date (formatted as MonthName and Year, e.g. March 2015) for all Orders from 'Versailles' Ship City whose Customer's record doesn't exists in Customer table.
SELECT o.ShipCountry AS "Ship Country", o.ShipName AS "Ship Name", DATE_FORMAT(o.OrderDate, "%M %Y") AS "Order Date"
FROM hwOrders o
LEFT JOIN hwCustomers c ON o.CustomerID = c.CustomerID
WHERE o.ShipCity = 'Versailles' AND c.CustomerID IS NULL
GROUP BY o.ShipCountry, o.ShipName, o.OrderDate
;

-- 23. Show a list of products' Product Name and Units In Stock whose Product Name starts with 'F' and Rank them based on UnitsInStock from highest to lowest (i.e., highest UnitsInStock rank = 1, and so on). Display rank number as well.
SELECT ProductName AS "Product Name", UnitsInStock AS "Units In Stock", Rnk AS "Rank"
FROM
(
	SELECT ProductName, UnitsInStock,
		RANK() OVER (ORDER BY UnitsInStock) AS Rnk
	FROM hwProducts
    WHERE ProductName LIKE 'F%'
    GROUP BY ProductName, UnitsInStock
) AS final
ORDER BY final.Rnk DESC
;

-- 24. Show a list of products' Product Name and Unit Price for ProductID from 1 to 5 (inclusive) and Rank them based on UnitPrice from lowest to highest. Display rank number as well.
SELECT ProductName AS "Product Name", UnitPrice AS "Unit Price", 
    RANK() OVER (ORDER BY UnitPrice ASC) AS "Rank"
FROM hwProducts
WHERE ProductID BETWEEN 1 AND 5
ORDER BY UnitPrice ASC;
;

-- 25. Show a list of employees' first name, last name, country and date of birth (formatted to mm/dd/yyyy) who were born after 1984 and Rank them by date of birth (oldest employee rank 1st, and so on) for EACH country i.e., Rank number should reset/restart for EACH country. Display rank number as well.
SELECT FirstName AS "First Name", LastName AS "Last Name", Country, DATE_FORMAT(BirthDate, "%m/%d/%Y") AS "Order Date",
   RANK() OVER(PARTITION BY Country ORDER BY BirthDate) AS "Country Rank"
FROM hwEmployees
WHERE YEAR(BirthDate) > 1984
ORDER BY Country, BirthDate
;