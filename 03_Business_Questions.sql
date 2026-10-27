CREATE OR REPLACE VIEW sales_revenue AS
SELECT *,
       ("Quantity" * "Price") AS revenue
FROM sales;

-- Q1: Total Revenue, Orders, Unique Customers and Average order value.

WITH order_totals AS ( SELECT"Invoice",SUM(revenue) AS order_revenue
 FROM sales_revenue WHERE "Quantity" > 0 AND "Price" > 0
 AND TRIM("Invoice") NOT LIKE 'C%'GROUP BY "Invoice"
)
SELECT
    ROUND(SUM(order_revenue), 2) AS total_revenue,
    COUNT(*) AS total_orders,
    (
        SELECT COUNT(DISTINCT "Customer ID")
        FROM sales_revenue
        WHERE "Customer ID" IS NOT NULL
          AND "Quantity" > 0
          AND "Price" > 0
          AND TRIM("Invoice") NOT LIKE 'C%'
    ) AS unique_customers,
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM order_totals;

-- Q2: Revenue by Country.
Select "Country", Round (sum (revenue), 2) As Total_revenue
from sales_revenue where "Quantity" >0 And "Price" >0
And Trim ("Invoice") NOT LIKE 'C%'
Group by "Country"
Order by Total_revenue DESC;

-- Q3:Top 10 product by revenue.
Select "Description" as Product_name,Round (sum (revenue), 2) As Total_revenue
from sales_revenue where "Quantity" >0 And "Price" >0
And Trim ("Invoice") Not Like 'C%' And "Description" is Not NULL
Group by "Description"
Order by Total_revenue DESC
LIMIT 10 ;

-- Q4: Month-wise revenue
SELECT TO_CHAR("InvoiceDate", 'YYYY-MM') AS month,
       ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_revenue
WHERE "Quantity" > 0 AND "Price" > 0
  AND TRIM("Invoice") NOT LIKE 'C%'
GROUP BY 1
ORDER BY 1;

-- Q5:Customers with More Than 10 Orders.
Select "Customer ID", Count (Distinct "Invoice")As Orders
from sales
where "Customer ID" Is not NULL
And Trim ("Invoice") NOT Like 'C%'
Group by "Customer ID"
Having Count (Distinct "Invoice") > 10
Order by orders DESC;

-- Q6:RFM Analysis per Customer
DROP VIEW IF EXISTS rfm_base;
CREATE VIEW rfm_base AS
SELECT "Customer ID", MAX("InvoiceDate")::date  AS last_order_date,
(SELECT MAX("InvoiceDate")::date + 1 FROM sales)
  - MAX("InvoiceDate")::date AS recency_days,        
COUNT(DISTINCT "Invoice")  AS frequency,           
 ROUND(SUM("Quantity" * "Price"), 2) AS monetary
FROM sales
WHERE "Customer ID" IS NOT NULL
  AND "Quantity" > 0 AND "Price" > 0
  AND TRIM("Invoice") NOT LIKE 'C%'
GROUP BY "Customer ID";

-- Q7: R, F and M scores from 1 to 5
Select "Customer ID", recency_days, frequency, monetary,
NTILE(5) over (Order by recency_days DESC) AS r_score,
NTILE(5) over (Order by frequency) AS f_score,
NTILE(5) over (Order by monetary) AS m_score
from rfm_base;

-- Q8:Top 10 Highest-Value Customers
select "Customer ID", 
Round (sum( "Quantity" * "Price"), 2) as total_spending
from sales
where "Customer ID" IS NOT NULL
And "Quantity" > 0 and "Price">0 and Trim("Invoice") not like 'C%'
Group by "Customer ID"
Order by  total_spending DESC
LIMIT 10;

-- Q9: How manY customers belong to each country?
SELECT "Country",
COUNT (DISTINCT "Customer ID") AS total_customers
FROM sales
WHERE "Customer ID" IS NOT NULL
GROUP BY "Country"
ORDER BY total_customers DESC;

-- Q10: Customer Purchase Frequency Distribution
WITH customer_orders AS (SELECT  "Customer ID",
COUNT(DISTINCT "Invoice") AS total_orders FROM sales
WHERE "Customer ID" IS NOT NULL
 AND "Quantity" > 0  AND "Price" > 0 AND TRIM("Invoice") NOT LIKE 'C%'
GROUP BY "Customer ID")
SELECT CASE
WHEN total_orders = 1 THEN 'One-time Customer'
 WHEN total_orders BETWEEN 2 AND 5 THEN 'Occasional Customer'
 WHEN total_orders BETWEEN 6 AND 10 THEN 'Regular Customer'
 ELSE 'Frequent Customer'
 END AS customer_type,
 COUNT(*) AS customer_count        
FROM customer_orders
GROUP BY customer_type
ORDER BY customer_count DESC;


















