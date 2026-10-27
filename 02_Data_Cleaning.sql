 --Total rows before cleaning
select count (*) from sales;
--RESULT:- 10,67,371.

--Missing customer id 
SELECT COUNT (*) FROM sales WHERE "Customer ID" IS NULL;
--RESULT:- 2,43,007.

--cancelled_orders
SELECT COUNT(DISTINCT "Invoice") AS cancelled_orders
FROM sales WHERE "Invoice" LIKE 'C%';
--RESULT:-8,292.

--Invalid quantity and price 
Select count(*) from sales
where "Quantity" <=0 or "Price"<=0 ;
--RESULT:-0

--Manual entries (non-product rows)
SELECT COUNT(*) FROM sales WHERE "Description" = 'Manual';
--RESULT:- 0 (Manual rows were deleted, as they are not real products)

--Blank description check
SELECT COUNT(*) FROM sales
WHERE "Description" IS NULL OR TRIM("Description") = '';

--Duplicate rows check
SELECT COALESCE(SUM(cnt - 1), 0) AS duplicate_rows
FROM (
    SELECT COUNT(*) AS cnt
    FROM sales
    GROUP BY
        "Invoice",
        "StockCode",
        "Description",
        "Quantity",
        "InvoiceDate",
        "Price",
        "Customer ID",
        "Country"
    HAVING COUNT(*) > 1
) AS duplicates;
--RESULT: 33,727.

CREATE TABLE sales_backup AS SELECT * FROM sales;
-- Total rows after cleaning
SELECT COUNT(*) AS backup_rows
FROM sales_backup;