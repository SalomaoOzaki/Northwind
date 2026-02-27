**Northwind Analytics Project — SQL & Power BI**

**Project Overview**

This project delivers an end-to-end business intelligence solution using the classic Northwind dataset, covering data modeling, SQL transformation, analytical engineering, and interactive dashboard development in Power BI.

The main goal is to demonstrate advanced SQL capabilities, dimensional modeling, and business-driven analytics, transforming raw transactional data into actionable insights for Sales, Customer Analytics, and Executive decision-making.

**Key Technologies:**

MySQL (SQL Development & Data Modeling)
Power BI (Data Modeling, DAX, Visualization)
GitHub (Version Control & Documentation) and Portfolio https://sites.google.com/view/salomaoanalytics/home

**Data Architecture & Workflow**

1️⃣ Database Setup

Installed MySQL Workbench locally

Imported the Northwind database from:
https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql

Generated the database schema model using reverse engineering:

👉 Database → Reverse Engineer
👉 Model file: https://github.com/SalomaoOzaki/Northwind/blob/main/northwindModel.mwb

<p align="center"> <img src="https://github.com/user-attachments/assets/477a9c9e-56f1-4bda-989b-5cc210830d2a" width="480"> </p>

2️⃣ SQL Transformation Layer (Analytical Views)

To optimize Power BI performance and maintain clean analytical logic, I built a SQL semantic layer using Views.

    These views leverage:
        -CTEs
        -Window Functions
        -Aggregations
        -Ranking logic
        -Business KPI calculations

All SQL scripts are documented here: northwindQueryViews.sql

    Created Analytical Views:
        -vw_fact_sales → Central sales fact table
        -vw_customer_ltv → Customer lifetime value
        -vw_employee_performance → Sales rep performance KPIs
        -vw_monthly_sales → Monthly revenue trends
        -vw_shipping_performance → Logistics & delivery insights
        -vw_top_customers_category → Product-category-based customer analysis

This structure allows Power BI to consume analytics-ready datasets, minimizing transformation inside Power BI and ensuring scalable performance.


**SQL Code Examples**

```
CREATE VIEW vw_top_customers_category AS

WITH CustomerCategoryRevenue AS (
		SELECT
			s.CustomerID AS CustomerID,
            s.CustomerName AS CustomerName,
            s.CategoryName AS CategoryName,
            s.EmployeeId AS EmployeeId,
            CONCAT(s.FirstName, ' ', s.LastName) AS EmployeeName,
            SUM(s.Revenue) AS TotalRevenue
        FROM vw_fact_sales s
        GROUP BY
			CustomerID, CustomerName, CategoryName, EmployeeId),

CustomerCategoryRank AS (
		SELECT 
			*,
            RANK () OVER (PARTITION BY CategoryName ORDER BY TotalRevenue DESC) AS RankCategory,
            SUM(TotalRevenue) OVER (PARTITION BY CategoryName) AS CategoryRevenue
		FROM CustomerCategoryRevenue)


SELECT 
	CategoryName, 
	CustomerID, 	
	CustomerName, 	
    EmployeeName, 
	TotalRevenue,
    ROUND((TotalRevenue / CategoryRevenue) * 100,2) AS RevenueShare,
    RankCategory
FROM CustomerCategoryRank
WHERE RankCategory <=3
ORDER BY CategoryName, RankCategory;
```

3️⃣ Power BI Integration & Data Modeling

Power BI connects directly to MySQL using the native connector, importing the SQL views as analytical tables.

    In Power BI:
        -Built a star-schema semantic model
        -Implemented DAX measures for KPIs
        -Designed interactive dashboards for business users

📈 Dashboards & Business Analytics
🔹 Sales Executive Dashboard

<p align="center"> <img src="https://github.com/user-attachments/assets/e93bf902-1eb6-488a-a298-136d97e10be8" width="650"> </p>


Focuses on: Revenue trends (MoM), Sales growth, Top Clients, Employees, Category contribution.

🔹 Customer Analytics Dashboard

<p align="center"> <img src="https://github.com/user-attachments/assets/d3807d45-46f7-48f3-bb78-624c02e01011" width="650"> </p>

Focuses on: Customer Lifetime Value (LTV), Repeat purchase behavior, Customer ranking, Revenue concentration

Conditional formatting using DAX for visual storytelling

**DAX Measures (Selected Examples)**
```Avg. Order Value = 
CALCULATE(
    DIVIDE(
        SUM(vw_fact_sales[Revenue]),
        DISTINCTCOUNT(vw_fact_sales[OrderID]),
        0
    )
)
```

```Repeat Purchase Rate = 
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
```

```Revenue Last Month = 
CALCULATE(
    [TotalRevenue],
    DATEADD('Date'[Date], -1, MONTH)
)
```

```Revenue MoM % = 
DIVIDE(
    [TotalRevenue] - [Revenue Last Month],
    [Revenue Last Month]
)
```

🎯 Business Value Delivered

This solution enables stakeholders to:
    -Identify top-performing categories and customers
    -Monitor revenue growth trends
    -Understand customer purchasing behavior
    -Optimize sales team performance
    -Apply data-driven decision making
