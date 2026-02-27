DROP VIEW IF EXISTS vw_fact_sales;
DROP VIEW IF EXISTS vw_monthly_sales;
DROP VIEW IF EXISTS vw_customer_ltv;
DROP VIEW IF EXISTS vw_employee_performance;
DROP VIEW IF EXISTS vw_shipping_performance;
DROP VIEW IF EXISTS vw_top_customers_category;

CREATE VIEW vw_fact_sales AS
    SELECT 
        s.OrderID AS OrderID,
        s.OrderDate AS OrderDate,
        od.Quantity AS Quantity,
        od.unitPrice AS UnitPrice,
        od.discount AS Discount,
        ROUND((od.Quantity * od.unitPrice) - ((od.Quantity * od.unitPrice) * od.discount), 2) AS Revenue,
        c.custId AS CustomerID,
        c.companyName AS CustomerName,
        c.city AS CustomerCity,
        c.country AS CustomerCountry,
        sh.companyName AS ShipperName,
        s.freight AS Freight,
        s.shipCity AS ShipCity,
        s.shipCountry AS ShipCountry,
        s.requiredDate AS RequiredDate,
        s.shippedDate AS ShippedDate,
        p.ProductName AS ProductName,
        ca.categoryName AS CategoryName,
        ca.description AS Description,
        su.companyName AS SupplierName,
		e.employeeId AS EmployeeId,
		e.firstname AS FirstName,
        e.lastname AS LastName
    FROM
        salesorder s
        JOIN orderdetail od ON (s.OrderID = od.OrderID)
        JOIN customer c ON (s.custId = c.custId)
        JOIN shipper sh ON (s.shipperId = sh.shipperId)
        JOIN employee e ON (s.employeeID = e.employeeId)
        JOIN product p ON (od.productId = p.productId)
        JOIN category ca ON (p.categoryId = ca.categoryId)
        JOIN supplier su ON (p.supplierId = su.supplierId);

CREATE VIEW vw_monthly_sales AS
    SELECT 
        MonthDate,
        YEAR(MonthDate) AS Year,
        MONTH(MonthDate) AS Month,
        COUNT(DISTINCT OrderID) AS TotalOrders,
        COUNT(DISTINCT CustomerID) AS TotalCustomers,
        SUM(Quantity) AS TotalUnitsSold,
        ROUND(SUM((Revenue)), 2) AS TotalRevenue,
        ROUND((SUM((Revenue)) / COUNT(DISTINCT OrderID)),2) AS AvgOrderValue
    FROM
        (SELECT 
            *,
                DATE_FORMAT(OrderDate, '%Y-%m-01') AS MonthDate
        FROM
            vw_fact_sales) t
    GROUP BY MonthDate;

CREATE VIEW vw_customer_ltv AS
	SELECT 
		CustomerID,
        CustomerName,
        COUNT(DISTINCT OrderID) AS TotalOrders,
        ROUND(SUM(Revenue), 2) AS Revenue,
        ROUND(SUM(Revenue) / COUNT(DISTINCT OrderID),2) AS AvgOrderValue,
        MIN(OrderDate) AS FirstPurchaseDate,
        MAX(OrderDate) AS LastPurchaseDate,
        DATEDIFF(MAX(OrderDate), MIN(OrderDate)) AS ActiveDays,
        RANK() OVER (ORDER BY SUM(revenue) DESC) AS RevenueRank
	FROM vw_fact_sales
    GROUP BY 
		CustomerID;
        
CREATE VIEW vw_employee_performance AS 
SELECT 
		EmployeeID AS EmployeeID,
		concat(FirstName,' ',LastName) AS Employee,
		count(distinct OrderID) AS TotalOrders,
		count(distinct CustomerID) AS TotalCustomers,
		sum(Quantity) AS TotalUnits,
		round(sum(Revenue),2) AS TotalRevenue,
		round((sum(Revenue) / count(distinct OrderID)),2) AS RevenuePerOrder,
		round((sum(Revenue) / count(distinct CustomerID)),2) AS RevenuePerCustomer,
		rank() OVER (ORDER BY sum(Revenue) desc )  AS RevenueRank 
FROM vw_fact_sales 
GROUP BY EmployeeID,concat(FirstName,' ',LastName);


CREATE OR REPLACE VIEW vw_shipping_performance AS
SELECT
    ShipperName,
    COUNT(DISTINCT OrderID) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    ROUND(SUM(Revenue),2) AS TotalRevenue,
    ROUND(SUM(Freight),2) AS TotalFreightCost,
    ROUND(SUM(Freight) / COUNT(DISTINCT OrderID),2) AS AvgFreightPerOrder,
    ROUND(SUM(Freight) / SUM(Revenue),4) AS FreightToRevenueRatio,
    RANK() OVER (ORDER BY SUM(Revenue) DESC) AS RevenueRank
FROM vw_fact_sales
GROUP BY
    ShipperName;
    
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


