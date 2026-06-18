-- Products with sales above average

SELECT `Product Name`,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Product Name`
HAVING total_sales >
(
    SELECT AVG(Sales)
    FROM superstore
);

-- Customers spending above average

SELECT `Customer Name`,
       SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Customer Name`
HAVING total_sales >
(
    SELECT AVG(Sales)
    FROM superstore
);