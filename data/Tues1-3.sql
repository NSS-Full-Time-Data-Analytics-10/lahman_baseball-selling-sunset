---1
SELECT MAX(yearid),MIN(yearid)
FROM teams;
---2
SELECT MIN(height)::numeric/12 as height_feet,p.namefirst,p.namelast,ap.g_all,ap.teamid,t.name
FROM people as p
INNER JOIN appearances as ap
USING(playerid)
INNER JOIN teams as t
USING(teamid)
GROUP BY p.namefirst,p.namelast,ap.g_all,ap.teamid,t.name
ORDER BY height_feet ASC
LIMIT 1;
---3
SELECT cp.schoolid,p.namefirst,p.namelast,SUM(s.salary::numeric::money)
FROM collegeplaying as cp
INNER JOIN people as p
USING(playerid)
INNER JOIN salaries as s
USING(playerid)
WHERE schoolid = 'vandy'
GROUP BY cp.schoolid,p.namefirst,p.namelast
ORDER BY SUM(s.salary) DESC;
---4
