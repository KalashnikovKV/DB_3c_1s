--1. Пользователи с наибольшим количеством просмотров
SELECT 
    u.UserID,
    u.Name,
    u.Email,
    COUNT(v.ViewID) AS TotalViews
FROM 
    Users u
JOIN 
    Views v ON u.UserID = v.UserID
GROUP BY 
    u.UserID, u.Name, u.Email
ORDER BY 
    TotalViews DESC
LIMIT 10;


--2. Видео с наибольшим количеством реакций
SELECT 
    v.VideoID,
    v.Title,
    COUNT(r.ReactionID) AS TotalReactions
FROM 
    Videos v
JOIN 
    Reactions r ON v.VideoID = r.VideoID
GROUP BY 
    v.VideoID, v.Title
ORDER BY 
    TotalReactions DESC
LIMIT 10;

--3. Категории с наибольшим количеством видео
SELECT 
    c.CategoryName,
    COUNT(v.VideoID) AS TotalVideos
FROM 
    Categories c
JOIN 
    Videos v ON c.CategoryName = v.Category
GROUP BY 
    c.CategoryName
ORDER BY 
    TotalVideos DESC;
