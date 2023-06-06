-- 1. What range of years for baseball games played does the provided database cover? 
SELECT DISTINCT yearid
FROM teams;
-- 1871-2016

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT CONCAT(namefirst,' ',namelast) AS player, height::numeric, g_all AS appearance_count, name AS team
FROM people INNER JOIN appearances USING(playerid) 
			INNER JOIN teams USING(teamid) 
ORDER BY height NULLS LAST
LIMIT 1;
--Eddie Gaedel was 43in tall and only played 1 game in his entire career for the St. Louis Browns.

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each playerâ€™s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT namefirst, namelast, SUM(salary::numeric::money) AS total_salary
FROM schools AS s INNER JOIN collegeplaying AS cp ON s.schoolid = cp.schoolid
					INNER JOIN people USING (playerid)
					INNER JOIN salaries USING (playerid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY namefirst, namelast
ORDER BY total_salary DESC;

SELECT DISTINCT lgid
FROM salaries








































