CREATE VIEW `project_view` AS
    SELECT 
        ProjectID,
        Name,
        ProjectPic,
        LearningObject,
        Instructions,
        Video,
        Activity,
        YearRange,
        Course,
        Subscription,
        Subject
    FROM
        Project AS p
            INNER JOIN
        ActivityType AS a ON a.ActivityTypeID = p.ActivityTypeID
            INNER JOIN
        YearLevel AS y ON y.YearLevelID = p.YearLevelID
            INNER JOIN
        Course AS c ON c.CourseID = p.CourseID
            INNER JOIN
        Subscription AS s ON s.SubscriptionID = p.SubscriptionID
            INNER JOIN
        SubjectMatter AS sm ON sm.SubjectMatterID = p.SubjectMatterID