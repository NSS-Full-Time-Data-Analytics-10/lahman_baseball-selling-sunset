--QUESTION 4

--Determine the number of putouts made by each of these three groups in 2016.

WITH putouts AS 
(SELECT playerid, yearid,
CASE WHEN pos = 'OF' THEN 'Outfield'
	 WHEN pos = 'SS' THEN 'INFIELD'
	 WHEN pos = '1b' THEN 'INFIELD'
	 WHEN pos = '2b' THEN 'INFIELD'
	 WHEN pos = '3b' THEN 'INFIELD'
	 WHEN pos = 'P'  THEN 'BATTERY'
	 WHEN pos = 'C'  THEN 'BATTERY'
	ELSE 'other'
	 END AS position_group
FROM fielding)

SELECT position_group, SUM(po::numeric) AS total_putouts
FROM putouts INNER JOIN fielding USING (playerid)
WHERE fielding.yearid = 2016 AND position_group NOT LIKE 'other'
GROUP BY position_group;

--QUESTION 6 
--Find the player who had the most success stealing bases in 2016,
--success is measured as the percentage of stolen base attempts which are successful. 
--or being caught stealing.) 
--Consider only players who attempted at least 20 stolen bases.

WITH successful_sb AS
(SELECT playerid, yearid, SUM(sb::numeric), SUM(cs::numeric),
sb::numeric + cs::numeric AS sb_attempts
FROM batting
GROUP BY playerid, yearid, sb, cs)

SELECT namefirst,namelast,  batting.yearid, SUM(batting.sb), ROUND(batting.sb/sb_attempts *100) AS sb_pct
FROM successful_sb INNER JOIN batting USING(playerid)
					INNER JOIN people USING (playerid)
WHERE sb_attempts > 20 AND batting.yearid = '2016'
GROUP BY namefirst, namelast, batting.yearid, batting.sb, sb_attempts
ORDER BY sb_pct DESC
LIMIT 1;

--QUESTION 8 
--Using the attendance figures from the homegames table,
--find the teams and parks which had the top 5 average attendance per game in 2016
--(where average attendance is defined as total attendance divided by number of games). 
--Only consider parks where there were at least 10 games played.
--Report the park name, team name, and average attendance.
--Repeat for the lowest 5 average attendance.

SELECT franchname, park_name, AVG(hg.attendance)/games::numeric AS avg_attendance
FROM homegames AS hg INNER JOIN teams ON hg.team = teams.teamid
					INNER JOIN teamsfranchises USING (franchid)
					INNER JOIN parks ON parks.park = hg.park
WHERE year = '2016' AND games > 10 
GROUP BY franchname, park_name, games
ORDER BY avg_attendance 
LIMIT 5; 
--top 5 avg attendance: Dodger, Cardinals, Blue Jays, Giants, Cubs
--lowest avg attendace: Rays, Athletics, Indians, Marlins, White Sox


--QUESTION 10 
--Find all players who hit their career highest number of home runs in 2016. 
--Consider only players who have played in the league for at least 10 years, 
--and who hit at least one home run in 2016.
--Report the players' first and last names and the number of home runs they hit in 2016.

WITH careerhigh AS
(SELECT playerid, yearid, 
RANK()OVER(PARTITION BY playerid ORDER BY hr)
								   AS hr_rank
									FROM batting) 

SELECT CONCAT(namefirst,' ', namelast) AS player_name, batting.yearid, SUM(hr) AS total_hr
FROM careerhigh INNER JOIN people USING (playerid)
				INNER JOIN batting USING (playerid)
WHERE batting.yearid = '2016' AND hr >=1
GROUP BY CONCAT(namefirst,' ', namelast), batting.yearid
HAVING COUNT(playerid) >=10 
ORDER BY player_name; 


