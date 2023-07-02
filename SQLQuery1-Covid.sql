Select *
From [Portofolio Project]..CovidDeaths$
where continent is not null
Order by 3,4

--Select *
--From [Portofolio Project]..CovidVaccinations$
--Order by 3,4



-- Select Data yang akan digunakan saja

Select location, date, total_cases, new_cases, total_deaths, population
From [Portofolio Project]..CovidDeaths$
Order by 1,2



--Melihat Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portofolio Project]..CovidDeaths$
Where location like '%states%'
Order by 1,2



-- Melihat Total Cases vs Population

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From [Portofolio Project]..CovidDeaths$
--Where location like '%states%'
Order by 1,2



-- Melihat Countries dengan Highest Infection Rate dibandingkan dengan Population

Select location, population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [Portofolio Project]..CovidDeaths$
--Where location like '%states%'
Group by location, population
Order by PercentPopulationInfected desc



--Melihat Countries dengan Highest Death Count per Population


Select location, MAX(total_deaths) as TotalDeathCount
From [Portofolio Project]..CovidDeaths$
--Where location like '%indonesia%'
where continent is not null
Group by location
Order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portofolio Project]..CovidDeaths$
--Where location like '%indonesia%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

--Melihat continent with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portofolio Project]..CovidDeaths$
--Where location like '%indonesia%'
where continent is not null
Group by continent
Order by TotalDeathCount desc


--Global Numer

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portofolio Project]..CovidDeaths$
--Where location like '%states%'
where continent is not null
--Group by date
Order by 1,2




--Melihat Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project].. CovidDeaths$ dea
Join [Portofolio Project].. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

--Use CTE

with PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project].. CovidDeaths$ dea
Join [Portofolio Project].. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE


DROP table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project].. CovidDeaths$ dea
Join [Portofolio Project].. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating View to Store data for later visualizations

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project].. CovidDeaths$ dea
Join [Portofolio Project].. CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3


Select *
From PercentPopulationVaccinated
