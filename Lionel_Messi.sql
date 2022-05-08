-- Inspecting data
SELECT * FROM [dbo].[Lionel Messi]

-- Goals per competition
SELECT Competition, COUNT(Competition) AS Goals_per_competition
FROM [dbo].[Lionel Messi]
GROUP BY Competition 
ORDER BY Goals_per_competition DESC 


-- Goals per season 
SELECT Season, COUNT(Season) AS Goals_per_season
FROM [dbo].[Lionel Messi]
GROUP BY Season 
ORDER BY Goals_per_season DESC


-- Goals per Club
SELECT Club, COUNT(club) AS Goals_per_club
FROM [dbo].[Lionel Messi]
GROUP BY Club 
ORDER BY Goals_per_club DESC 


-- Goals per playing position
SELECT Playing_Position, COUNT(Playing_Position) AS Goals_per_playing_position
FROM [dbo].[Lionel Messi]
GROUP BY Playing_Position
ORDER BY Goals_per_playing_position DESC 


-- Goals Per Game Minute 
SELECT Minute, COUNT(Minute) AS Goals_per_game_minute 
FROM [dbo].[Lionel Messi]
GROUP BY Minute 
ORDER BY Goals_per_game_minute DESC 


-- Goals Per Type of Goal
SELECT Type, COUNT(Type) AS Goal_type
FROM [dbo].[Lionel Messi]
GROUP BY Type 
ORDER BY Goal_Type DESC 


-- Scoreline after goal
SELECT At_score, COUNT(At_score) AS Scoreline
FROM [dbo].[Lionel Messi]
GROUP BY At_score 
ORDER BY Scoreline DESC 


-- Opponents 
SELECT Opponent, COUNT(Opponent) AS Total_Opponents
FROM [dbo].[Lionel Messi]
GROUP BY Opponent 
ORDER BY Total_Opponents DESC 


-- Home-Away Goals
SELECT Venue, COUNT(Venue) AS Home_VS_Away
FROM [dbo].[Lionel Messi]
Group by Venue 

