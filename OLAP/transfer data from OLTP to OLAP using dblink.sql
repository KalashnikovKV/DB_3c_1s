CREATE EXTENSION IF NOT EXISTS dblink;

SELECT dblink_connect('oltp_conn', 'dbname=use_your_db_name host=localhost user=use_your_user_name');

INSERT INTO UsersDim (UserID, Name, Email, StartDate, EndDate, IsCurrent)
SELECT DISTINCT 
    u.UserID, u.Name, u.Email, CURRENT_DATE, NULL::DATE, TRUE
FROM dblink('oltp_conn', 'SELECT UserID, Name, Email FROM Users')
AS u(UserID INT, Name VARCHAR(255), Email VARCHAR(255));

INSERT INTO VideosDim (VideoID, Title, Category, Duration, UploadDate)
SELECT DISTINCT 
    v.VideoID, v.Title, v.Category, v.Duration, v.UploadDate
FROM dblink('oltp_conn', 'SELECT VideoID, Title, Category, Duration, UploadDate FROM Videos')
AS v(VideoID INT, Title VARCHAR(255), Category VARCHAR(50), Duration INT, UploadDate TIMESTAMP);

INSERT INTO CategoriesDim (CategoryID, CategoryName)
SELECT DISTINCT 
    c.CategoryID, c.CategoryName
FROM dblink('oltp_conn', 'SELECT CategoryID, CategoryName FROM Categories')
AS c(CategoryID INT, CategoryName VARCHAR(100));

INSERT INTO TimeDim (Date, DayOfWeek, Month, Year, Quarter)
SELECT DISTINCT
    v.UploadDate AS Date,
    TO_CHAR(v.UploadDate, 'Day') AS DayOfWeek,
    TO_CHAR(v.UploadDate, 'Month') AS Month,
    EXTRACT(YEAR FROM v.UploadDate) AS Year,
    EXTRACT(QUARTER FROM v.UploadDate) AS Quarter
FROM dblink('oltp_conn', 'SELECT UploadDate FROM Videos')
AS v(UploadDate TIMESTAMP)
UNION
SELECT DISTINCT
    r.ReactionDate AS Date,
    TO_CHAR(r.ReactionDate, 'Day') AS DayOfWeek,
    TO_CHAR(r.ReactionDate, 'Month') AS Month,
    EXTRACT(YEAR FROM r.ReactionDate) AS Year,
    EXTRACT(QUARTER FROM r.ReactionDate) AS Quarter
FROM dblink('oltp_conn', 'SELECT ReactionDate FROM Reactions')
AS r(ReactionDate TIMESTAMP);

INSERT INTO VideoViewsFact (UserDimID, VideoDimID, TimeDimID, ViewCount)
SELECT
    u.UserDimID,
    vd.VideoDimID,
    t.TimeDimID,
    COUNT(v.ViewID) AS ViewCount
FROM dblink('oltp_conn', 'SELECT ViewID, VideoID, UserID, ViewDate FROM Views')
AS v(ViewID INT, VideoID INT, UserID INT, ViewDate TIMESTAMP)
JOIN UsersDim u ON v.UserID = u.UserID
JOIN VideosDim vd ON v.VideoID = vd.VideoID
JOIN TimeDim t ON v.ViewDate::DATE = t.Date
GROUP BY u.UserDimID, vd.VideoDimID, t.TimeDimID;

INSERT INTO VideoReactionsFact (UserDimID, VideoDimID, TimeDimID, ReactionType, ReactionCount)
SELECT
    u.UserDimID,
    vd.VideoDimID,
    t.TimeDimID,
    r.ReactionType,
    COUNT(r.ReactionID) AS ReactionCount
FROM dblink('oltp_conn', 'SELECT ReactionID, VideoID, UserID, ReactionType, ReactionDate FROM Reactions')
AS r(ReactionID INT, VideoID INT, UserID INT, ReactionType VARCHAR(10), ReactionDate TIMESTAMP)
JOIN UsersDim u ON r.UserID = u.UserID
JOIN VideosDim vd ON r.VideoID = vd.VideoID
JOIN TimeDim t ON r.ReactionDate::DATE = t.Date
GROUP BY u.UserDimID, vd.VideoDimID, t.TimeDimID, r.ReactionType;
