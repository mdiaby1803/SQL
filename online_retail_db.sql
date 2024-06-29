-- Create a database
CREATE DATABASE OnlineRetailDB;

-- Use the created database
USE OnlineRetailDB;

-- Create a table for customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Country VARCHAR(50)
);

-- Create a table for products
CREATE TABLE Products (
    StockCode VARCHAR(20) PRIMARY KEY,
    Description VARCHAR(255),
    UnitPrice DECIMAL(10, 2)
);

-- Create a table for orders
CREATE TABLE Orders (
    InvoiceNo VARCHAR(20) PRIMARY KEY,
    InvoiceDate DATETIME,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create a table for order details
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Quantity INT,
    FOREIGN KEY (InvoiceNo) REFERENCES Orders(InvoiceNo),
    FOREIGN KEY (StockCode) REFERENCES Products(StockCode)
);

-- Insert data into the Customers table
INSERT INTO Customers (CustomerID, Country) VALUES
(12345, 'United Kingdom'),
(12346, 'France'),
(12347, 'Australia');

-- Insert data into the Products table
INSERT INTO Products (StockCode, Description, UnitPrice) VALUES
('A123', 'Product A', 10.99),
('B456', 'Product B', 20.49),
('C789', 'Product C', 5.99);

-- Insert data into the Orders table
INSERT INTO Orders (InvoiceNo, InvoiceDate, CustomerID) VALUES
('INV001', '2024-06-01 12:34:56', 12345),
('INV002', '2024-06-02 14:20:00', 12346),
('INV003', '2024-06-03 09:15:30', 12347);

-- Insert data into the OrderDetails table
INSERT INTO OrderDetails (InvoiceNo, StockCode, Quantity) VALUES
('INV001', 'A123', 2),
('INV001', 'B456', 1),
('INV002', 'A123', 1),
('INV003', 'C789', 3);

-- Query to get total sales amount per customer
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpent
FROM OrderDetails
JOIN Orders ON OrderDetails.InvoiceNo = Orders.InvoiceNo
JOIN Products ON OrderDetails.StockCode = Products.StockCode
GROUP BY CustomerID;

-- Query to get the top 3 products by sales
SELECT StockCode, Description, SUM(Quantity) AS TotalSold
FROM OrderDetails
JOIN Products ON OrderDetails.StockCode = Products.StockCode
GROUP BY StockCode, Description
ORDER BY TotalSold DESC
LIMIT 3;

-- Query to get the monthly sales trends
SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, SUM(Quantity * UnitPrice) AS TotalSales
FROM Orders
JOIN OrderDetails ON Orders.InvoiceNo = OrderDetails.InvoiceNo
JOIN Products ON OrderDetails.StockCode = Products.StockCode
GROUP BY Month
ORDER BY Month;

-- Query to get the average order value per country
SELECT Customers.Country, AVG(OrderTotal) AS AvgOrderValue
FROM (
    SELECT Orders.CustomerID, SUM(Quantity * UnitPrice) AS OrderTotal
    FROM Orders
    JOIN OrderDetails ON Orders.InvoiceNo = OrderDetails.InvoiceNo
    JOIN Products ON OrderDetails.StockCode = Products.StockCode
    GROUP BY Orders.InvoiceNo
) AS OrderTotals
JOIN Customers ON OrderTotals.CustomerID = Customers.CustomerID
GROUP BY Customers.Country;

-- Query to get the cumulative sales per product
SELECT StockCode, Description, InvoiceDate, SUM(SUM(Quantity * UnitPrice)) OVER (PARTITION BY StockCode ORDER BY InvoiceDate) AS CumulativeSales
FROM OrderDetails
JOIN Orders ON OrderDetails.InvoiceNo = Orders.InvoiceNo
JOIN Products ON OrderDetails.StockCode = Products.StockCode
GROUP BY StockCode, Description, InvoiceDate
ORDER BY StockCode, InvoiceDate;
