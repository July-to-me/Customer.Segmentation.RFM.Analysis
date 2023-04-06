---- SEEING DATA ----
SELECT * FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]

ALTER TABLE [Data_Science_Portfolio].[dbo].[sales_data_sample] ALTER COLUMN YEAR_ID INT;

----Checking unique values of data ---- 
SELECT distinct ORDERNUMBER FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct STATUS FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct PRODUCTLINE FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct COUNTRY FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct DEALSIZE FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct CITY FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
SELECT distinct TERRITORY FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]

--Analyze Data --

--- Grouping all sales by productline 
SELECT PRODUCTLINE, sum(sales) AS sum_sales FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
GROUP BY PRODUCTLINE
ORDER BY 2 DESC

-- GROUP Sales based on year 
SELECT YEAR_ID, sum(sales) AS sum_sales FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
GROUP BY YEAR_ID 
ORDER BY YEAR_ID DESC;

--- Seeing the operating months of each year
SELECT DISTINCT MONTH_ID FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2005 -- We can see that the company only operated for 5 months in the year 2005
-- We should take note of that for future anaylsis

SELECT DISTINCT MONTH_ID FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004

SELECT DISTINCT MONTH_ID FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2003

--- GROUP Sales based on Dealsize 
SELECT DEALSIZE, sum(sales) AS sum_sales FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
GROUP BY DEALSIZE 
ORDER BY 2 DESC;

--- Seeing which month is best for each specific year. 
SELECT MONTH_ID, sum(sales) AS sum_sales, COUNT(ordernumber) AS frequency FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2005 -- May (Month 5) Generated the most amount of money for the company 
GROUP BY month_id
ORDER BY 2 DESC

SELECT MONTH_ID, sum(sales) AS sum_sales, COUNT(ordernumber) AS frequency FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004 --   November (Month 11) Generated the most amount of money for the company 
GROUP BY month_id
ORDER BY 2 DESC

SELECT MONTH_ID, sum(sales) AS sum_sales, COUNT(ordernumber) AS frequency FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 --   November (Month 11) Generated the most amount of money for the company 
GROUP BY month_id
ORDER BY 2 DESC

-- We can check which type of product they sold best of said months 

SELECT MONTH_ID, PRODUCTLINE, sum(sales) AS sum_sales, COUNT(ordernumber) FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2005 AND MONTH_ID = 5
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC


SELECT MONTH_ID, PRODUCTLINE, sum(sales) AS sum_sales, COUNT(ordernumber) FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004 AND MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC

SELECT MONTH_ID, PRODUCTLINE, sum(sales) AS sum_sales, COUNT(ordernumber) FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 AND MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC

-- It does seem that classic cars are the most sold product for all the years. \

-- Who are our best customer? 
-- Creating a temporary table for this occasion
DROP TABLE IF EXISTS #rfm_analysis
; WITH rfm_analysis AS
(
	SELECT 
		CUSTOMERNAME, 
		SUM(sales) AS sum_sales,
		AVG(sales) AS avg_sales,
		COUNT(ORDERNUMBER) AS frequency,
		max(ORDERDATE) last_order_date,
		(SELECT max(ORDERDATE) FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]) AS max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (SELECT max(ORDERDATE) from [Data_Science_Portfolio].[dbo].[sales_data_sample])) AS recency
	FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
), 


-- Creating 4 categories for potential clusters to do for rfm
rfm_calc as
(

	select r.*,
		NTILE(4) OVER (order by recency desc) AS rfm_recency,
		NTILE(4) OVER (order by frequency) AS rfm_frequency,
		NTILE(4) OVER (order by avg_sales) AS rfm_monetary
	from rfm_analysis AS r
)
-- Values will get numbers from 1-4 from rfm functions
-- Will also create another variable to get the sum of rfm
-- CALLING calc
SELECT c.*, rfm_recency+rfm_frequency+rfm_monetary AS rfm_sum,
CAST(rfm_recency AS varchar) + CAST(rfm_frequency AS varchar) + CAST(rfm_monetary AS varchar)  AS rfm_sum_string
INTO #rfm_analysis
FROM rfm_calc AS c


--- I also want to create a new variable that will state who's a high value customer and who is not
SELECT 
	CUSTOMERNAME, rfm_recency+rfm_frequency+rfm_monetary AS rfm_sum,
	CASE
		WHEN rfm_sum >= 10 THEN 'Loyal Customer'
		WHEN rfm_sum BETWEEN 8 AND 9 THEN 'Active Customer'
		WHEN rfm_sum BETWEEN 6 AND 7 THEN 'Potential/New Customer'
		WHEN rfm_sum BETWEEN 4 AND 5 THEN 'Losing Customer Interest'
		WHEN rfm_sum = 3 THEN 'Lost Customers'
		ELSE 'N/A'
	END AS rfm_segment
FROM #rfm_analysis

-- What type of products are being sold together?

SELECT DISTINCT ORDERNUMBER, STUFF(

	(SELECT ',' + PRODUCTCODE
	FROM [Data_Science_Portfolio].[dbo].[sales_data_sample] AS p
	WHERE ORDERNUMBER in 
		(

			SELECT ORDERNUMBER
			FROM (
				SELECT ORDERNUMBER, count(*) rn
				FROM [Data_Science_Portfolio].[dbo].[sales_data_sample]
				WHERE STATUS = 'Shipped'
				GROUP BY ORDERNUMBER
			)AS m
			WHERE rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		FOR xml path (''))

		, 1, 1, '') ProductCodes

FROM [Data_Science_Portfolio].[dbo].[sales_data_sample] s
ORDER BY 2 DESC

--- Price Across the City & Country 


-- How expensive is a product in America vs in other parts of the world 