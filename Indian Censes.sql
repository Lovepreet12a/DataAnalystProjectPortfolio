SELECT * FROM [dbo].[Data1]
SELECT * FROM [dbo].[Data2]

-- Count of rows into our datasets 
SELECT COUNT(*) FROM [dbo].[Data1]

SELECT COUNT(*) FROM [dbo].[Data2]

-- Extracting the data for 2 states only
SELECT * FROM [dbo].[Data1]
WHERE State IN ('Maharashtra', 'Gujarat')

-- Total Population of India 
SELECT  SUM(Population) AS Total_Population
FROM [dbo].[Data2]

-- Average growth in India 
SELECT CAST((ROUND(100*AVG(Growth),2)) AS FLOAT) + CAST('%' AS FLOAT) 
FROM [dbo].[Data1]

-- Average growth %age of states in India 
SELECT State, (CAST(ROUND(100*AVG(Growth),2) AS VARCHAR(10))) As Average
FROM [dbo].[Data1]
GROUP BY State 

-- Average sex ratio per state
SELECT State, ROUND(AVG(Sex_Ratio),0) AS Average_SexRatio
FROM [dbo].[Data1]
GROUP BY State 
ORDER BY Average_SexRatio DESC 

-- States with more than 90 Average Literacy rate. 
SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy_Rate 
FROM [dbo].[Data1]
GROUP BY State 
HAVING ROUND(AVG(Literacy),0) > 90

-- Top 3 states displaying highest growth% ratio 
SELECT TOP 3 State, ROUND(100*AVG(Growth),2) AS Average_Growth
FROM [dbo].[Data1]
GROUP BY State 
ORDER BY Average_Growth DESC 

-- 3 States with lowest sex ratio 
SELECT TOP 3 State, ROUND(AVG(Sex_Ratio),0) AS Average_SexRatio 
FROM [dbo].[Data1]
GROUP BY State 
ORDER BY Average_SexRatio ASC 

-- Top 3 and Bottom 3 Literacy rate States
SELECT * FROM (SELECT TOP 3 State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM [dbo].[Data1]
GROUP BY State 
ORDER BY Avg_Literacy) a
UNION ALL 
SELECT * FROM (SELECT TOP 3 State, ROUND(AVG(Literacy),0) AS Avg_Literacy
FROM [dbo].[Data1]
GROUP BY State 
ORDER BY Avg_Literacy DESC) b

-- Filtering the states that are starting with letter A or B
SELECT DISTINCT State 
FROM [dbo].[Data1]
WHERE State LIKE '[AB]%'

-- Filtering the states that are starting with letter A OR ending with letter D
SELECT DISTINCT State 
FROM [dbo].[Data1]
WHERE LOWER(State) LIKE 'A%' OR LOWER(State) LIKE '%d'

-- Finding the number of males and females by Districts
SELECT D1.State, D1.District, Sex_Ratio, Population, ROUND(Population/(Sex_Ratio/1000+1),0) AS Males, 
ROUND((Population-Population/(Sex_Ratio/1000+1)),0) AS Females 
FROM [dbo].[Data1] D1
JOIN [dbo].[Data2] D2 
ON D1.District = D2.District 

-- Finding the total number of males and females by States 
SELECT State, SUM(Males) Total_Males, SUM(Females) Total_Females FROM
(SELECT D1.State, D1.District, Sex_Ratio, Population, ROUND(Population/(Sex_Ratio/1000+1),0) Males, 
ROUND((Population-Population/(Sex_Ratio/1000+1)),0) Females 
FROM [dbo].[Data1] D1
JOIN [dbo].[Data2] D2 
ON D1.State = D2.State) a 
GROUP BY State

-- Finding the literacy rate in each state
SELECT State, ROUND(AVG(Literacy),0) AS Avg_Literacy 
FROM [dbo].[Data1]
GROUP BY State 

-- Finding the literate and illeterate people
SELECT D1.State, D1.District, D2.Population, ROUND(D2.Population*Literacy/100,0) AS Literate_People, 
ROUND(D2.Population*(1-Literacy/100),0) AS Illeterate_People 
FROM [dbo].[Data1] D1 
JOIN [dbo].[Data2] D2 
ON D1.District = D2.District 

-- Finding the literate and illeterate people per state 
SELECT State, SUM(Literate_People) AS Total_Literate, SUM(Illeterate_People) AS Total_Illeterate FROM 
(SELECT D1.State, D1.District, D2.Population, ROUND(D2.Population*Literacy/100,0) AS Literate_People, 
ROUND(D2.Population*(1-Literacy/100),0) AS Illeterate_People 
FROM [dbo].[Data1] D1 
JOIN [dbo].[Data2] D2
ON D1.District = D2.District) a
GROUP BY State

-- Finding the population of previous censes
SELECT D1.District, D1.State, Growth, Population AS Current_Census_Population
, ROUND((1-Growth)*Population,0) AS Previous_Census_Population  
FROM [dbo].[Data1] D1 
JOIN [dbo].[Data2] D2 
ON D1.District = D2.District

-- Finding the population of previous census per state
SELECT State, SUM(Previous_Census_Population) AS Total_Previous_Census_Population, 
SUM(Current_Census_Population) AS Total_Current_Census_Population FROM
(SELECT D1.District, D1.State, Growth, Population AS Current_Census_Population
, ROUND((1-Growth)*Population,0) AS Previous_Census_Population  
FROM [dbo].[Data1] D1 
JOIN [dbo].[Data2] D2 
ON D1.District = D2.District) a
GROUP BY State

-- Finding the Total population of previous census and current census 
SELECT SUM(Population) AS Current_Census_Population
, SUM(ROUND((1-Growth)*Population,0)) AS Previous_Census_Population  
FROM [dbo].[Data1] D1 
JOIN [dbo].[Data2] D2 
ON D1.District = D2.District











