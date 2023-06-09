-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. 
--	   As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.
WITH winvsalary AS (SELECT s.yearid, teamid, SUM(salary::numeric)::money AS team_salary, COUNT(w) AS wins, teams.lgid 
					FROM salaries AS s INNER JOIN teams USING(teamid)
					WHERE s.yearid = 2000 AND teams.lgid = 'AL'
					GROUP BY s.yearid, teamid, teams.lgid)
SELECT DISTINCT teamid, wins, team_salary
FROM winvsalary
ORDER BY wins DESC;




-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim.
--     First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?
SELECT DISTINCT CONCAT(p.namefirst, ' ', p.namelast) AS pitcher, p.throws, 
       (SELECT SUM(pi.so) AS strikeouts FROM pitching AS pi WHERE pi.playerid = p.playerid) AS total_strikeouts
FROM people AS p
INNER JOIN pitching AS pit ON p.playerid = pit.playerid
WHERE p.throws = 'L'
ORDER BY (SELECT SUM(pi.so) AS strikeouts FROM pitching AS pi WHERE pi.playerid = p.playerid) DESC;





































