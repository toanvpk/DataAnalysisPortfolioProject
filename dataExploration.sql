/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions,
Aggregate Functions, Creating Views, Converting Data Types
*/
-----------------------------------------------------
--- Have an Overall Look at the CovidDeaths Table ---
SELECT *
FROM CovidDeaths$

----------------------------------------------------------
--- Have an Overall Look at the CovidVaccination Table ---

SELECT *
FROM CovidVaccination$

-- Tableau --
-----------------------------------
--- Some Global Numbers ----------
SELECT CoDea.location, CoDea.date, CoDea.population, CoDea.total_cases,
		CoDea.total_deaths, CoVac.total_vaccinations,
		CoDea.total_cases/CoDea.population * 100 infection_rate,
		CoDea.total_deaths/CoDea.total_cases * 100 death_rate,
		CoVac.total_vaccinations/CoDea.population * 100 vaccination_rate
FROM CovidDeaths$ CoDea
JOIN CovidVaccination$ CoVac
ON CoDea.location = CoVac.location
AND CoDea.date = CoVac.date
WHERE CoDea.location LIKE '%World%'
	AND CoVac.date = '2021-08-29'

-----------------------------------
--- Total Cases in the US----------

SELECT date, total_cases
FROM CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1

--------------------------------------
--- Total Cases in the World----------

SELECT date, total_cases
FROM CovidDeaths$
WHERE location LIKE '%World%'
ORDER BY 1

---------------------------------------------------------------------
--- Infection Rate and Death Rate Over Time in the US vs the World---

SELECT date, location, total_cases / population * 100 infection_rate,
		total_deaths / total_cases * 100 death_rate
FROM CovidDeaths$
WHERE location LIKE '%states%' OR location LIKE '%WORLD%'
ORDER BY 1, 2

--Tableau--
--------------------------------------
--- Infection Rate in Each Country ---
SELECT location, population, MAX(total_cases) / MAX(population) * 100 infection_rate
FROM CovidDeaths$
GROUP BY location, population
ORDER BY 3 DESC

--Tableau--
---------------------------------------------------
--- Total Positive Cases and Deaths by Continent---
SELECT location continent_name, MAX(CAST(total_cases AS INT)) positive_cases, MAX(CAST(total_deaths AS INT)) confirmed_deaths
FROM CovidDeaths$
WHERE continent IS NULL AND location <> 'World'
GROUP BY location

--Tableau--
-----------------------------------------------------
--- Infection Rate vs Vaccination Rate in the US ---
SELECT CoDea.location, CoDea.date, CoDea.population, CoDea.total_cases, CoVac.total_vaccinations,
		CoDea.total_cases/CoDea.population * 100 infection_rate,
		CoVac.total_vaccinations/CoDea.population * 100 vaccination_rate
FROM CovidDeaths$ CoDea
JOIN CovidVaccination$ CoVac
ON CoDea.location = CoVac.location
AND CoDea.date = CoVac.date
WHERE CoDea.location LIKE '%state%'
ORDER BY CoDea.date

------------------------------------------------------------------------
--- Total Vaccinations in Each Continent Since the First Vaccination ---
SELECT CoDea.location, CoDea.date, CoDea.population, CoVac.new_vaccinations,
		SUM(CAST(CoVac.new_vaccinations AS BIGINT))	OVER (PARTITION BY Codea.location ORDER BY CoDea.location, CoDea.date) total_vaccinations
FROM CovidDeaths$ CoDea
JOIN CovidVaccination$ CoVac
ON CoDea.location = CoVac.location
AND CoDea.date = CoVac.date
WHERE CoDea.continent IS NULL AND CoDea.location <> 'World' AND CoVac.new_vaccinations IS NOT NULL
ORDER BY 1, 2



-- Create View
CREATE VIEW By_Continent AS
SELECT location, continent, MAX(total_deaths) max_deaths
FROM CovidDeaths$
WHERE continent IS NULL AND total_deaths IS NOT NULL
GROUP BY location, continent

-- Death each day
SELECT date, location, new_deaths
FROM CovidDeaths$
WHERE new_deaths IS NOT NULL AND location LIKE '%vietnam%'
ORDER BY 1

