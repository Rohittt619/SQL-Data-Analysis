SELECT
    `Customer Name`,
    Sales,
    CASE
        WHEN Sales > 1000 THEN 'High Sales'
        WHEN Sales > 500 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS Sales_Category
FROM superstore;