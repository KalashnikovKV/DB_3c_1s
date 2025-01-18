CREATE TABLE UsersDim (
    UserDimID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Name VARCHAR(255),
    Email VARCHAR(255),
    StartDate DATE NOT NULL,
    EndDate DATE,
    IsCurrent BOOLEAN DEFAULT TRUE
);


CREATE TABLE VideosDim (
    VideoDimID SERIAL PRIMARY KEY,
    VideoID INT NOT NULL,
    Title VARCHAR(255),
    Category VARCHAR(100),
    Duration INT,
    UploadDate DATE
);

CREATE TABLE CategoriesDim (
    CategoryDimID SERIAL PRIMARY KEY,
    CategoryID INT NOT NULL,
    CategoryName VARCHAR(100)
);


CREATE TABLE TimeDim (
    TimeDimID SERIAL PRIMARY KEY,
    Date DATE NOT NULL,
    DayOfWeek VARCHAR(20),
    Month VARCHAR(20),
    Year INT,
    Quarter INT
);


CREATE TABLE VideoViewsFact (
    FactID SERIAL PRIMARY KEY,
    UserDimID INT NOT NULL,
    VideoDimID INT NOT NULL,
    TimeDimID INT NOT NULL,
    ViewCount INT,
    FOREIGN KEY (UserDimID) REFERENCES UsersDim(UserDimID),
    FOREIGN KEY (VideoDimID) REFERENCES VideosDim(VideoDimID),
    FOREIGN KEY (TimeDimID) REFERENCES TimeDim(TimeDimID)
);


CREATE TABLE VideoReactionsFact (
    FactID SERIAL PRIMARY KEY,
    UserDimID INT NOT NULL,
    VideoDimID INT NOT NULL,
    TimeDimID INT NOT NULL,
    ReactionType VARCHAR(10),
    ReactionCount INT,
    FOREIGN KEY (UserDimID) REFERENCES UsersDim(UserDimID),
    FOREIGN KEY (VideoDimID) REFERENCES VideosDim(VideoDimID),
    FOREIGN KEY (TimeDimID) REFERENCES TimeDim(TimeDimID)
);

