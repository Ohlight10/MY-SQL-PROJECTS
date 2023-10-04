
Select *
From PortfolioProjects.dbo.CovidDeaths
Where continent is not NULL
Order by 3,4

--Select *
--From PortfolioProjects.dbo.CovidVaccinations
--Order by 1,2

---select data that we are going to be using

Select Location, date, total_cases, New_Cases, total_deaths, Population
From PortfolioProjects.dbo.CovidDeaths
Order by 1,2

---Looking at the Total_Cases vs Total_Deaths
---
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentages
From PortfolioProjects.dbo.CovidDeaths
Where Location Like '%states%'
Order by 1,2

---Looking at the Total_Cases vs Population
---Shows what percentage of popolation get covid

Select Location, date, population, total_cases, (total_deaths/population)*100 as PercentPopulationinfected
From PortfolioProjects.dbo.CovidDeaths
--Where Location Like '%states%'
Order by 1,2

---Looking at countries with highest infection rate compare to population

Select Location, population, max (total_cases) as hihgestinfectioncount, max((total_cases/population))*100 as PercentPopulationinfected
From PortfolioProjects.dbo.CovidDeaths
--Where Location Like '%states%'
Group by location, population
Order by  PercentPopulationinfected desc

---Showing Countries with highest Death count per population

Select Location, max (total_deaths) as totaldeathcount
From PortfolioProjects.dbo.CovidDeaths
--Where Location Like '%states%'
Where continent is not NULL
Group by location
Order by totaldeathcount  desc

---Let break it down by continent

---Showing Continents with the highest Death count per population


Select Continent, max (total_deaths) as totaldeathcount
From PortfolioProjects.dbo.CovidDeaths
--Where Location Like '%states%'
Where continent is not NULL
Group by Continent
Order by totaldeathcount  desc

---Global Numbers

Select  SUM(New_cases), SUM(New_deaths), SUM(New_cases)/SUM(New_deaths)*100 as Deathpercentage
From PortfolioProjects.dbo.CovidDeaths
--Where Location Like '%states%'
Where Continent is not Null
Group by date
Order by 1,2

--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinate
From PortfolioProjects.dbo.CovidDeaths dea
Join PortfolioProjects.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.Continent is not null
Order by 2,3

--Use CTE

With popvsvac (continent, location, date, population, new_vaccinations,  Rollingpeoplevaccinate)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinate
From PortfolioProjects.dbo.CovidDeaths dea
Join PortfolioProjects.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.Continent is not null
--Order by 2,3
)
Select *, (Rollingpeoplevaccinate/population)
From popvsvac

---Temp Table
Drop Table if exists #PercentPOpulationVaccinated
CREATE TABLE #PercentPOpulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
Rollingpeoplevaccinate numeric
)
Insert into #PercentPOpulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinate
From PortfolioProjects.dbo.CovidDeaths dea
Join PortfolioProjects.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.Continent is not null
--Order by 2,3
Select *, (Rollingpeoplevaccinate/population)
From #PercentPOpulationVaccinated

---Creating view to store data for later visualization

Create view  PercentPOpulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinate
From PortfolioProjects.dbo.CovidDeaths dea
Join PortfolioProjects.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.Continent is not null
--Order by 2,3

Select *
From PercentPOpulationVaccinated
