select  * 
from CovidVaccinations
--Select data that we are going to be using
select location,date,total_cases,new_cases,total_deaths,population 
from CovidDeaths
order by 3,4


--Lookin  Total cases vs Total deaths
--Shows likelihood od dying if you contract in you country
select location,date, total_cases,total_deaths, (total_deaths/total_cases)* 100
as DeathPercentage
from CovidDeaths
where location='Azerbaijan' and location is not null
order by 1,2


--Looking at Total cases vs Population
select location, population,total_cases,
(total_cases/population)* 100
as DeathPercentage
from CovidDeaths
order by 1,2


--Looking at countries with Hightest Infection Rate compared to Population
select location, population,Max (total_cases) as HigestInfectionCount,
MAX((total_cases/population)* 100)
as PercentagePopulationInfection
from CovidDeaths
--where location='Azerbaijan'
group by  location,population
order by PercentagePopulationInfection desc


--Showing countries with highest death Count per Population

select location, population,Max (total_deaths) as TotalDeathsCount,
MAX((total_cases/population)* 100)
as PercentagePopulationInfection
from CovidDeaths
--where location='Azerbaijan'
group by  location,population
order by PercentagePopulationInfection desc

--Showing countries with highest death count per population

select location,Max (total_deaths) as TotalDeathsCount
from CovidDeaths
--where location='Azerbaijan'
where location is not null
group by  location
order by TotalDeathsCount desc


--Showig continent with the things death count per population

 select continent,Max (total_deaths) as TotalDeathsCount
from CovidDeaths
--where location='Azerbaijan'
 where continent is not null
group by  continent
order by TotalDeathsCount desc


select * from CovidDeaths
where location is not null
order by 3,4 


--lets break things by continent


 select location,Max (Cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
--where location='Azerbaijan'
 where location is not null
group by  location
order by TotalDeathsCount desc




--Global numbers[dbo].[NashvilleHousing]
select ---date,
SUM(new_cases) as total_cases,
SUM(Cast(new_deaths as int)) as total_deaths,
SUM(Cast(new_deaths as int))/sum(new_cases) * 100 as DeathPercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2



select  dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
Sum(vac.new_vaccinations) over(partition by dea.location Order  by dea.location,dea.date) 
--as RollingPeopleVaccinated,(RollingPeopleVaccinated/population) * 100
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =VAC.location
AND dea.date=vac.date
and dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac
(Continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as (
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
Sum(vac.new_vaccinations) over(partition by dea.location Order  by dea.location,dea.date) 
--as RollingPeopleVaccinated,(RollingPeopleVaccinated/population) * 100
from CovidDeaths dea
join CovidVaccinations vac
on dea.location =VAC.location
AND dea.date=vac.date
and dea.continent is not null)
--order by 2,3)

select * from PopvsVac



with PopvsVac (Continent,Location,Date,Population,New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over( Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
)
select *,(RollingPeopleVaccinated/population)*100 from PopvsVac

--Temple table
Create table #PercentPopulationVaccinated

(Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population float,
New_vaccination float,
RollingPeopleVaccinated float)


Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over( Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
select *,(RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated

(Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population float,
New_vaccination float,
RollingPeopleVaccinated float)


Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over( Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
select *,(RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated

--Creating wiew to store data later visualization
Create view PercentPopulationVaccinated as select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over( Partition by dea.location 
Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
select * from PercentPopulationVaccinated