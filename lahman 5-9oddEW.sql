-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places.
--    Do the same for home runs per game. Do you see any trends?
WITH stats_per_decade AS (SELECT FLOOR(yearid / 10) * 10 AS decade,
      							 ROUND(AVG(SO::numeric / G::numeric), 2) AS avg_so_per_game,
       							 ROUND(AVG(HR::numeric / G::numeric), 2) AS avg_hr_per_game
						  FROM TEAMS
						  GROUP BY FLOOR(yearid / 10)
						  ORDER BY decade)
SELECT *
FROM stats_per_decade
WHERE decade >= 1920;

-- 7.  From 1970 â€“ 2016, what is the largest number of wins for a team that did not win the world series?
--     What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion â€“ determine why this is the case.
--     Then redo your query, excluding the problem year. How often from 1970 â€“ 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
(SELECT DISTINCT yearid, teamid, SUM(w) AS wins, wswin AS world_series_win
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'N'
GROUP BY teamid, yearid, wswin
ORDER BY wins DESC
LIMIT 1)
UNION
(SELECT DISTINCT yearid, teamid, SUM(w) AS wins, wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'Y'
 	AND yearid <> 1981
GROUP BY teamid, yearid, wswin
ORDER BY wins
LIMIT 1);


-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
--	  Give their full name and the teams that they were managing when they won the award.
WITH winning_managers AS (SELECT CONCAT(namefirst, ' ', namelast) AS manager, name AS team, lgid
   						  FROM awardsmanagers
   						  INNER JOIN people USING(playerid)
 					      INNER JOIN teams USING(yearid, lgid)
 					      WHERE awardid = 'TSN Manager of the Year')
SELECT manager, team
FROM winning_managers
WHERE lgid IN ('AL', 'NL')
GROUP BY manager, team
HAVING COUNT(DISTINCT lgid) = 2;



