select *
From PortfolioProject..COVIDDEATHS
where continent is not null
order by 3,4

--select *
--From PortfolioProject..COVIDVaccination
--order by 3,4

--select Data that we are going to be using


select 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
From PortfolioProject..COVIDDEATHS
order by 1,2

--Looking at Total Cases vs Total Deaths
--shows the likelihood of dying if you contract covid in your country

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS decimal) / CAST(total_cases AS decimal)) * 100 AS DeathPercentage
FROM
    PortfolioProject..COVIDDEATHS
WHERE location like '%states%'
ORDER BY 1, 2;


-- Looking at Total Cases vs Population

SELECT
    location,
    date,
    total_cases,
    population,
    (CAST(total_cases AS decimal) / CAST(population AS decimal)) * 100 AS DeathPercentage
FROM
    PortfolioProject..COVIDDEATHS
WHERE location like '%states%'
ORDER BY 1, 2;


--Looking at Countries with Highest Infection Rate compared to population

SELECT
    location,
    date,
    MAX(total_cases) as HighestInfectionCount,
    population,
    (MAX(CAST(total_cases AS decimal) / CAST(population AS decimal)) * 100) AS PercentagePopulationInfected
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
GROUP BY Location, Population
--ORDER BY PercentagePopulationInfected desc




SELECT
    location,
    date,
    MAX(total_cases) as HighestInfectionCount,
    population,
    (MAX(CAST(total_cases AS decimal)) / CAST(population AS decimal)) * 100 AS PercentagePopulationInfected
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
GROUP BY location, date, population
ORDER BY PercentagePopulationInfected


--select *
--From PortfolioProject..COVIDVaccination
--order by 3,4

--select Data that we are going to be using


select 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
From PortfolioProject..COVIDDEATHS
order by 1,2

--Looking at Total Cases vs Total Deaths
--shows the likelihood of dying if you contract covid in your country

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS decimal) / CAST(total_cases AS decimal)) * 100 AS DeathPercentage
FROM
    PortfolioProject..COVIDDEATHS
WHERE location like '%states%'
ORDER BY
    1, 2;


-- Looking at Total Cases vs Population

SELECT
    location,
    date,
    total_cases,
    population,
    (CAST(total_cases AS decimal) / CAST(population AS decimal)) * 100 AS DeathPercentage
FROM
    PortfolioProject..COVIDDEATHS
WHERE location like '%states%'
ORDER BY 1, 2;


--Looking at Countries with Highest Infection Rate compared to population

SELECT
    location,
    date,
    MAX(total_cases) as HighestInfectionCount,
    population,
    (MAX(CAST(total_cases AS decimal) / CAST(population AS decimal)) * 100) AS PercentagePopulationInfected
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
GROUP BY Location, Population
--ORDER BY PercentagePopulationInfected desc


SELECT
    location,
	population,
    MAX(total_cases) as HighestInfectionCount,
    (MAX(CAST(total_cases AS decimal)) / CAST(population AS decimal)) * 100 AS PercentagePopulationInfected
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentagePopulationInfected;

--showing with the Highest death count per Population


SELECT
    location,
    MAX(CAST(total_deaths AS INT)) as TotaldeathCount
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
WHERE CONTINENT IS NOT NULL
GROUP BY location
ORDER BY TotaldeathCount desc;


--LETS BREAK THINGS DOWN BY CONTINENT

SELECT
    CONTINENT,
    MAX(CAST(total_deaths AS INT)) as TotaldeathCount
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
WHERE CONTINENT IS NOT NULL
GROUP BY CONTINENT
ORDER BY TotaldeathCount desc;

---SHOWING THE CONITNENT WITH THE HIGHEST DEATHS COUNT

SELECT
    continent,
    MAX(CAST(total_deaths AS INT)) as TotaldeathCount
FROM
    PortfolioProject..COVIDDEATHS
--WHERE location like '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotaldeathCount desc


--Global Numbers

SELECT
    --date,
    SUM(CAST(new_cases AS INT)) as total_cases,
	SUM(CAST(new_deaths AS INT)) as total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS DECIMAL)) <> 0
        THEN (SUM(CAST(new_deaths AS DECIMAL)) / SUM(CAST(new_cases AS DECIMAL))) * 100
        ELSE 0
    END AS DeathPercentage
FROM
    PortfolioProject..COVIDDEATHS
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2;


--Looking at Total Population vs Vaccinations

select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..COVIDDEATHS dea
Join PortfolioProject..COVIDVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Temp Table

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
);

insert into #PercentPopulationVaccinated
select 
dea.continent, 
dea.location, 
dea.date, 
dea.population, 
vac.new_vaccinations, RollingPeopleVaccinated
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..COVIDDEATHS dea
Join PortfolioProject..COVIDVaccinations vac
On dea.location = vac.location
And dea.date = vac.date
where dea.continent is not null;
--order by 2,3

drop table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
    continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccination numeric,
    RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM
    PortfolioProject..COVIDDEATHS dea
JOIN
    PortfolioProject..COVIDVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
--WHERE
--    dea.continent IS NOT NULL;

select *
From #PercentPopulationVaccinated




--creating to View to store data for later visualization

create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as BIGINT)) OVER (partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from PortfolioProject..COVIDDEATHS dea
join PortfolioProject..COVIDVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;
--order by 2,3


select *
From PercentPopulationVaccinated