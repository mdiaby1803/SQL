-- Create a database
CREATE DATABASE RetailStoreDB;

-- Use the created database
USE RetailStoreDB;

-- Create a table for customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(50),
    Country VARCHAR(50)
);

-- Create a table for products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

-- Create a table for orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create a table for order details
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert data into the Customers table
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, Country) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Elm Street', 'New York', 'USA'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak Street', 'Los Angeles', 'USA'),
('Alice', 'Johnson', 'alice.johnson@example.com', '5556667777', '789 Pine Street', 'Chicago', 'USA');

-- Insert data into the Products table
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Laptop', 'Electronics', 999.99, 50),
('Smartphone', 'Electronics', 599.99, 100),
('Tablet', 'Electronics', 299.99, 200),
('Headphones', 'Accessories', 49.99, 300),
('Keyboard', 'Accessories', 19.99, 150);

-- Insert data into the Orders table
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-06-01', 1649.97),
(2, '2024-06-02', 1199.98),
(3, '2024-06-03', 399.98);

-- Insert data into the OrderDetails table
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 599.99),
(1, 4, 1, 49.99),
(2, 2, 2, 599.99),
(3, 3, 2, 299.99);

-- Query to get all customers
SELECT * FROM Customers;

-- Query to get all products
SELECT * FROM Products;

-- Query to get all orders
SELECT * FROM Orders;

-- Query to get all order details
SELECT * FROM OrderDetails;

-- Query to get total sales amount
SELECT SUM(TotalAmount) AS TotalSales FROM Orders;

-- Query to get the number of orders per customer
SELECT Customers.FirstName, Customers.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CustomerID;

-- Query to get the total quantity sold per product
SELECT Products.ProductName, SUM(OrderDetails.Quantity) AS TotalQuantitySold
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductID;

-- Query to get the average order amount
SELECT AVG(TotalAmount) AS AverageOrderAmount FROM Orders;

-- Query to get the top 3 customers by total spending
SELECT Customers.FirstName, Customers.LastName, SUM(Orders.TotalAmount) AS TotalSpending
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CustomerID
ORDER BY TotalSpending DESC
LIMIT 3;
