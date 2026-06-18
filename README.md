🗃️ SQL Data Analysis — Superstore Dataset

> 15 business-driven SQL queries answering real analyst questions — from basic aggregations to advanced window functions and CTEs.

![SQL](https://img.shields.io/badge/SQL-MySQL%20%7C%20PostgreSQL-4479A1?logo=mysql&logoColor=white)
![Dataset](https://img.shields.io/badge/Dataset-Superstore-orange)
![Queries](https://img.shields.io/badge/Queries-15-blue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📌 Project Overview

This project demonstrates SQL skills across 15 queries of increasing complexity using the **Superstore Sales dataset**. Each query answers a real business question a data analyst would face.

**Skills covered:** `SELECT` · `GROUP BY` · `HAVING` · `JOIN` · Subqueries · `CASE WHEN` · Window functions · CTEs · Date functions

**Dataset:** [Superstore Sales — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
9,994 orders · 21 columns · US retail sales 2014–2017

---

## 🗂️ Project Structure

```
SQL-Data-Analysis/
│
├── data/
│   └── superstore.csv                   # raw dataset
│
│── images/
│   ├── total_rows.png
│   ├── total_orders.png
│   ├── total_sales.png
│   ├── total_profit.png
│   ├── category_sales.png
│   ├── window_function.png
│   └── cte_output.png
│
├── queries/
│   ├── 01_basic_aggregations.sql
│   ├── 02_group_by_analysis.sql
│   ├── 03_joins_and_subqueries.sql
│   ├── 04_case_when.sql
│   ├── 05_window_functions.sql
│   └── 06_cte_advanced.sql
│
├── setup/
│   └── create_table.sql                 # table schema + import instructions
│
└── README.md
```

---

## ⚙️ Database Setup

```sql
-- Run this first to create the table
CREATE TABLE superstore (
    row_id        INT,
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
    ship_mode     VARCHAR(30),
    customer_id   VARCHAR(20),
    customer_name VARCHAR(100),
    segment       VARCHAR(20),
    country       VARCHAR(50),
    city          VARCHAR(50),
    state         VARCHAR(50),
    region        VARCHAR(20),
    product_id    VARCHAR(20),
    category      VARCHAR(30),
    sub_category  VARCHAR(30),
    product_name  VARCHAR(200),
    sales         DECIMAL(10,2),
    quantity      INT,
    discount      DECIMAL(4,2),
    profit        DECIMAL(10,2)
);
```

> Load the CSV using your DB tool's import wizard, or use:
> `LOAD DATA INFILE 'superstore.csv' INTO TABLE superstore FIELDS TERMINATED BY ',' ...`

---

## 📋 The 15 Queries

---

### Q1 — Total sales, profit and orders overall

**Business question:** What is the company's overall performance?

```sql
SELECT
    COUNT(DISTINCT order_id)    AS total_orders,
    ROUND(SUM(sales), 2       AS total_sales,
    ROUND(SUM(profit), 2)       AS total_profit,
    ROUND(SUM(profit)
          / SUM(sales) * 100, 2) AS profit_margin_pct
FROM superstore;
```

**Expected result:** ~9,994 orders · $2.3M sales · $286K profit · 12.47% margin

---

### Q2 — Sales and profit by region

**Business question:** Which region is most profitable?

```sql
SELECT
    region,
    ROUND(SUM(sales), 2                    AS total_sales,
    ROUND(SUM(profit), 2                   AS total_profit,
    ROUND(SUM(profit/ SUM(sales) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id                AS total_orders
FROM  superstore
GROUP BY region
ORDER BY total_profit DESC;
```

**Key insight:** West has highest sales but East has better profit margins.

---

### Q3 — Top 5 most profitable sub-categories

**Business question:** Where should we focus our product strategy?

```sql
SELECT
    sub_category,
    ROUND(SUM(sales), 2  AS total_sales,
    ROUND(SUM(profit), 2 AS total_profit,
    ROUND(SUM(profit/ SUM(sales) * 100, 2) AS margin_pct
FROM  superstore
GROUP BY sub_category
ORDER BY total_profit DESC
LIMIT 5;
```

**Key insight:** Copiers, Phones, and Accessories lead — all in Technology.

---

### Q4 — Loss-making sub-categories

**Business question:** Where are we bleeding money?

```sql
SELECT
    sub_category,
    ROUND(SUM(sales), 2 AS total_sales,
    ROUND(SUM(profit), 2) AS total_loss,
    COUNT(*)              AS order_count
FROM  superstore
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_loss ASC;
```

**Key insight:** Tables lose ~$17K despite $206K in sales — discounts are the cause.

---

### Q5 — Monthly sales trend

**Business question:** Is there seasonality in our sales?

```sql
SELECT
    YEAR(order_date                 AS order_year,
    MONTH(order_date                AS order_month,
    DATE_FORMAT(order_date, '%b %Y')  AS month_label,
    ROUND(SUM(sales), 2)              AS monthly_sales,
    ROUND(SUM(profit), 2            AS monthly_profit
FROM  superstore
GROUP BY order_year, order_month, month_label
ORDER BY order_year, order_month;
```

**Key insight:** Q4 (Oct–Decconsistently accounts for ~30% of annual revenue.

---

### Q6 — Customer segment analysis

**Business question:** Which customer segment is most valuable?

```sql
SELECT
    segment,
    COUNT(DISTINCT customer_id     AS unique_customers,
    COUNT(DISTINCT order_id)         AS total_orders,
    ROUND(SUM(sales), 2)             AS total_sales,
    ROUND(SUM(profit), 2)            AS total_profit,
    ROUND(AVG(sales), 2            AS avg_order_value,
    ROUND(SUM(profit)
          / SUM(sales) * 100, 2)     AS profit_margin_pct
FROM  superstore
GROUP BY segment
ORDER BY total_profit DESC;
```

**Key insight:** Consumer segment has the most orders but Corporate has better margins.

---

### Q7 — Impact of discount on profitability (CASE WHEN)

**Business question:** Does heavy discounting destroy profit?

```sql
SELECT
    CASE
        WHEN discount = 0          THEN '0% — No discount'
        WHEN discount <= 0.10      THEN '1–10%'
        WHEN discount <= 0.20      THEN '11–20%'
        WHEN discount <= 0.30      THEN '21–30%'
        ELSE '> 30% — Heavy discount'
    END                            AS discount_band,
    COUNT(*                      AS order_count,
    ROUND(SUM(sales), 2)           AS total_sales,
    ROUND(SUM(profit), 2)          AS total_profit,
    ROUND(AVG(profit), 2)          AS avg_profit_per_order
FROM  superstore
GROUP BY discount_band
ORDER BY MIN(discount);
```

**Key insight:** Orders with 0% discount average +$43 profit. Orders >30% discount average −$69 per order.

---

### Q8 — Top 10 customers by revenue

**Business question:** Who are our most valuable customers?

```sql
SELECT
    customer_id,
    customer_name,
    segment,
    COUNT(DISTINCT order_id)   AS total_orders,
    ROUND(SUM(sales), 2)       AS total_revenue,
    ROUND(SUM(profit), 2)      AS total_profit,
    ROUND(AVG(sales), 2      AS avg_order_value
FROM  superstore
GROUP BY customer_id, customer_name, segment
ORDER BY total_revenue DESC
LIMIT 10;
```

---

### Q9 — Customers who bought in 2016 but NOT in 2017 (churn signal)

**Business question:** Which customers stopped buying after 2016?

```sql
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM superstore
WHERE YEAR(order_date= 2016
  AND customer_id NOT IN (
      SELECT DISTINCT customer_id
      FROM   superstore
      WHERE  YEAR(order_date= 2017
  )
ORDER BY customer_name;
```

**Why it matters:** These customers churned — a retention campaign should target them.

---

### Q10 — Products sold at a loss more than 5 times

**Business question:** Which specific products consistently lose money?

```sql
SELECT
    product_id,
    product_name,
    category,
    sub_category,
    COUNT(*             AS loss_orders,
    ROUND(SUM(profit), 2) AS total_loss,
    ROUND(MIN(discount), 2AS min_discount,
    ROUND(MAX(discount), 2) AS max_discount
FROM  superstore
WHERE profit < 0
GROUP BY product_id, product_name, category, sub_category
HAVING COUNT(*) > 5
ORDER BY total_loss ASC
LIMIT 10;
```

---

### Q11 — Running total of sales by month (window function)

**Business question:** What does cumulative annual revenue look like?

```sql
SELECT
    DATE_FORMAT(order_date, '%Y-%m'       AS month,
    ROUND(SUM(sales), 2                   AS monthly_sales,
    ROUND(SUM(SUM(sales)) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY DATE_FORMAT(order_date, '%Y-%m')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                   AS ytd_sales
FROM  superstore
GROUP BY YEAR(order_date), DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

**Key concept:** `SUM(OVER (PARTITION BY year ORDER BY month)` resets the running total at the start of each year.

---

### Q12 — Rank products by revenue within each category (window function)

**Business question:** What are the top products in each category?

```sql
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2AS total_profit,
    RANK(OVER (
        PARTITION BY category
        ORDER BY SUM(sales) DESC
                        AS sales_rank_in_category
FROM  superstore
GROUP BY category, sub_category
ORDER BY category, sales_rank_in_category;
```

---

### Q13 — Month-over-month sales growth (window function + CTE)

**Business question:** Which months saw the biggest sales jumps?

```sql
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m' AS month,
        ROUND(SUM(sales), 2             AS sales
    FROM  superstore
    GROUP BY month
),
with_growth AS (
    SELECT
        month,
        sales,
        LAG(sales, 1) OVER (ORDER BY month)  AS prev_month_sales,
        ROUND(
            (sales - LAG(sales,1OVER (ORDER BY month))
            / NULLIF(LAG(sales,1) OVER (ORDER BY month), 0) * 100,
            1
                                            AS mom_growth_pct
    FROM monthly_sales
)
SELECT *
FROM   with_growth
WHERE  mom_growth_pct IS NOT NULL
ORDER BY mom_growth_pct DESC;
```

---

### Q14 — Average shipping days by mode and whether it affects profit

**Business question:** Does faster shipping correlate with higher profit?

```sql
SELECT
    ship_mode,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1)  AS avg_ship_days,
    COUNT(*)                                         AS order_count,
    ROUND(AVG(profit), 2)                            AS avg_profit,
    ROUND(SUM(profit), 2)                            AS total_profit,
    ROUND(SUM(sales), 2                            AS total_sales
FROM  superstore
GROUP BY ship_mode
ORDER BY avg_ship_days;
```

**Key insight:** Same Day shipping is chosen for smaller orders — lower avg profit per order despite speed.

---

### Q15 — State-level performance: identify underperforming states

**Business question:** Which states have high sales but poor profitability?

```sql
WITH state_summary AS (
    SELECT
        state,
        region,
        ROUND(SUM(sales), 2)                       AS total_sales,
        ROUND(SUM(profit), 2)                      AS total_profit,
        ROUND(SUM(profit) / SUM(sales* 100, 2  AS margin_pct,
        COUNT(DISTINCT order_id                   AS total_orders,
        RANK() OVER (ORDER BY SUM(sales) DESC)      AS sales_rank
    FROM  superstore
    GROUP BY state, region
)
SELECT *
FROM   state_summary
WHERE  total_sales > 50000   -- significant volume
  AND  margin_pct < 5        -- but poor profitability
ORDER BY margin_pct ASC;
```

**Key insight:** Texas and Illinois have large sales volumes but are barely profitable — high discounting in these states is the likely culprit.

---

## 📊 Summary of Findings

| # | Question | Key Finding |
|---|---|---|
| 1 | Overall performance | 12.5% profit margin on $2.3M revenue |
| 2 | Region breakdown | East is most efficient; Central is weakest |
| 3 | Best sub-categories | Copiers (37% margin), Accessories (16%|
| 4 | Loss-making products | Tables: −$17K loss on $206K sales |
| 5 | Seasonality | Q4 = 30%+ of annual revenue every year |
| 6 | Segments | Corporate has best margin; Consumer most volume |
| 7 | Discount impact | >30% discount = −$69 average profit per order |
| 8 | Top customers | Top 10 customers = ~$90K combined revenue |
| 9 | Churn signal | 217 customers active in 2016 didn't buy in 2017 |
| 10 | Loss products | 15 products lose money on 5+ separate orders |
| 11 | Running total | YTD tracking shows Q4 acceleration clearly |
| 12 | Category rank | Phones #1 in Technology by far |
| 13 | MoM growth | Nov 2017 highest MoM growth (+48%) |
| 14 | Shipping analysis | Standard Class = 78% of orders, lowest margin |
| 15 | State deep dive | Texas & Illinois: high volume, <3% margin |

---

## 💡 SQL Concepts Used

| Concept | Queries |
|---|---|
| `SELECT`, `WHERE`, `ORDER BY`, `LIMIT` | Q1, Q3, Q8 |
| `GROUP BY`, `HAVING` | Q2, Q4, Q5, Q6, Q10 |
| `CASE WHEN` | Q7 |
| Subqueries | Q9 |
| `RANK()`, `SUM() OVER()`, `LAG()` | Q11, Q12, Q13 |
| CTEs (`WITH` clause) | Q13, Q15 |
| Date functions (`YEAR()`, `DATEDIFF()`, `DATE_FORMAT()`) | Q5, Q14 |
| `NULLIF()` for safe division | Q13 |
| `PARTITION BY` | Q11, Q12, Q15 |

---

## 🚀 How to Run

1. Install MySQL or PostgreSQL (or use [DB Fiddle](https://www.db-fiddle.com/online — no install needed)
2. Run `setup/create_table.sql` to create the table
3. Import `data/superstore.csv` into the table
4. Run any `.sql` file in the `queries/` folder

```bash
git clone https://github.com/Rohittt619/SQL-Data-Analysis
cd SQL-Data-Analysis
# Then open your SQL client and run the files in order
```

---

## 👨‍💻 Author

**Rohit Rathod** — Junior Data Analyst  
📧 rrathod1101@gmail.com · [LinkedIn](https://linkedin.com/in/rohit-rathod-19442a228) · [GitHub](https://github.com/Rohittt619)

---

*Found this useful? Give it a ⭐ on GitHub!*
