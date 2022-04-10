-- Inspecting data 
SELECT * FROM [dbo].[sales_data_sample]

-- Checking unique  values 
SELECT DISTINCT STATUS FROM [dbo].[sales_data_sample] -- need to plot
SELECT DISTINCT YEAR_ID FROM [dbo].[sales_data_sample] 
SELECT DISTINCT PRODUCTLINE FROM [dbo].[sales_data_sample] -- need to plot 
SELECT DISTINCT COUNTRY FROM [dbo].[sales_data_sample] -- need to plot 
SELECT DISTINCT DEALSIZE FROM [dbo].[sales_data_sample] -- need to plot 
SELECT DISTINCT TERRITORY FROM [dbo].[sales_data_sample] -- need to plot 

-- Analysis data 
-- Sales by ProductLine
SELECT PRODUCTLINE, SUM(SALES) AS Revenue  
FROM [dbo].[sales_data_sample]
GROUP BY PRODUCTLINE 
ORDER BY Revenue DESC

-- Sales by Year_ID
SELECT YEAR_ID, SUM(SALES) AS Revenue  
FROM [dbo].[sales_data_sample]
GROUP BY YEAR_ID   
ORDER BY Revenue DESC

-- Sales by dealSize 
SELECT DEALSIZE, SUM(SALES) AS Revenue  
FROM [dbo].[sales_data_sample]
GROUP BY DEALSIZE   
ORDER BY Revenue DESC

-- What was the best month for sales in a specific year? How much was the revenue generated in that month? 
SELECT MONTH_ID, SUM(Sales) AS Revenue, COUNT(ORDERNUMBER) AS Frequency 
FROM [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003  -- Need to change the year to check results of another year
GROUP BY MONTH_ID 
ORDER BY Revenue DESC 

-- November seems to be thee best month, What product do they sell in November?
SELECT MONTH_ID, PRODUCTLINE, SUM(Sales) AS Revenue, COUNT(ORDERNUMBER) AS Frequency 
FROM [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 AND MONTH_ID = 11	-- Change the year to see another year's result 
GROUP BY MONTH_ID, PRODUCTLINE 
ORDER BY Revenue DESC 

-- Who is the best customer? (This could be best answered with Recency-Frequency-Monetary (RFM)) 
DROP TABLE IF EXISTS #RFM
;WITH RFM
AS
	(
	SELECT CUSTOMERNAME, COUNT(ORDERNUMBER) AS Frequency, SUM(Sales) AS MonetaryValue, AVG(Sales) AS AvgMonetaryValue, 
	MAX(CAST(ORDERDATE AS Date)) AS LastOrderDate, (SELECT MAX(CAST(ORDERDATE AS Date)) FROM [dbo].[sales_data_sample]) AS MaxOrderDate, 
	DATEDIFF(DAY, MAX(CAST(ORDERDATE AS Date)), (SELECT MAX(CAST(ORDERDATE AS Date)) FROM [dbo].[sales_data_sample])) AS Recency 
	FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
	), 
RFM_calc
AS
	(SELECT *, 
		NTILE(4) OVER (ORDER BY Recency) AS RFM_Recency, 
		NTILE(4) OVER (ORDER BY Frequency) AS RFM_Frequency, 
		NTILE(4) OVER (ORDER BY MonetaryValue) AS RFM_Monetary 
	FROM RFM R) 
SELECT *, RFM_Recency+RFM_Frequency+RFM_Monetary AS RFM_Cell, 
CAST(RFM_Recency AS varchar) + CAST(RFM_Frequency AS varchar) + CAST(RFM_Monetary  AS varchar) AS RFM_Cell_String 
INTO #RFM
FROM RFM_calc 

SELECT * FROM #RFM

SELECT CUSTOMERNAME, RFM_Recency, RFM_Frequency, RFM_Monetary,
	CASE 
		WHEN RFM_Cell <= 8 THEN 'low value customers'
		ELSE 'High value customers'
	END As RFM_Segment
FROM #RFM 


-- What products are most often sold together 
SELECT DISTINCT ORDERNUMBER, STUFF(
	(SELECT ',' + PRODUCTCODE 
	FROM [dbo].[sales_data_sample] 
	WHERE ORDERNUMBER IN
		(
		SELECT ORDERNUMBER 
		FROM
			(SELECT ORDERNUMBER, COUNT(*) AS Total
			FROM [dbo].[sales_data_sample]
			WHERE STATUS = 'Shipped'
			GROUP BY ORDERNUMBER ) Temp  
		WHERE Total = 9 -- change this to get different result 
		)
		FOR XML PATH ('')), 1, 1, '')  AS OrderCodes 
FROM [dbo].[sales_data_sample]
ORDER BY OrderCodes DESC 





