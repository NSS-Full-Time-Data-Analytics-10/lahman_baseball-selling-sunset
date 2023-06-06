--QUESTION 1
--what range of years for baseball games played does the provided database cover?
--ANSWER 1871-2006, 146 years of baseball

SELECT DISTINCT yearid
FROM teams;

--QUESTION 2
--NAME AND HEIGHT OF SHORTEST PLAYER IN DATA BASE
--HOW MANY GAMES HE PLAYED IN? 1. TEAM: St.Louis
--WHERE playerid = 'gaedeed01'

SELECT CONCAT(namefirst,' ', namelast), MIN(height), g_all, name
FROM people INNER JOIN appearances USING (playerid) 
			INNER JOIN teams USING (teamid)
GROUP BY namefirst, namelast, height, g_all, name
ORDER BY height NULLS LAST
LIMIT 1;

--QUESTION 3 
--WHICH PLAYER FROM VANDERBILT EARNED THE MOST IN THE MAJORS?
--David Price with 245553888
SELECT namefirst, namelast, SUM(salary::numeric::money) AS total_salary
FROM schools AS s INNER JOIN collegeplaying AS cp ON s.schoolid = cp.schoolid
					INNER JOIN people USING (playerid)
					INNER JOIN salaries USING (playerid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY namefirst, namelast
ORDER BY total_salary DESC






