-- Inspecting data
SELECT * FROM [dbo].[Unicorn_Companies]

-- Top 5 Industries by valuation 
SELECT TOP 5 Industry, SUM(CAST(Valuation AS INT)) AS Valuation 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp 
GROUP BY Industry 
ORDER BY Valuation DESC 

-- Countries with highest number of unicorns 
SELECT Country, COUNT(*) AS Total_Number
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY Country 
ORDER BY Total_Number DESC 


-- Funding to Valuation ratio
SELECT Company, Valuation, Funding, CAST(Valuation AS float)/ NULLIF(CAST(Funding AS float),0) AS Ratio 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','000000000') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B','000000000'),'M','000000'),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY Company, Valuation, Funding 
ORDER BY Ratio DESC


-- Canada Companies 
--SELECT *
--FROM [dbo].[Unicorn_Companies]
-- WHERE Country='Canada' AND Year_Founded < 2022
-- ORDER BY Year_Founded

-- Continents with highest number of unicorns 
SELECT Continent, COUNT(*) AS Total_Number
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY continent  
ORDER BY Total_Number DESC 


-- Cities with highest number of unicorns 
SELECT City, COUNT(*) AS Total_Number
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY City   
ORDER BY Total_Number DESC 


-- Top 5 Valued companies between year 2010 and 2020
SELECT Top 5 Company, SUM(CAST(Valuation AS INT)) AS Valuation, Date_Joined
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
WHERE DATE_Joined BETWEEN '2010-01-01' AND '2021-01-01'
GROUP BY Company, Date_Joined   
ORDER BY Valuation DESC 


-- Top 5 Valued companies between year 2000 and 2010
SELECT Top 5 Company, SUM(CAST(Valuation AS INT)) AS Valuation, Date_Joined
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
WHERE DATE_Joined BETWEEN '2000-01-01' AND '2011-01-01'
GROUP BY Company, Date_Joined   
ORDER BY Valuation DESC 


-- Top 5 companies by valuation 
SELECT Top 5 Company, CAST(Valuation AS INT) AS Valuation 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
ORDER BY Valuation DESC 


-- Duration of companies to reach unicorn 
SELECT Company, (DATENAME(YEAR, Date_Joined) - Year_Founded) AS Duration 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
ORDER BY Duration


-- Average duration of companies to reach unicorn 
SELECT AVG(DATENAME(YEAR, Date_Joined) - Year_Founded) AS Avg_Duration 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp


-- Average duration of Top 5 countries to reach unicorn 
SELECT Top 5 Country, AVG(DATENAME(YEAR, Date_Joined) - Year_Founded) AS Avg_Duration 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY Country 
ORDER BY Avg_Duration


-- Countries with average valuation 
SELECT Top 5 Country, AVG(CAST(Valuation AS INT)) AS Avg_Valuation 
FROM (
		SELECT [Company]
		,REPLACE(REPLACE([Valuation],'$',''),'B','') AS Valuation
		,[Date_Joined]
		,[Industry]
		,[City]
		,[Country]
		,[Continent]
		,[Year_Founded]
		,REPLACE(REPLACE(REPLACE(REPLACE([Funding],'$',''),'B',''),'M',''),'Unknown','0') AS Funding
		,[Select_Investors] 
		FROM [dbo].[Unicorn_Companies]) As Temp
GROUP BY Country 
ORDER BY Avg_Valuation DESC 