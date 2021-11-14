SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
ORDER BY 1,2

-- Looking at Total cases vs Total Deaths
-- It shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
ORDER BY 1,2

-- Looking at the Total Cases  vs Population
-- Shoes what percentage of population got covid

SELECT Location, date, population,  total_cases, (total_cases/population)*100 AS "Percent_Population_Infected"
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
ORDER BY 1,2

-- Query 2 for Tableau
-- Looking at the total death count by continents
SELECT Location, SUM(cast(new_deaths as int)) as TotalDeathCounts
FROM PortfolioProject..CovidDeaths
WHERE continent IS null
AND Location NOT IN ('world', 'European Union', 'International', 'Low income', 'Lower middle income', 'High income', 'Upper middle income')
GROUP BY Location
ORDER BY TotalDeathCounts DESC



-- 3rd Query for Tableau
-- Looking at countries with highest infection rate compares to population

SELECT Location, population,  MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS "Percent_Population_Infected"
FROM PortfolioProject..CovidDeaths
-- WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
GROUP BY Location, population
ORDER BY Percent_Population_Infected DESC

-- 4th Query for Tableau
-- Looking at countries with highest infection rate compares to population with date
SELECT Location, population,date,  MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population))*100 AS "Percent_Population_Infected"
FROM PortfolioProject..CovidDeaths
-- WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
GROUP BY Location, population, date
ORDER BY Percent_Population_Infected DESC

-- Showing countries with highest death count per population

SELECT Location, MAX(cast(Total_deaths as int)) AS  Total_Death_Count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
-- WHERE Location LIKE '%canada%'
GROUP BY Location, population
ORDER BY Total_Death_Count DESC

-- GLOBAL NUMBERS
-- Death Percentage of the whole world against Total Cases as per the date

SELECT date, SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths AS INT)) AS Total_Deaths, 
	SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
GROUP BY date
ORDER BY 1,2


-- Query 1 for Tableau
-- Death Perentage of the whole world against Total Cases by now

SELECT  SUM(new_cases) AS Total_Cases, SUM(cast(new_deaths AS INT)) AS Total_Deaths, 
	SUM(cast(new_deaths AS INT)) / SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT null
ORDER BY 1,2

-- LOOKING AT THE TOTAL POPULATION VS VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CONVERT(BIGINT, vac.new_vaccinations )) OVER (Partition By dea.location) as Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2, 3


-- USE CTE (Common Table expression)

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, Rolling_People_Vaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CONVERT(BIGINT, vac.new_vaccinations )) OVER (Partition By dea.location ORDER BY dea.location, dea.date) as Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
-- ORDER BY 2, 3
)
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopvsVac


-- TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated2
Create Table #PercentPopulationVaccinated2
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #PercentPopulationVaccinated2
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
SELECT *, (Rolling_People_Vaccinated/Population)*100 AS Increasing_Percentage
FROM #PercentPopulationVaccinated2
-- ORDER BY 2, 3
-- SELECT *, (Rolling_People_Vaccinated/Population)*100



-- Creating view to store data 

Create View PercentPopulationVaccinated2 as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Rolling_People_Vaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
-- Order by 2,3

Select *
FROM PercentPopulationVaccinated2







