--QUESTION 12a explore the connection between number of wins and attendance.
--Does there appear to be any correlation between attendance at home games and number of wins?
--THOUGHTS: I don't see a correlation 

WITH wins AS
	(SELECT teamid, SUM(w) AS total_wins
	FROM teams
	GROUP BY teamid),

 big_attendance AS 
				(SELECT teamid, SUM(attendance) AS total_attendance
					FROM teams 
					GROUP BY teamid
					ORDER BY teamid)

SELECT teamid, total_wins, total_attendance
FROM teams INNER JOIN wins USING (teamid) INNER JOIN big_attendance USING (teamid)
GROUP BY teamid, total_wins, total_attendance
ORDER BY total_attendance DESC NULLS LAST;

--QUESTION 12b 
--Do teams that win the world series see a boost in attendance the following year? 
--What about teams that made the playoffs? (teams.wcwin teams.divwin)
--Making the playoffs means either being a division winner or a wild card winner
	
	--self join attempt?
SELECT t1.teamid,  t1.wswin, t1.yearid, t1.attendance, t2.wswin, t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2 USING (teamid)
WHERE t1.yearid +1 = t2.yearid
	AND t1.wswin ='Y'
	--AND t2.wswin = 'Y'
	AND t1.attendance IS NOT NULL AND t2.attendance IS NOT NULL
ORDER BY teamid;



--difficult, long way of looking:
--most of the time, yes. Boston 1912 to 1913, no 
--BSN 1914 TO 1915, NO 
--CHA 1917 to 1918 BIG no (ww1?)
--chn 1908 to 1909, no 
--cin 1989 to 1990, no 
SELECT teamid, wswin, yearid, attendance
FROM teams 
WHERE wswin IS NOT NULL
ORDER BY teamid, yearid DESC NULLS LAST;






