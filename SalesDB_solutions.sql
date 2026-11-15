-- =====================================================================
-- SQL & Relational Database Design - Combined Student Assignment Pack
-- Student: Mehdi Ibrahimli          Group: 845i
-- DBMS: MySQL / MariaDB syntax (SQL Server / PostgreSQL alternatives
--       are noted in comments where the syntax differs)
-- =====================================================================


-- =====================================================================
-- PART I - DATABASE SETUP
-- =====================================================================

CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- ---------------------------------------------------------------------
-- A. Create the four tables (parents first, then Orders)
-- ---------------------------------------------------------------------

CREATE TABLE Customers (
    CustomerID  INTEGER      PRIMARY KEY,
    FirstName   VARCHAR(50),
    LastName    VARCHAR(50),
    Country     VARCHAR(50),
    Score       INTEGER
);

CREATE TABLE Products (
    ProductID   INTEGER        PRIMARY KEY,
    Product     VARCHAR(100),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID  INTEGER        PRIMARY KEY,
    FirstName   VARCHAR(50),
    LastName    VARCHAR(50),
    Department  VARCHAR(50),
    BirthDate   DATE,
    Gender      VARCHAR(10),
    Salary      DECIMAL(10,2),
    ManagerID   INTEGER,                         -- self-reference (manager)
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID       INTEGER        PRIMARY KEY,
    ProductID     INTEGER,
    CustomerID    INTEGER,
    SalesPersonID INTEGER,
    OrderDate     DATE,
    ShipDate      DATE,                          -- NULL = not shipped yet
    OrderStatus   VARCHAR(30),
    ShipAddress   VARCHAR(150),
    BillAddress   VARCHAR(150),
    Quantity      INTEGER,
    Sales         DECIMAL(10,2),
    CreationTime  DATETIME,
    FOREIGN KEY (ProductID)     REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID)    REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);

-- ---------------------------------------------------------------------
-- C. Insert sample data (same IDs used consistently across tables)
-- ---------------------------------------------------------------------

INSERT INTO Customers (CustomerID, FirstName, LastName, Country, Score) VALUES
(1, 'Ayla',  'Karimova', 'Azerbaijan', 720),
(2, 'John',  'Miller',   'USA',        450),
(3, 'Emma',  'Schmidt',  'Germany',    860),
(4, 'Sara',  'Martin',   'France',     280),
(5, 'Lukas', 'Weber',    'Germany',    550);

INSERT INTO Products (ProductID, Product, Category, Price) VALUES
(101, 'Wireless Mouse', 'Electronics', 55.00),
(102, 'Office Chair',   'Furniture',   230.00),
(103, 'Laptop',         'Electronics', 850.00),
(104, 'Notebook',       'Stationery',  12.00),
(105, 'Smart Phone',    'Electronics', 420.00);

-- Employee 11 is the manager (ManagerID NULL); 12 and 13 report to 11
INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(11, 'David', 'Lee',   'Sales',   '1985-03-14', 'Male',   2200.00, NULL),
(12, 'Maya',  'Brown', 'Sales',   '1990-07-22', 'Female', 2400.00, 11),
(13, 'Alex',  'Green', 'Support', '1992-11-05', 'Male',   1900.00, 11);

-- Orders 201-204 are the required rows. Extra rows (105, 110, 111, 112, 999)
-- are added so that every scenario query returns meaningful results and so
-- that the IDs used in Assignment 2 (105, 110, 999) exist.
INSERT INTO Orders (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime) VALUES
(201, 101, 1, 11, '2026-10-04', '2026-10-06', 'Delivered', '12 Nizami St, Baku',        '12 Nizami St, Baku',        2,  110.00, '2026-10-04 09:15:00'),
(202, 103, 3, 12, '2026-10-08', '2026-10-10', 'Shipped',   '5 Hauptstrasse, Berlin',    '5 Hauptstrasse, Berlin',    1,  850.00, '2026-10-08 11:30:00'),
(203, 102, 2, 11, '2026-10-12', NULL,         'Pending',   '77 Broadway, New York',     '77 Broadway, New York',     1,  230.00, '2026-10-12 14:05:00'),
(204, 105, 5, 12, '2026-10-15', '2026-10-25', 'Delivered', '9 Marktplatz, Munich',      '9 Marktplatz, Munich',      1,  420.00, '2026-10-15 10:45:00'),
(105, 103, 3, 12, '2026-10-20', NULL,         'Pending',   '5 Hauptstrasse, Berlin',    '5 Hauptstrasse, Berlin',    3, 2550.00, '2026-10-20 16:20:00'),
(110, 102, 2, 11, '2026-10-22', '2026-10-24', 'Shipped',   '77 Broadway, New York',     '77 Broadway, New York',     2,  460.00, '2026-10-22 08:50:00'),
(111, 105, 1, 11, '2026-09-28', '2026-10-09', 'Delivered', '12 Nizami St, Baku',        '12 Nizami St, Baku',        4, 1680.00, '2026-09-28 13:10:00'),
(112, 103, 3, 12, '2026-10-30', '2026-11-02', 'Delivered', '5 Hauptstrasse, Berlin',    '5 Hauptstrasse, Berlin',    2, 1700.00, '2026-10-30 17:40:00'),
(999, 101, 2, 13, '2026-10-31', NULL,         'Pending',   'TEST ADDRESS',              'TEST ADDRESS',              1,    0.00, '2026-10-31 12:00:00');

