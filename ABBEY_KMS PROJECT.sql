
----DSA CAPSTONE PROJECT---------
------ABIODUN ESTHER OYELEYE-------
--------DATA ANALYSIS SQUAD 5--------
--------CASE SCENARIO I--------
--Q1: PRODUCT CATEGORY WITH THE HIGHEST SALES------
SELECT TOP 1 [Product_Category], SUM([Sales]) AS TotalSales
FROM KMSOrders
GROUP BY [Product_Category]
ORDER BY TotalSales DESC

--Technology is the product_category with the highest sales which is 5984248.50--


--Q2: TOP 3 & BOTTOM 3 REGIONS IN TERMS OF SALES------
-- Top 3 Regions
SELECT TOP 3 [Region], SUM([Sales]) AS TotalSales
FROM KMSOrders
GROUP BY [Region]
ORDER BY TotalSales DESC;

--Top 3 Regions in terms of sales includes 1.West (3597549.41), 2.Ontario (3063212.60), 3.Prarie (2837304.60). 

-- Bottom 3 Regions
SELECT TOP 3 [Region], SUM([Sales]) AS TotalSales
FROM KMSOrders
GROUP BY [Region]
ORDER BY TotalSales ASC;

--Bottom 3 Regions in terms of sales includes 1. Yukon (975867.39), 2. Northwest Territories (800847.35), 3.Nunavut (116376.47). 


--Q3: TOTAL SALES OF APPLIANCES IN ONTARIO------
SELECT SUM([Sales]) AS ApplianceSalesOntario
FROM KMSOrders
WHERE [Product_Category] = 'Appliances' AND [Province] = 'Ontario';

--This result of this is NULL


--Q4: ADVISE TO KMS ON HOW TO INCREASE THE REVENUE FROM THE BOTTOM 10 CUSTOMERS------
SELECT TOP 10 [Customer_Name], SUM([Sales]) AS TotalSales
FROM KMSOrders
GROUP BY [Customer_Name]
ORDER BY TotalSales ASC;
--Bottom 10 Customers by Sales includes
--1. Jeremy Farry (85.72)
--2. Natalie DeCherney (125.90)
--3. Nicole Fjeld (153.03)
--4. Katrina Edelman (180.76)
--5. Dorothy Dickinson (198.08)
--6. Christine Kargatis (293.22)
--7. Eric Murdock (343.33)
--8. Chris McAfee (350.18)
--9. Rick Huthwaite (415.82)
--10. Mark Hamilton (450.99)

--Advice to Kultra Mega Stores:--
--1.Provide incentives like discounts, loyalty points, or free delivery.--
--2.Analyze their past purchases to tailor bundles.--
--3.Offer targeted promotions or product recommendations.--
--4.Follow up via email with exclusive deals or personalized engagement.--

--Q5: KMS incurred the most shipping cost using which shipping method?------
SELECT TOP 1 [Ship_Mode], SUM([Shipping_Cost]) AS TotalShippingCost
FROM KMSOrders
GROUP BY [Ship_Mode]
ORDER BY TotalShippingCost DESC;

--KMS incurred the most shipping cost (51971.94) using Delivery Truck.


---CASE SCENARIO II--

--Q6. Who are the most valuable customers, and what products or services do they typically purchase?-- 
--6a: Top 5 customers by Profit--
SELECT TOP 5 [Customer_Name], SUM([Profit]) AS TotalProfit
FROM KMSOrders
GROUP BY [Customer_Name]
ORDER BY TotalProfit DESC;

--The most valuable customers (Top 5) includes Emily Phan, Deborah Brumfield, Grant Carroll, Karen Carlisle and Alejandro Grove.

