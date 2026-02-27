# Northwind
Overview, this project uses SQL for Data Manipulation where I use aggregation, CTE, window function, and views are created. From Power BI I connect with MYSQL and views are uploaded on my Pbix file.



Database Reference: https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql

Workflow

Installed MySQL Workbench on my Local Machine

In MYSQL Workench I opened a new SQL query, and then I pulled the query from the downloaded file (https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql).

Generated my Database Schema through Database -> Reverse Engineer
<img width="485" height="387" alt="image" src="https://github.com/user-attachments/assets/477a9c9e-56f1-4bda-989b-5cc210830d2a" />
 
Then I created the following views. For reference, the query is available at northwindQueryViews
vw_fact_sales
vw_customer_ltv
vw_employee_performance
vw_monthly_sales
vw_shipping_performance
vw_top_customers_category





