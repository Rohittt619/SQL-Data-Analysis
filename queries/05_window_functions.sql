SELECT
    `Customer Name`,
    SUM(Sales) AS total_sales,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS sales_rank
FROM superstore
GROUP BY `Customer Name`;


SELECT
    Category,
    SUM(Sales) AS total_sales,
    DENSE_RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS category_rank
FROM superstore
GROUP BY Category;