--6b: Products they Purchased--
WITH TopCustomers AS (
    SELECT TOP 5 [Customer_Name]
    FROM KMSOrders
    GROUP BY [Customer_Name]
    ORDER BY SUM([Profit]) DESC
),
CustomerProductSales AS (
    SELECT 
        k.[Customer_Name], 
        k.[Product_Name], 
        SUM(k.[Sales]) AS ProductSales,
        ROW_NUMBER() OVER (
            PARTITION BY k.[Customer_Name] 
            ORDER BY SUM(k.[Sales]) DESC
        ) AS rn
    FROM KMSOrders k
    JOIN TopCustomers tc ON k.[Customer_Name] = tc.[Customer_Name]
    GROUP BY k.[Customer_Name], k.[Product_Name]
)
SELECT 
    [Customer_Name], 
    [Product_Name], 
    ProductSales
FROM CustomerProductSales
WHERE rn = 1
ORDER BY ProductSales DESC;
--Products Ordered included Videoconferencing Unit, Copier, Electric binding system and Manual Plastic Comb Binding Machine.


--Q7. Which small business customer had the highest sales?-- 
SELECT TOP 1 [Customer_Name], SUM([Sales]) AS TotalSales
FROM KMSOrders
WHERE [Customer_Segment] = 'Small Business'
GROUP BY [Customer_Name]
ORDER BY TotalSales DESC;

--Dennis Kane was the small business customer who had the highest sales (75967.59)

--Q8. Which Corporate Customer placed the most number of orders in 2009 – 2012?-- 
SELECT TOP 1 [Customer_Name], COUNT(DISTINCT [Order_ID]) AS OrderCount
FROM KMSOrders
WHERE [Customer_Segment] = 'Corporate'
  AND YEAR([Order_Date]) BETWEEN 2009 AND 2012
GROUP BY [Customer_Name]
ORDER BY OrderCount DESC;

--Adam Hart placed the most number of orders in 2009 - 2012


--Q9. Which consumer customer was the most profitable one?-- 
SELECT TOP 1 [Customer_Name], SUM([Profit]) AS TotalProfit
FROM KMSOrders
WHERE [Customer_Segment] = 'Consumer'
GROUP BY [Customer_Name]
ORDER BY TotalProfit DESC;

--Emily Phan was the most profitable Consumer Costomer


--10. Which customer returned items, and what segment do they belong to?--

SELECT 
    k.[Customer_Name], 
    MIN(k.[Customer_Segment]) AS Customer_Segment  -- assuming same segment per customer
FROM KMSOrders k
JOIN Order_Status o ON k.[Order_ID] = o.[Order_ID]
WHERE o.[Status] = 'Returned'
GROUP BY k.[Customer_Name];

--11. If the delivery truck is the most economical but the slowest shipping method and Express Air is the fastest but the most expensive one, do you think the company appropriately spent shipping costs based on the Order Priority? Explain your answer
SELECT 
    [Order_Priority],
    [Ship_Mode],
    COUNT(*) AS OrderCount
FROM KMSOrders
GROUP BY [Order_Priority], [Ship_Mode]
ORDER BY [Order_Priority], [Ship_Mode];


--Based on the shipping data distribution across order priorities, the company’s allocation of shipping modes 
--does not appear to be entirely appropriate or optimized for cost-effectiveness and customer satisfaction.

--For Critical orders—which demand the fastest possible delivery,Regular Air was used most frequently (1,180 times), 
--which is acceptable depending on its speed relative to Express Air. However, Delivery Truck, the slowest method,
--was used more often (by 28 counts) than Express Air, which is the fastest but most expensive. 
--This suggests that some critical orders may have faced delays, potentially impacting urgent customer needs.

-- The same trend was observed for High priority orders. Low and Medium priorityorders also followed this pattern,

--In summary, while the company seems to favor Regular Air as a middle ground,
--the relatively high use of Delivery Truck for critical and high-priority orders implies a mismatch
--between order urgency and shipping speed, potentially compromising service quality.
--Moreover, Express Air was also used for low, medium and Not Specified-priority orders, this indicates unnecessary spending.

--To improve, the company should:
--1. Prioritize 'Express Air' for critical orders.
--2. Use 'Delivery Truck' mainly for low-priority orders.
--3. Consider the cost-speed balance of 'Regular Air' based on customer expectations and shipping deadlines.

