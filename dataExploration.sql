--SELECT *
--FROM CovidDeaths$
--ORDER BY 3, 4

--SELECT *
--FROM CovidVaccination$
--ORDER BY 3, 4


-- Death Rate in the US

--SELECT location, date, total_cases, total_deaths, total_deaths / total_cases * 100 death_rate
--FROM CovidDeaths$
--WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
--	AND location LIKE '%states%'

-- Total cases vs Population

--SELECT location, date, population, total_cases, total_cases / population * 100 infection_rate
--FROM CovidDeaths$
--WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
--	AND location LIKE '%states%'
--ORDER BY 1, 2


-- Total Cases in each country
SELECT location, population, MAX(total_cases) 
FROM CovidDeaths$
GROUP BY location, population
ORDER BY 3 DESC

-- Infection Rate in each country

SELECT location, population, MAX(total_cases), MAX(total_cases / population * 100) AS infection_rate
FROM CovidDeaths$
GROUP BY location, population
ORDER BY 4 DESC

-- Death Rate in each country

SELECT location, population, MAX(total_deaths / total_cases * 100) AS death_rate
FROM CovidDeaths$
GROUP BY location, population
ORDER BY 3 DESC

SELECT location, continent, total_deaths
FROM CovidDeaths$
ORDER BY 2 DESC

SELECT continent, SUM(CAST(total_deaths AS INT))
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC

SELECT continent, total_deaths
FROM CovidDeaths$
WHERE continent IS NULL

SELECT DISTINCT location, MAX(total_deaths)
FROM CovidDeaths$
WHERE continent IS NULL
GROUP BY location

SELECT DISTINCT location, continent
FROM CovidDeaths$
WHERE continent LIKE '%North Ame%'
ORDER BY 1

SELECT location, continent, MAX(total_deaths) max_deaths
FROM CovidDeaths$
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY location, continent

WITH t1 AS (
	SELECT location, continent, MAX(total_deaths) max_deaths
	FROM CovidDeaths$
	WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
	GROUP BY location, continent
)
SELECT continent, SUM(CAST(max_deaths AS INT))
FROM t1
GROUP BY continent

SELECT location, continent, MAX(total_deaths) max_deaths
FROM CovidDeaths$
WHERE continent IS NULL AND total_deaths IS NOT NULL
GROUP BY location, continent

-- Death each day
SELECT date, location, new_cases
FROM CovidDeaths$
WHERE new_cases IS NOT NULL AND location LIKE '%vietnam%'
ORDER BY 3


-- Create View
CREATE VIEW By_Continent AS
SELECT location, continent, MAX(total_deaths) max_deaths
FROM CovidDeaths$
WHERE continent IS NULL AND total_deaths IS NOT NULL
GROUP BY location, continent