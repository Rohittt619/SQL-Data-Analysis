-- Sales by Category
SELECT Category,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY Category;

-- Profit by Category
SELECT Category,
       SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category;

-- Sales by Region
SELECT Region,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY Region;

-- Sales by Segment
SELECT Segment,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY Segment;