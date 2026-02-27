# Northwind
Overview, this project uses SQL for Data Manipulation where I use aggregation, CTE, window function, and views are created. From Power BI I connect with MYSQL and views are uploaded on my Pbix file.



Database Reference: https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql

Workflow

Installed MySQL Workbench on my Local Machine

In MYSQL Workench I opened a new SQL query, and then I pulled the query from the downloaded file (https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql).

Generated my Database Schema through Database -> Reverse Engineer (file https://github.com/SalomaoOzaki/Northwind/blob/main/northwindModel.mwb)
<img width="485" height="387" alt="image" src="https://github.com/user-attachments/assets/477a9c9e-56f1-4bda-989b-5cc210830d2a" />
 
Then I created the following views. For reference, the SQL codes Snippets are available in the northwindQueryViews.sql file (https://github.com/SalomaoOzaki/Northwind/blob/main/northwindQueryViews.sql)
vw_fact_sales
vw_customer_ltv
vw_employee_performance
vw_monthly_sales
vw_shipping_performance
vw_top_customers_category

Then I connected my Power BI to MySQL through a connector and was able to get the views I created.

In Power BI I have firstly carried out Sales Executive Analysis and Customer Analytics, and in the near future will add some more analysis such as Employee and Shipping Perfomance.

To support the achievement of some of my charts I had to make Measures, here are them:

AVG Deal Size = 
Divide(
    SUM(vw_employee_performance[TotalRevenue]),
    SUM(vw_employee_performance[TotalOrders]), 0)

Avg. Order Value = 
    CALCULATE(
        DIVIDE(SUM(vw_fact_sales[Revenue]),
                DISTINCTCOUNT(vw_fact_sales[OrderID]),2))

Funnel Color = 
VAR MaxValue =
    MAXX(ALLSELECTED(vw_fact_sales[CategoryName]), [TotalRevenue])
RETURN
IF(
    [TotalRevenue] = MaxValue,
    "#1F4E79",   -- Primary color
    "#B3B3B3"    -- Neutral color
)


Orders per Employee = 
    DIVIDE(
        sum(vw_employee_performance[TotalOrders]),
        DISTINCTCOUNT(vw_employee_performance[EmployeeID]),0)

Paretto Color = 
VAR Perc = SELECTEDVALUE(vw_customer_ltv[Revenue Cumulative %])
RETURN
IF(
    Perc <= 0.8,
    "#1F4E79",   -- Primary color
    "#B3B3B3"    -- Neutral color
)

Repeat Purchase Rate = 
VAR TotalCustomers =
    COUNTROWS(vw_customer_ltv)

VAR RepeatCustomers =
    COUNTROWS(
        FILTER(
            vw_customer_ltv,
            vw_customer_ltv[TotalOrders] > 1
        )
    )

RETURN
DIVIDE(RepeatCustomers, TotalCustomers, 0)

Revenue Last Month = 
CALCULATE(
    [TotalRevenue],
    DATEADD('Date'[Date], -1, MONTH)
)

Revenue MoM % = 
DIVIDE(
    [TotalRevenue] - [Revenue Last Month],
    [Revenue Last Month]
)

Revenue per Employee = 
    DIVIDE(
        sum(vw_employee_performance[TotalRevenue]),
        DISTINCTCOUNT(vw_employee_performance[EmployeeID]), 0
)

Top 10 LTV clients Color = 
VAR MaxValue =
    MAXX(ALLSELECTED(vw_customer_ltv[CustomerName]), [Total Days Active])
RETURN
IF(
    [Total Days Active] = MaxValue,
    "#1F4E79",   -- Primary color
    "#B3B3B3"    -- Neutral color
)

Top Clients Color = 
VAR MaxValue =
    MAXX(ALLSELECTED(vw_fact_sales[CustomerName]), [TotalRevenue])
RETURN
IF(
    [TotalRevenue] = MaxValue,
    "#1F4E79",   -- Primary color
    "#B3B3B3"    -- Neutral color
)

Top Employees Color = 
VAR MaxValue =
    MAXX(ALLSELECTED(vw_fact_sales[FirstName]), [TotalRevenue])
RETURN
IF(
    [TotalRevenue] = MaxValue,
    "#1F4E79",   -- Primary color
    "#B3B3B3"    -- Neutral color
)

Total Days Active = 
    sum(vw_customer_ltv[ActiveDays])

TotalRevenue = 
    sum(vw_fact_sales[Revenue])
