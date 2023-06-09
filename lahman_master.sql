--1. What range of years for baseball games played does the provided database cover? 
SELECT MIN(yearid) AS earliest, MAX(yearid) AS latest
FROM teams;


--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT CONCAT(namefirst, ' ', namelast) AS player, g_all, name, height
FROM people INNER JOIN appearances USING(playerid)
			INNER JOIN teams USING(teamid, yearid)
WHERE height = (SELECT MIN(height)FROM people);


--3. Find all players in the database who played at Vanderbilt University. Create a list showing each playerâ€™s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
SELECT namefirst, namelast, SUM(salary)::numeric::money AS total_salary 
FROM salaries INNER JOIN people USING(playerid)
WHERE playerid IN (SELECT DISTINCT playerid
					FROM schools INNER JOIN collegeplaying USING(schoolid)
			 					 INNER JOIN people USING(playerid)
					WHERE schoolname = 'Vanderbilt University')
GROUP BY namefirst, namelast
ORDER BY total_salary DESC
LIMIT 1;


--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT SUM(CASE WHEN pos IN('C', 'P') THEN po END) AS po_battery,
	   SUM(CASE WHEN pos IN('1B', '2B', '3B', 'SS') THEN po END) AS po_infield,
	   SUM(CASE WHEN pos = 'OF' THEN po END) AS po_outfield
FROM fielding
WHERE yearid = 2016;

--5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
WITH stats_per_decade AS (SELECT FLOOR(yearid / 10) * 10 AS decade,
       ROUND(SUM(SO)::numeric / SUM(G/2), 2) AS avg_strikeouts_per_game,
       ROUND(SUM(HR)::numeric / SUM(g/2), 2) AS avg_home_runs_per_game
FROM TEAMS
GROUP BY FLOOR(yearid / 10)
ORDER BY decade)
SELECT *
FROM stats_per_decade
WHERE decade >=1920;


--6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
SELECT namefirst, namelast, playerid, ROUND(sb::numeric/(cs +sb) *100, 2) AS sb_success_rate
FROM batting INNER JOIN people USING(playerid)
WHERE yearid = 2016 AND (cs + sb) >= 20
ORDER BY sb_success_rate DESC;

--7.  From 1970 â€“ 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion â€“ determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 â€“ 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
WITH most_wins AS (SELECT yearid, MAX(w) AS most_wins
					FROM teams 
				   	WHERE yearid BETWEEN 1970 AND 2016 AND yearid != 1981
					GROUP BY yearid)
SELECT ROUND(AVG(CASE WHEN wswin = 'Y' THEN 1 ELSE 0 END)*100, 2) AS pct_wins
FROM most_wins INNER JOIN teams USING(yearid)
WHERE most_wins = w;

SELECT *
FROM teams
WHERE wswin = 'N' and yearid BETWEEN 1970 AND 2016
ORDER BY w DESC

--8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
(SELECT name, park_name, homegames.attendance/games AS avg_attendance, 'top5' AS top5orbot5
FROM homegames INNER JOIN parks USING(park)
 				INNER JOIN teams ON (teams.yearid= year AND teams.teamid = team)
 WHERE year = 2016 AND games >= 10
 ORDER BY avg_attendance DESC
 LIMIT 5)
 UNION
 (SELECT name, park_name, homegames.attendance/games AS avg_attendance, 'bot5' as top5otbot5
 FROM homegames INNER JOIN parks USING(park)
 				INNER JOIN teams ON(teams.yearid = year AND teams.teamid = team)
 WHERE year = 2016 AND games >= 10
 ORDER BY avg_attendance
 LIMIT 5)
 ORDER BY avg_attendance DESC;


--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
SELECT namefirst, namelast, name, awardid, lgid, yearid
FROM awardsmanagers INNER JOIN managers USING(playerid, yearid, lgid)
					INNER JOIN teams USING(yearid, lgid, teamid)
					INNER JOIN people USING(playerid)
WHERE (playerid, awardid) IN(SELECT playerid, awardid
						 	 FROM awardsmanagers
							  WHERE lgid IN ('AL', 'NL') AND awardid = 'TSN Manager of the Year'
							 GROUP BY playerid, awardid
							 HAVING COUNT (DISTINCT lgid) = 2)


--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
WITH most_hr AS (SELECT playerid, MAX(hr) AS most_hr
				  FROM batting
				GROUP BY playerid)
SELECT namefirst, namelast, hr, debut
FROM most_hr INNER JOIN batting USING (playerid)
			 INNER JOIN people USING(playerid)
WHERE yearid = 2016 AND most_hr =hr 
					AND LEFT(debut, 4)::integer <= 2006
					AND hr >= 1
ORDER BY hr DESC;

--**Open-ended questions**

--11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

--12. In this question, you will explore the connection between number of wins and attendance.
    <ol type="a">
      <li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
      <li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.</li>
    </ol>


--13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?




































































