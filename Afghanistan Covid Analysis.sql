-- first,  just look at what's going on in Afghanistan 
SELECT  location, date, total_cases, new_cases, total_deaths, population
FROM covidanalysis.coviddeath;

-- Looking at total cases vs total deaths in Afghanistan 
SELECT location, date, total_cases,  total_deaths
FROM covidanalysis.coviddeath;

-- Showing the DeathPercentage during covid in Afghanistan over time
SELECT  location, date, total_cases,  total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM covidanalysis.coviddeath;

-- showing the date which the DeathPercentage is the highest
SELECT  location, date, total_cases,  total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM covidanalysis.coviddeath
ORDER BY DeathPercentage DESC
LIMIT 1;

-- Looking at toal cases vs population in Afghanistan 
SELECT  location, date, total_cases, population
FROM covidanalysis.coviddeath;

-- showing InfectionRate during covid in Afghanistan over time
SELECT  location, date, total_cases, (total_cases/population) * 100 as InfectonRate
FROM covidanalysis.coviddeath;

-- Looking at total population vs total vaccinations using join method
SELECT dea.location, dea.date, dea.population, vac.total_vaccinations
FROM covidanalysis.coviddeath dea
    JOIN covidanalysis.covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date;
    
 -- looking at vaccination smoothed successfully in Afghanistan
 -- 1st method
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations_smoothed
, SUM(vac.new_vaccinations_smoothed) OVER (Partition By dea.location) as Total_Vaccinations_Smoothed
, (SUM(vac.new_vaccinations_smoothed) OVER (Partition By dea.location)/ dea.population)*100  as SmothedRate
-- (Total_Vaccinations_Smoothed / dea.population)*100  as SmothedRate (wrong expression)
FROM covidanalysis.coviddeath dea
    JOIN covidanalysis.covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date;
-- 2nd method using CTE
With PopvsVac(location, date, population,new_vaccinations_smoothed, Total_Vaccinations_Smoothed)
as
(SELECT dea.location, dea.date, dea.population, vac.new_vaccinations_smoothed
, SUM(vac.new_vaccinations_smoothed) OVER (Partition By dea.location) as Total_Vaccinations_Smoothed
FROM covidanalysis.coviddeath dea
    JOIN covidanalysis.covidvaccinations vac
	ON dea.location = vac.location
    and dea.date = vac.date
)
select *, (Total_Vaccinations_Smoothed / population)*100  as SmothedRate
from PopvsVac;















