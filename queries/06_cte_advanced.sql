WITH category_sales AS
(
    SELECT
        Category,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY Category
)

SELECT *
FROM category_sales
ORDER BY total_sales DESC;

WITH customer_sales AS
(
    SELECT
        `Customer Name`,
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY `Customer Name`
)

SELECT *
FROM customer_sales
WHERE total_sales > 5000;