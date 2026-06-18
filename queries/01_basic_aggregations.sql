-- Total Sales
SELECT SUM(Sales) AS Total_Sales
FROM superstore;

-- Total Profit
SELECT SUM(Profit) AS Total_Profit
FROM superstore;

-- Average Discount
SELECT AVG(Discount) AS Average_Discount
FROM superstore;

-- Total Orders
SELECT COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore;

-- Total Customers
SELECT COUNT(DISTINCT `Customer ID`) AS Total_Customers
FROM superstore;

-- Total Quantity Sold
SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM superstore;