--Топ-10 видео по количеству просмотров
SELECT 
    vd.Title,
    SUM(f.ViewCount) AS TotalViews
FROM 
    VideoViewsFact f
JOIN 
    VideosDim vd ON f.VideoDimID = vd.VideoDimID
GROUP BY 
    vd.Title
ORDER BY 
    TotalViews DESC
LIMIT 10;



--Соотношение просмотров и лайков по видео
SELECT 
    vd.Title,
    SUM(vf.ViewCount) AS TotalViews,
    SUM(CASE WHEN rf.ReactionType = 'Like' THEN rf.ReactionCount ELSE 0 END) AS TotalLikes
FROM 
    VideoViewsFact vf
JOIN 
    VideosDim vd ON vf.VideoDimID = vd.VideoDimID
LEFT JOIN 
    VideoReactionsFact rf ON rf.VideoDimID = vd.VideoDimID
GROUP BY 
    vd.Title
ORDER BY 
    TotalViews DESC, TotalLikes DESC;

