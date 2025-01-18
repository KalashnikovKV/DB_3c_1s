CREATE OR REPLACE FUNCTION load_video_data(
    users_path TEXT,
    roles_path TEXT,
    user_roles_path TEXT,
    videos_path TEXT,
    categories_path TEXT,
    views_path TEXT,
    reactions_path TEXT,
    subscriptions_path TEXT
)
RETURNS VOID AS $$
BEGIN
    CREATE TEMP TABLE temp_users (
        Name VARCHAR(255),
        Email VARCHAR(255),
        PasswordHash VARCHAR(255),
        RegistrationDate TIMESTAMP
    );

    EXECUTE FORMAT('COPY temp_users(Name, Email, PasswordHash, RegistrationDate) FROM %L DELIMITER '','' CSV HEADER', users_path);

    INSERT INTO Users (Name, Email, PasswordHash, RegistrationDate)
    SELECT Name, Email, PasswordHash, RegistrationDate
    FROM temp_users
    ON CONFLICT (Email) DO NOTHING;

    CREATE TEMP TABLE temp_roles (
        RoleName VARCHAR(50)
    );

    EXECUTE FORMAT('COPY temp_roles(RoleName) FROM %L DELIMITER '','' CSV HEADER', roles_path);

    INSERT INTO Roles (RoleName)
    SELECT RoleName
    FROM temp_roles
    ON CONFLICT (RoleName) DO NOTHING;

    CREATE TEMP TABLE temp_user_roles (
        UserID INT,
        RoleID INT
    );

    EXECUTE FORMAT('COPY temp_user_roles(UserID, RoleID) FROM %L DELIMITER '','' CSV HEADER', user_roles_path);

    INSERT INTO UserRoles (UserID, RoleID)
    SELECT UserID, RoleID
    FROM temp_user_roles
    ON CONFLICT DO NOTHING;

    CREATE TEMP TABLE temp_videos (
        Title VARCHAR(255),
        Description TEXT,
        Duration INT,
        Category VARCHAR(50),
        UploadDate TIMESTAMP
    );

    EXECUTE FORMAT('COPY temp_videos(Title, Description, Duration, Category, UploadDate) FROM %L DELIMITER '','' CSV HEADER', videos_path);

    INSERT INTO Videos (Title, Description, Duration, Category, UploadDate)
    SELECT Title, Description, Duration, Category, UploadDate
    FROM temp_videos
    ON CONFLICT (Title) DO NOTHING;

    CREATE TEMP TABLE temp_categories (
        CategoryName VARCHAR(100)
    );

    EXECUTE FORMAT('COPY temp_categories(CategoryName) FROM %L DELIMITER '','' CSV HEADER', categories_path);

    INSERT INTO Categories (CategoryName)
    SELECT CategoryName
    FROM temp_categories
    ON CONFLICT (CategoryName) DO NOTHING;

    CREATE TEMP TABLE temp_views (
        VideoID INT,
        UserID INT,
        ViewDate TIMESTAMP
    );

    EXECUTE FORMAT('COPY temp_views(VideoID, UserID, ViewDate) FROM %L DELIMITER '','' CSV HEADER', views_path);

    INSERT INTO Views (VideoID, UserID, ViewDate)
    SELECT VideoID, UserID, ViewDate
    FROM temp_views
    ON CONFLICT DO NOTHING;

    CREATE TEMP TABLE temp_reactions (
        VideoID INT,
        UserID INT,
        ReactionType VARCHAR(10),
        ReactionDate TIMESTAMP
    );

    EXECUTE FORMAT('COPY temp_reactions(VideoID, UserID, ReactionType, ReactionDate) FROM %L DELIMITER '','' CSV HEADER', reactions_path);

    INSERT INTO Reactions (VideoID, UserID, ReactionType, ReactionDate)
    SELECT VideoID, UserID, ReactionType, ReactionDate
    FROM temp_reactions
    ON CONFLICT DO NOTHING;

    CREATE TEMP TABLE temp_subscriptions (
        SubscriberID INT,
        SubscribedToID INT,
        SubscriptionDate TIMESTAMP
    );

    EXECUTE FORMAT('COPY temp_subscriptions(SubscriberID, SubscribedToID, SubscriptionDate) FROM %L DELIMITER '','' CSV HEADER', subscriptions_path);

    INSERT INTO Subscriptions (SubscriberID, SubscribedToID, SubscriptionDate)
    SELECT SubscriberID, SubscribedToID, SubscriptionDate
    FROM temp_subscriptions
    ON CONFLICT DO NOTHING;

    DROP TABLE IF EXISTS temp_users, temp_roles, temp_user_roles, temp_videos, temp_categories, temp_views, temp_reactions, temp_subscriptions;
END;
$$ LANGUAGE plpgsql;


SELECT load_video_data(
    'use_your_path/Data_to_OLTP/users.csv',
    'use_your_path/Data_to_OLTP/roles.csv',
    'use_your_path/Data_to_OLTP/user_roles.csv',
    'use_your_path/Data_to_OLTP/videos.csv',
    'use_your_path/Data_to_OLTP/categories.csv',
    'use_your_path/Data_to_OLTP/views.csv',
    'use_your_path/Data_to_OLTP/reactions.csv',
    'use_your_path/Data_to_OLTP/subscriptions.csv'
);

