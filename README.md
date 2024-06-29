# SQL Scripts for Demonstrating SQL Skills

## Overview

This repository contains two SQL scripts that demonstrate a range of SQL skills, from basic table creation and data insertion to more advanced querying techniques. These scripts are designed to showcase proficiency in SQL for database management and analysis.

## Contents

1. **`retail_store_db.sql`**: A basic script for a fictional retail store database.
2. **`online_retail_db.sql`**: An advanced script using a more complex dataset for an online retail store.

## retail_store_db.sql

This script sets up a simple database schema for a fictional retail store. It includes tables for customers, products, orders, and order details. The script covers basic SQL operations such as table creation, data insertion, and simple queries.

### Tables

- **Customers**: Stores customer information (CustomerID, FirstName, LastName, Email, Phone, Address, City, Country).
- **Products**: Stores product information (ProductID, ProductName, Category, Price, StockQuantity).
- **Orders**: Stores order information (OrderID, CustomerID, OrderDate, TotalAmount).
- **OrderDetails**: Stores detailed order information (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice).

### Key SQL Operations

- **Table Creation**: Defines the structure of each table.
- **Data Insertion**: Inserts sample data into each table.
- **Basic Queries**:
  - Select all records from a table.
  - Calculate total sales amount.
  - Count the number of orders per customer.
  - Calculate total quantity sold per product.
  - Calculate average order amount.
  - Identify top customers by total spending.

### Example Queries

```sql
-- Query to get total sales amount per customer
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalSpent
FROM OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY CustomerID;

-- Query to get the top 3 products by sales
SELECT ProductID, ProductName, SUM(Quantity) AS TotalSold
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY ProductID, ProductName
ORDER BY TotalSold DESC
LIMIT 3;


## online_retail_db.sql

This script uses a more complex dataset from an online retail store, similar to the "Online Retail" dataset from Kaggle. It demonstrates advanced SQL skills including window functions, subqueries, and complex joins.

### Tables

- **Customers**: Stores customer information (CustomerID, Country).
- **Products**: Stores product information (StockCode, Description, UnitPrice).
- **Orders**: Stores order information (InvoiceNo, InvoiceDate, CustomerID).
- **OrderDetails**: Stores detailed order information (OrderDetailID, InvoiceNo, StockCode, Quantity).

### Key SQL Operations

- **Table Creation**: Defines the structure of each table.
- **Data Insertion**: Inserts sample data into each table.
- **Advanced Queries**:
  - Calculate total sales amount per customer.
  - Identify top products by sales.
  - Analyze monthly sales trends.
  - Calculate average order value per country.
  - Compute cumulative sales per product.

### Example Queries

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

## License

This project is licensed under a custom license. See the [LICENSE](LICENSE) file for details.

## Copyright

© 2024 Meman Diaby. All rights reserved.

Permission is granted for non-commercial use and replication with proper citation.