-- ---------------------------------------------------------------------
-- D. Verify each table
-- ---------------------------------------------------------------------
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Employees;
SELECT * FROM Orders;


-- =====================================================================
-- PART I - TEN FOUNDATIONAL SQL EXERCISES
-- =====================================================================

-- Task 1 - Explore a table: all columns, then only three columns
SELECT * FROM Customers;
SELECT FirstName, LastName, Country FROM Customers;

-- Task 2 - Filter by country: customers from Germany
SELECT CustomerID, FirstName, LastName, Country
FROM Customers
WHERE Country = 'Germany';

-- Task 3 - Combine conditions: Score >= 300 and Germany or France
SELECT CustomerID, FirstName, LastName, Country, Score
FROM Customers
WHERE Score >= 300
  AND Country IN ('Germany', 'France');

-- Task 4 - Sort products from most to least expensive
SELECT ProductID, Product, Category, Price
FROM Products
ORDER BY Price DESC;

-- Task 5 - Products priced between 50 and 300 (BETWEEN is inclusive)
SELECT Product, Price
FROM Products
WHERE Price BETWEEN 50 AND 300;

-- Task 6 - Product names containing the word "Phone"
SELECT Product, Category
FROM Products
WHERE Product LIKE '%Phone%';

-- Task 7 - Unique categories in alphabetical order
SELECT DISTINCT Category
FROM Products
ORDER BY Category;

-- Task 8 - Each OrderID with the first and last name of its customer
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders AS o
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID;

-- Task 9 - Number of orders and total Sales per OrderStatus (highest Sales first)
SELECT OrderStatus,
       COUNT(*)   AS NumberOfOrders,
       SUM(Sales) AS TotalSales
FROM Orders
GROUP BY OrderStatus
ORDER BY TotalSales DESC;

-- Task 10 - Safe data change (INSERT -> UPDATE -> verify -> DELETE)
-- 10a. Insert a new product with an unused ID (900)
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (900, 'Test Headphones', 'Electronics', 40.00);

-- 10b. Update only its price
UPDATE Products
SET Price = 45.00
WHERE ProductID = 900;

-- 10c. Verify the update
SELECT * FROM Products WHERE ProductID = 900;

-- 10d. Delete only the new product
DELETE FROM Products
WHERE ProductID = 900;

-- Explanation: UPDATE and DELETE must have a WHERE clause because without it
-- they apply to EVERY row in the table. UPDATE Products SET Price = 45.00;
-- would change the price of all products, and DELETE FROM Products; would
-- erase all products. WHERE limits the change to exactly the intended row(s).


-- =====================================================================
-- PART II - ASSIGNMENT 1: CUSTOMER LOYALTY AND SALES ANALYSIS
-- =====================================================================

-- Assignment 1, Task 1: High-score customers (Score > 500), highest score first
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Score > 500
ORDER BY Score DESC;

-- Assignment 1, Task 2: Target countries (Germany, France, USA) with Score >= 300
SELECT FirstName, LastName, Country, Score
FROM Customers
WHERE Country IN ('Germany', 'France', 'USA')
  AND Score >= 300;

-- Assignment 1, Task 3: Purchase history - customer full name with each order
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderID, o.OrderDate, o.Sales
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;

-- Assignment 1, Task 4: Inactive customers (never ordered)
-- LEFT JOIN keeps customers without orders; the NULL check finds them.
SELECT c.CustomerID, c.FirstName, c.LastName, c.Country
FROM Customers AS c
LEFT JOIN Orders AS o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Assignment 1, Task 5: Total spending per customer (with at least one order)
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSales DESC;

-- Assignment 1, Task 6: Loyalty threshold - customers with total Sales > 1000
-- HAVING filters AFTER aggregation (WHERE cannot use SUM).
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       SUM(o.Sales) AS TotalSales
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(o.Sales) > 1000
ORDER BY TotalSales DESC;

-- Assignment 1, Task 7: Top-five customers by total Sales
-- (SQL Server: use SELECT TOP 5 ... instead of LIMIT 5)
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       c.Country,
       SUM(o.Sales) AS TotalSpending
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Country
ORDER BY TotalSpending DESC
LIMIT 5;


-- =====================================================================
-- PART II - ASSIGNMENT 2: ORDER AND DELIVERY INVESTIGATION
-- =====================================================================

-- Assignment 2, Task 1: Orders placed in October 2026 (inclusive range)
SELECT OrderID, CustomerID, OrderDate, ShipDate, OrderStatus
FROM Orders
WHERE OrderDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY OrderDate;

