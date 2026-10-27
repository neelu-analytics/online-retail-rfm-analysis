--CREATE TABLE
--DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  "Invoice"      text,
  "StockCode"    text,
  "Description"  text,
  "Quantity"     int,
  "InvoiceDate"  timestamp,
  "Price"        numeric,
  "Customer ID"  numeric,
  "Country"      text
);
select * from sales;

--ADD DATA
--file ; C:\Users\kumar\Downloads\SALES\online_retail_II.csv
--CHECK DATA 
SELECT COUNT(*) FROM sales;
--Result -;10,67,371
select * from sales Limit 100;