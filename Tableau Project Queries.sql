-- Queries used for Tableau Project

-- 1. 
-- Death Perentage of the whole world against Total Cases by now

SELECT  SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths AS INT)) AS Total_Deaths, 
	SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
ORDER BY 1,2


-- 2. 
-- Looking at the total death count by continents

SELECT Location, SUM(cast(new_deaths as int)) as TotalDeathCounts
FROM PortfolioProject..CovidDeaths
WHERE continent IS null
AND Location NOT IN ('world', 'European Union', 'International', 'Low income', 'Lower middle income', 'High income', 'Upper middle income')
GROUP BY Location
ORDER BY TotalDeathCounts DESC


-- 3. 
-- Looking at countries with highest infection rate compares to population

SELECT Location, population,  MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS "Percent_Population_Infected"
FROM PortfolioProject..CovidDeaths
-- WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
GROUP BY Location, population
ORDER BY Percent_Population_Infected DESC


-- 4. 
-- Looking at countries with highest infection rate compares to population with date

SELECT Location, population,date,  MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS "Percent_Population_Infected"
FROM PortfolioProject..CovidDeaths
-- WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
GROUP BY Location, population, date
ORDER BY Percent_Population_Infected DESC