-- Assignment 2, Task 2: Pending queue, oldest first
SELECT *
FROM Orders
WHERE OrderStatus = 'Pending'
ORDER BY OrderDate ASC;

-- Assignment 2, Task 3: Late shipments (ShipDate > 7 days after OrderDate)
-- MySQL: DATEDIFF(end, start). SQL Server: DATEDIFF(day, OrderDate, ShipDate) > 7
-- Orders with ShipDate NULL are automatically excluded (NULL comparison).
SELECT o.OrderID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate, o.ShipDate
FROM Orders AS o
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 4: Customers (name and country) affected by delayed orders
SELECT DISTINCT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
                c.Country
FROM Orders AS o
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE DATEDIFF(o.ShipDate, o.OrderDate) > 7;

-- Assignment 2, Task 5: Status correction for OrderID 105
-- Preview first, then update only that row, then verify.
SELECT * FROM Orders WHERE OrderID = 105;
UPDATE Orders
SET OrderStatus = 'Shipped',
    ShipDate    = '2026-11-05'
WHERE OrderID = 105;
SELECT * FROM Orders WHERE OrderID = 105;

-- Assignment 2, Task 6: Address correction for OrderID 110
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;
UPDATE Orders
SET ShipAddress = '45 Main Street, Baku'
WHERE OrderID = 110;
SELECT OrderID, ShipAddress FROM Orders WHERE OrderID = 110;

-- Assignment 2, Task 7: Remove temporary test record (OrderID 999 only)
SELECT * FROM Orders WHERE OrderID = 999;
DELETE FROM Orders
WHERE OrderID = 999;

-- Assignment 2, Task 8: Status distribution
SELECT OrderStatus, COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- Assignment 2, Task 9: Unshipped orders (ShipDate IS NULL, never "= NULL")
SELECT o.OrderID,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       o.OrderDate, o.OrderStatus
FROM Orders AS o
INNER JOIN Customers AS c ON o.CustomerID = c.CustomerID
WHERE o.ShipDate IS NULL;


-- =====================================================================
-- PART II - ASSIGNMENT 3: PRODUCTS AND EMPLOYEE PERFORMANCE
-- =====================================================================

-- Assignment 3, Task 1: Affordable products (50-300), cheapest first
SELECT Product, Category, Price
FROM Products
WHERE Price BETWEEN 50 AND 300
ORDER BY Price ASC;

-- Assignment 3, Task 2: Premium electronics (Price > 500)
SELECT *
FROM Products
WHERE Category = 'Electronics'
  AND Price > 500;

-- Assignment 3, Task 3: Product sales - product, category, quantity, sales
SELECT p.Product, p.Category, o.Quantity, o.Sales
FROM Products AS p
INNER JOIN Orders AS o ON p.ProductID = o.ProductID;

-- Assignment 3, Task 4: Best-selling products by total Quantity (top 5)
-- (SQL Server: SELECT TOP 5 ...)
SELECT p.Product, SUM(o.Quantity) AS TotalQuantity
FROM Products AS p
INNER JOIN Orders AS o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Product
ORDER BY TotalQuantity DESC
LIMIT 5;

-- Assignment 3, Task 5: Unsold items (no matching order)
SELECT p.ProductID, p.Product, p.Category, p.Price
FROM Products AS p
LEFT JOIN Orders AS o ON p.ProductID = o.ProductID
WHERE o.OrderID IS NULL;

-- Assignment 3, Task 6: Employee performance - total Sales per employee
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department;

-- Assignment 3, Task 7: Top-performing staff (total Sales > 5000), highest first
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
       e.Department,
       SUM(o.Sales) AS TotalSales
FROM Employees AS e
INNER JOIN Orders AS o ON e.EmployeeID = o.SalesPersonID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Department
HAVING SUM(o.Sales) > 5000
ORDER BY TotalSales DESC;

-- Assignment 3, Task 8: Register a new product (ID 501)
INSERT INTO Products (ProductID, Product, Category, Price)
VALUES (501, 'Wireless Keyboard', 'Electronics', 75.00);

-- Assignment 3, Task 9: Price correction for ProductID 501 (75 -> 90)
UPDATE Products
SET Price = 90.00
WHERE ProductID = 501;

-- Assignment 3, Task 10: Add inventory column to Products
ALTER TABLE Products
ADD StockQuantity INTEGER;

-- Assignment 3, Task 11: Combined directory of unique names (UNION removes duplicates)
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees;

-- Assignment 3, Task 12: Category performance - only categories with Sales > 2000
SELECT p.Category,
       SUM(o.Quantity) AS TotalQuantity,
       SUM(o.Sales)    AS TotalSales
FROM Products AS p
INNER JOIN Orders AS o ON p.ProductID = o.ProductID
GROUP BY p.Category
HAVING SUM(o.Sales) > 2000
ORDER BY TotalSales DESC;

-- =====================================================================
-- END OF FILE
-- =====================================================================
