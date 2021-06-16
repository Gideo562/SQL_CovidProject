select *
from PortfolioProject..covid_deaths
where continent is not null
order by 3,4

select *
from PortfolioProject..covid_vaccinations
order by 3,4

--Selecting data we are going to use
select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..covid_deaths
where continent is not null
order by 1,2


-- Looking at total cases vs total deaths
-- Shows the likelihood of dying if you contract covid in your country
select location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..covid_deaths
where location like 'United States'
and continent is not null
order by 1,2

-- Looking at total cases vs Population
-- Shows the percentage of the population got covid
select location,date,total_cases,population, (total_cases/population) * 100 as PopulationPercentInfected
from PortfolioProject..covid_deaths
where location like 'United States'
and continent is not null
order by 1,2

-- Looking at countries with Highest Infection Rate compared to Population
select location,MAX(total_cases) as HighestInfectionCount ,population, MAX((total_cases/population)) * 100 as PopulationPercentInfected
from PortfolioProject..covid_deaths
where location like 'United States'
and continent is not null
group by population,location
order by PopulationPercentInfected desc


-- Showing the countries with the highest death count per population
select location, MAX(cast (total_deaths as int)) as HighestDeathCount
from PortfolioProject..covid_deaths
where continent is not null
group by location
order by HighestDeathCount desc

-- PARSINGING DATA BY CONTINENT

-- Showing the continents with the highest death count
select continent, MAX(cast (total_deaths as int)) as HighestDeathCount
from PortfolioProject..covid_deaths
where continent is not null
group by continent
order by HighestDeathCount desc

-- Global Numbers

select date,Sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(total_cases) * 100 as DeathPercentage
from PortfolioProject..covid_deaths
-- where location like 'United States'
Where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccinaton

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.locaton,dea.date) as RollingPeopleVaccinated
from PortfolioProject..covid_deaths dea 
join PortfolioProject..covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 
	