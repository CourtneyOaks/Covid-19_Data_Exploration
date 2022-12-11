/*
 Covid-19 Data Exploration
 Data from Our World In Data (https://ourworldindata.org/covid-deaths)
 
 Skills used: Aggregate Functions, Creating Views, Converting Data Types, Joins
 */

select *
from "CovidDeaths.csv" cdc
where continent is not null 
limit 100

select *
from "CovidVaccinations.csv" cvc
where continent is not null 
limit 100



-- Selecting Data that I plan on working with

select 
location,
date,
total_cases, 
new_cases, 
total_deaths,
population
from "CovidDeaths.csv" cdc
where continent is not null 
order by 1,2



-- Total Cases vs Total Deathes (shows likelihood of dying if you contract Covid-19 in your country)

select 
location,
date,
total_cases, 
total_deaths, 
(total_deaths/total_cases) * 100 as death_percentage
from "CovidDeaths.csv" cdc 
where 
location like '%States%'
and continent is not null
order by 1,2



-- Total Cases vs Population (shows what percentage of population infected with Covid-19)
select 
location,
date,
population,
total_cases,
(total_cases/population)*100 as percent_population_infected
from "CovidDeaths.csv" cdc 
where 
location like '%States%'
and continent is not null 
order by 1,2



-- Countries with Highest Infection Rate compared to Population
select 
location,
population,
MAX(total_cases) as highest_infection_count,
MAX(total_cases/population)*100 as percent_population_infected
from "CovidDeaths.csv" cdc
where continent is not null
group by location, population
order by percent_population_infected desc



-- Countries with Highest Death Count per Population
select 
location,
MAX(cast(total_deaths as int)) as total_death_count
from "CovidDeaths.csv" cdc
where continent is not null
group by location
order by total_death_count desc



-- Showing continents with the highest death count per population

select 
continent,
MAX(cast(total_deaths as int)) as total_death_count
from "CovidDeaths.csv" cdc
where continent is not null 
group by continent
order by total_death_count desc



-- Finding New Cases in the last 7 Days vs New Cases that Day
select 
continent, 
location, 
date, 
population, 
new_cases, 
SUM(new_cases)
	over (partition by location order by date rows between 6 preceding and current row) as Cases_Last_7Day
from "CovidDeaths.csv" cdc
where continent is not null




--GLOBAL NUMBERS
select 
SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as death_percentage
from "CovidDeaths.csv" cdc
where continent is not null
order by 1,2



-- Joining our CovidDeaths and CovidVaccinations tables together

select * 
from "CovidDeaths.csv" cdc
join "CovidVaccinations.csv" cvc
	on cdc.location = cvc.location
	and cdc.date = cvc.date



-- Total Population vs New Vaccinations
select
cdc.continent,
cdc.location,
cdc.date,
cdc.population, 
cvc.new_vaccinations
from "CovidDeaths.csv" cdc
join "CovidVaccinations.csv" cvc
	on cdc.location = cvc.location
	and cdc.date = cvc.date
where cdc.continent is not null
order by 1,2,3



