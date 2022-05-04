
Select*
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4


--Select*
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select the Data that we are going to be using


Select location, date, total_cases, new_cases,total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


--looking at Total cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentages
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


--Looking at Total cases vs Population
--Shows what percentage of population got covid

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationIndfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
order by 1,2


--Looking at Countries with heighest Infection Rate compared tp population


Select location, population, MAX( total_cases) as HighestInfectionCount , MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location,Population
order by PercentPopulationInfected desc


--Showing the country with the Highest Death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Let's BREAK tTHINGS DOWN BY CONTINENT 




--Showing the continent with highest deathcount per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group By date
order by 1,2


--Looking at Total population vs Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3



--USE CTE

With PopvsVac (Continent,Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3


Select*, (RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated


 --Creating View to store data for later visualization 


Create View PercentPopulationVaccinated as

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date)
 as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location =  vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3



Select*
From PercentPopulationVaccinated




























