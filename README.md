**Northwind Analytics Project — SQL & Power BI**

🔍 Project Overview

This project delivers an end-to-end business intelligence solution using the classic Northwind dataset, covering data modeling, SQL transformation, analytical engineering, and interactive dashboard development in Power BI.

The main goal is to demonstrate advanced SQL capabilities, dimensional modeling, and business-driven analytics, transforming raw transactional data into actionable insights for Sales, Customer Analytics, and Executive decision-making.

Key Technologies:

MySQL (SQL Development & Data Modeling)

Power BI (Data Modeling, DAX, Visualization)

GitHub (Version Control & Documentation)

🏗️ Data Architecture & Workflow
1️⃣ Database Setup

Installed MySQL Workbench locally

Imported the Northwind database from:
https://github.com/harryho/db-samples/blob/master/mysql/northwind.sql

Generated the database schema model using reverse engineering:

👉 Database → Reverse Engineer
👉 Model file:
https://github.com/SalomaoOzaki/Northwind/blob/main/northwindModel.mwb

<p align="center"> <img src="https://github.com/user-attachments/assets/477a9c9e-56f1-4bda-989b-5cc210830d2a" width="480"> </p>
2️⃣ SQL Transformation Layer (Analytical Views)

To optimize Power BI performance and maintain clean analytical logic, I built a SQL semantic layer using Views.

These views leverage:

CTEs

Window Functions

Aggregations

Ranking logic

Business KPI calculations

All SQL scripts are documented here:
📄 northwindQueryViews.sql

Created Analytical Views:

vw_fact_sales → Central sales fact table

vw_customer_ltv → Customer lifetime value & behavior metrics

vw_employee_performance → Sales rep performance KPIs

vw_monthly_sales → Monthly revenue trends

vw_shipping_performance → Logistics & delivery insights

vw_top_customers_category → Product-category-based customer analysis

This structure allows Power BI to consume analytics-ready datasets, minimizing transformation inside Power BI and ensuring scalable performance.

3️⃣ Power BI Integration & Data Modeling

Power BI connects directly to MySQL using the native connector, importing the SQL views as analytical tables.

In Power BI:

Built a star-schema semantic model

Implemented DAX measures for KPIs

Designed interactive dashboards for business users

📈 Dashboards & Business Analytics
🔹 Sales Executive Dashboard

Focuses on:

Revenue trends (MoM)

Sales growth

Product performance

Customer concentration (Pareto analysis)

Category contribution

<p align="center"> <img src="https://github.com/user-attachments/assets/d3807d45-46f7-48f3-bb78-624c02e01011" width="650"> </p>
🔹 Customer Analytics Dashboard

Focuses on:

Customer Lifetime Value (LTV)

Repeat purchase behavior

Customer ranking

Revenue concentration

Client activity lifecycle

<p align="center"> <img src="https://github.com/user-attachments/assets/1fba3381-5af6-45b0-b9e2-6740240af9d0" width="650"> </p>
📊 Core KPIs & Business Metrics

To support the dashboards, I implemented several business-driven DAX measures, including:

🟦 Sales & Revenue Performance

Total Revenue

Revenue MoM %

Revenue per Employee

Average Deal Size

Average Order Value (AOV)

🟨 Customer Analytics

Customer Lifetime Value (LTV)

Repeat Purchase Rate

Total Active Days

Top Clients Highlighting

Pareto (80/20) Analysis

🟩 Workforce Performance

Orders per Employee

Revenue per Employee

Top Employee Identification

🧠 Advanced Analytical Techniques

This project applies advanced analytical concepts, including:

Window functions for ranking & cumulative metrics

Pareto Principle (80/20 analysis)

Customer Lifetime Value modeling

Time Intelligence (MoM, trend analysis)

Conditional formatting using DAX for visual storytelling

🧩 DAX Measures (Selected Examples)
Avg. Order Value = 
CALCULATE(
    DIVIDE(
        SUM(vw_fact_sales[Revenue]),
        DISTINCTCOUNT(vw_fact_sales[OrderID]),
        2
    )
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
Revenue MoM % = 
DIVIDE(
    [TotalRevenue] - [Revenue Last Month],
    [Revenue Last Month]
)
🎯 Business Value Delivered

This solution enables stakeholders to:

Identify top-performing products and customers

Monitor revenue growth trends

Understand customer purchasing behavior

Optimize sales team performance

Apply data-driven decision making
