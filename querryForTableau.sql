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
WHERE (CoDea.location LIKE '%World%' OR CoDea.location LIKE '%state%')
	AND CoVac.date = '2021-08-29'


--------------------------------------
--- Infection Rate in Each Country ---
SELECT location, population, MAX(total_cases) / MAX(population) * 100 infection_rate
FROM CovidDeaths$
GROUP BY location, population
ORDER BY 3 DESC

---------------------------------------------------
--- Total Positive Cases and Deaths by Continent---
SELECT location continent_name, MAX(CAST(total_cases AS INT)) positive_cases, MAX(CAST(total_deaths AS INT)) confirmed_deaths
FROM CovidDeaths$
WHERE continent IS NULL AND location <> 'World'
GROUP BY location

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
